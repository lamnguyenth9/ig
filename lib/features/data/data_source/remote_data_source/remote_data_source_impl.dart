import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ig/const.dart';
import 'package:ig/features/data/data_source/remote_data_source/remote_data_source.dart';
import 'package:ig/features/data/model/comment/comment_model.dart';
import 'package:ig/features/data/model/post/post_model.dart';
import 'package:ig/features/data/model/replay/replay_model.dart';
import 'package:ig/features/data/model/user/user_model.dart';
import 'package:ig/features/domain/entities/comment/comment_entity.dart';
import 'package:ig/features/domain/entities/posts/post_entity.dart';
import 'package:ig/features/domain/entities/reply/replay_entity.dart';
import 'package:ig/features/domain/entities/user/user_entity.dart';
import 'package:uuid/uuid.dart';

class RemoteDataSourceImpl implements FirebaseRemoteDataSource{
  final FirebaseFirestore firebaseFirestore;
   final FirebaseAuth firebaseAuth;
   final FirebaseStorage firebaseStorage;
   RemoteDataSourceImpl({required this.firebaseAuth,required this.firebaseFirestore,required this.firebaseStorage});
  @override
  Future<void> createUser(UserEntity user)async {
   final userCollection=firebaseFirestore.collection(FirebaseConst.users);
   
   final uid= await getCurrentUid();
      

   userCollection.doc(uid).get().then((userDoc){
        final newUser=UserModel(
          uid: uid,
          email: user.email,
          username: user.username,
          bio:user.bio,
          following: user.following,
          website: user.website,
          profileUrl: user.profileUrl,
          onlyname: user.onlyname,
          totalFollowers: user.totalFollowers,
          followers: user.followers,
          totalFollowing: user.totalFollowing,
          totalPosts: user.totalPosts,

        ).toJson();
        if(!userDoc.exists){
          
          userCollection.doc(uid).set(newUser);
        
        }else{
          
          userCollection.doc(uid).update(newUser);
        }
   }).catchError((error){
    toast("some error occur");
   });
  }
  
  Future<void> createUserWithImage(UserEntity user,String profileUrl)async {
   final userCollection=firebaseFirestore.collection(FirebaseConst.users);
   
   final uid= await getCurrentUid();
      

   userCollection.doc(uid).get().then((userDoc){
        final newUser=UserModel(
          uid: uid,
          email: user.email,
          username: user.username,
          bio:user.bio,
          following: user.following,
          website: user.website,
          profileUrl: profileUrl,
          onlyname: user.onlyname,
          totalFollowers: user.totalFollowers,
          followers: user.followers,
          totalFollowing: user.totalFollowing,
          totalPosts: user.totalPosts,

        ).toJson();
        if(!userDoc.exists){
          
          userCollection.doc(uid).set(newUser);
        
        }else{
          
          userCollection.doc(uid).update(newUser);
        }
   }).catchError((error){
    toast("some error occur");
   });
  }

  @override
  Future<String>  getCurrentUid() async=>firebaseAuth.currentUser!.uid;

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    final userCollection=firebaseFirestore.collection(FirebaseConst.users).where("uid",isEqualTo: uid).limit(1);
    return userCollection.snapshots().map((querySnapshot)=>querySnapshot.docs.map((e)=>UserModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) {
    final userCollection=firebaseFirestore.collection(FirebaseConst.users)  ;
    return userCollection.snapshots().map((querySnapshot)=>querySnapshot.docs.map((e)=>UserModel.fromSnapshot(e)).toList());
  }

  @override
  Future<bool> isSignIn() async =>firebaseAuth.currentUser?.uid !=null;

  @override
  Future<void> signInUser(UserEntity user) async{
    try{
     if(user.email!.isNotEmpty||user.password!.isNotEmpty){
      await firebaseAuth.signInWithEmailAndPassword(email: user.email!, password: user.password!);
     }else{
      toast("fields can not be empty ");
     }
    }on FirebaseAuthException catch(e){
      if(e.code=="user-not-found"){
        toast('User not found');
      }else if(e.code=="wrong-password"){
        toast('invalid email or passwors');
      }
    }
  }

  @override
  Future<void> signOut()async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> signUpUser(UserEntity user)async {
    try{
      print("1");
      await firebaseAuth.createUserWithEmailAndPassword(email: user.email!, password: user.password!).then((value)async{
        print("3");
        if(value.user?.uid !=null){
          if(user.imageFile!=null){
            uploadImageToStorage(user.imageFile, false, "profileImages").then((profileUrl){
              createUserWithImage(user, profileUrl);
            });
          }else{
            createUserWithImage(user, "");
          }
            
           
        }
      });
      
    }on FirebaseAuthException catch(e){
       if(e.code=='email-already-in-use'){
        toast("email is already taken");
       }else{
        toast("some thing went wrong");
       }
    }
  }

  @override
  Future<void> updateUser(UserEntity user)async {
    final userCollection= firebaseFirestore.collection(FirebaseConst.users);
    Map<String,dynamic> userInfor=    Map();
    if(user.username!=""&&user.username!=null) userInfor['username']=user.username!;
    if(user.website!=""&&user.website!=null) userInfor['website']=user.website!;
    if(user.profileUrl!=""&&user.profileUrl!=null) userInfor['profileUrl']=user.profileUrl!;
    if(user.bio!=""&&user.bio!=null) userInfor['bio']=user.bio!;
    if(user.onlyname!=""&&user.onlyname!=null) userInfor['onlyname']=user.onlyname!;
    if(user.totalFollowers!=null) userInfor['totalFollowers']=user.totalFollowers!;
    if(user.totalFollowing!=null) userInfor['totalFollowing']=user.totalFollowing!;
    if(user.totalPosts!=null) userInfor['totalPosts']=user.totalPosts!;
    userCollection.doc(user.uid).update(userInfor);
  }

  @override
  Future<String> uploadImageToStorage(File? file, bool isPost, String childName) async{
    Reference ref=firebaseStorage.ref().child(childName).child(firebaseAuth.currentUser!.uid);
    if(isPost){
      String id=Uuid().v1();
      ref=ref.child(id);
    }
    final upLoadTask=ref.putFile(file!);
    final imageUrl=(await upLoadTask.whenComplete((){})).ref.getDownloadURL();
    return await imageUrl;
  }

  @override
  Future<void> createPost(PostEntity post)async {
    final postCollection=firebaseFirestore.collection(FirebaseConst.posts);
    final newPost=PostModel(
      userProfileUrl: post.userProfileUrl,
      username: post.username,
      totalLikes: 0,
      totalComments: 0,
      postImageUrl: post.postImageUrl,
      postId: post.postId,
      likes: [],
      description: post.description,
      creatorUid: post.creatorUid,
      createAt: post.createAt
    ).toJson();
    try{
      print("1");
      final postDocRef=await postCollection.doc(post.postId).get();
      print("2");
      if(!postDocRef.exists){
        print("3");
        postCollection.doc(post.postId).set(newPost).then((value){
          final userCollection=firebaseFirestore.collection(FirebaseConst.users).doc(post.creatorUid);
          userCollection.get().then((value){
            if(value.exists){
              final totalPosts=value.get('totalPosts');
              userCollection.update({'totalPosts':totalPosts+1});
            }
          });
        });
      }else{
        print("4");
        postCollection.doc(post.postId).update(newPost);
      }
    }catch(e){
      toast("Some error: $e");
    }
  }

  @override
  Future<void> deletePost(PostEntity post) async{
    final postCollection=firebaseFirestore.collection(FirebaseConst.posts);
    try{
      postCollection.doc(post.postId).delete().then((value){
          final userCollection=firebaseFirestore.collection(FirebaseConst.users).doc(post.creatorUid);
          userCollection.get().then((value){
            if(value.exists){
              final totalPosts=value.get('totalPosts');
              userCollection.update({'totalPosts':totalPosts-1});
            }
          });
        });
    }catch(e){
       toast("some error: $e",);
    }
  }

  @override
  Future<void> likePost(PostEntity post) async{
    final postCollection=firebaseFirestore.collection(FirebaseConst.posts);
    final currentUid=await getCurrentUid();
    final postRef=await postCollection.doc(post.postId).get();
    if(postRef.exists){
      List likes = postRef.get("likes");
      final totalLikes=postRef.get("totalLikes");
      if(likes.contains(currentUid)){
        postCollection.doc(post.postId).update({
          "likes":FieldValue.arrayRemove([currentUid]),
          "totalLikes":totalLikes-1
        });
      }else{
        postCollection.doc(post.postId).update({
          "likes":FieldValue.arrayUnion([currentUid]),
          "totalLikes":totalLikes+1
        });
      }
    }
  }

  @override
  Stream<List<PostEntity>> readPosts(PostEntity post) {
    final postCollection=firebaseFirestore.collection(FirebaseConst.posts).orderBy("createAt",descending: true);
    return postCollection.snapshots().map((querySnapshot)=>querySnapshot.docs.map((e)=>PostModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updatePost(PostEntity post)async {
    final postCollection=firebaseFirestore.collection(FirebaseConst.posts);
    Map<String, dynamic> postInfor=Map();
    if(post.description!=""&&post.description!=null) postInfor['description']=post.description;
    if(post.postImageUrl!=""&&post.postImageUrl!=null) postInfor['postImageUrl']=post.postImageUrl;
    postCollection.doc(post.postId).update(postInfor);
  }

  @override
  Stream<List<PostEntity>> readSinglePost(String postId) {
    final postCollection=firebaseFirestore.collection(FirebaseConst.posts).orderBy("createAt",descending: true).where("postId",isEqualTo: postId);
    return postCollection.snapshots().map((querySnapshot)=>querySnapshot.docs.map((e)=>PostModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> createComment(CommentEntity comment)async {
    final commentCollection=firebaseFirestore.collection(FirebaseConst.posts).doc(comment.postId).collection(FirebaseConst.comment);

    final newComment= CommentModel(
      commentId: comment.commentId,
      createAt: comment.createAt,
      creatorUid: comment.creatorUid,
      description: comment.description,
      likes: [],
      postId: comment.postId,
      totalReplays: 0,
      userProfileUrl: comment.userProfileUrl,
      username: comment.username
    ).toJson();
    try{
      final commentDocRef=await commentCollection.doc(comment.commentId).get();
      if(!commentDocRef.exists){
        commentCollection.doc(comment.commentId).set(newComment).then((value){
          final postCollection=firebaseFirestore.collection(FirebaseConst.posts).doc(comment.postId);
          postCollection.get().then((value){
            if(value.exists){
              final totalComments=value.get('totalComments');
              postCollection.update({"totalComments":totalComments+1});
              return;
            }
          });
        });
      }else{
        commentCollection.doc(comment.commentId).update(newComment);
      }
    }catch(e){
      print("some error: $e");
    }
  }

  @override
  Future<void> deleteComment(CommentEntity comment)async {
    final commentCollection=firebaseFirestore.collection(FirebaseConst.posts).doc(comment.postId).collection(FirebaseConst.comment);
    try{
      commentCollection.doc(comment.commentId).delete().then((value){
        final postCollection=firebaseFirestore.collection(FirebaseConst.posts).doc(comment.postId);
          postCollection.get().then((value){
            if(value.exists){
              final totalComments=value.get('totalComments');
              postCollection.update({"totalComments":totalComments-1});
              return;
            }
          });
      });
    }catch(e){
       toast("some error: $e",);
    }
  }

  @override
  Future<void> likeComment(CommentEntity comment)async {
    final commentCollection=firebaseFirestore.collection(FirebaseConst.posts).doc(comment.postId).collection(FirebaseConst.comment);
    final currentUid=await getCurrentUid();
    final commentRef=await commentCollection.doc(comment.commentId).get();
    if(commentRef.exists){
      List likes=commentRef.get("likes");
      if(likes.contains(currentUid)){
        commentCollection.doc(comment.commentId).update({
          "likes":FieldValue.arrayRemove([currentUid])
        });
      }else{
          commentCollection.doc(comment.commentId).update({
          "likes":FieldValue.arrayUnion([currentUid])
        });
      }
    }
  }

  @override
  Stream<List<CommentEntity>> readComments(String postId) {

    final commentCollection=firebaseFirestore.collection(FirebaseConst.posts).doc(postId).collection(FirebaseConst.comment).orderBy("createAt",descending: true);
    return commentCollection.snapshots().map((querySnapshot)=>querySnapshot.docs.map((e)=>CommentModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateComment(CommentEntity comment)async   {
    final commentCollection=firebaseFirestore.collection(FirebaseConst.posts).doc(comment.postId).collection(FirebaseConst.comment);
    Map<String,dynamic> commentInfor=Map();
    if(comment.description!=""&&comment.description!=null) commentInfor['description']=comment.description;
    commentInfor['createAt']=FieldValue.serverTimestamp();
    commentCollection.doc(comment.commentId).update(commentInfor);
  }

  @override
  Future<void> createReplay(ReplayEntity replay)async {
    final replayCollection=firebaseFirestore.collection(FirebaseConst.posts).doc(replay.postId).collection(FirebaseConst.comment).doc(replay.commentId).collection(FirebaseConst.replay);
    final newReplay=ReplayModel(
      creatorUid: replay.creatorUid,
      commentId: replay.commentId,
      createAt: replay.createAt,
      description: replay.description,
      likes: [],
      postId: replay.postId,
      replayId: replay.replayId,
      username: replay.username,
      userprofileUrl: replay.userprofileUrl
    ).toJson();
    try{
      final replayDocRef=await replayCollection.doc(replay.replayId).get();
      if(!replayDocRef.exists){
        replayCollection.doc(replay.replayId).set(newReplay)
        .then((value){
          final commentCollection=firebaseFirestore.collection(FirebaseConst.posts).doc(replay.postId).collection(FirebaseConst.comment).doc(replay.commentId);
          commentCollection.get().then((value){
            if(value.exists){
              final totalReplays=value.get('totalReplays');
              commentCollection.update({'totalReplays':totalReplays+1});
              print(totalReplays);
            }
          });
        });
      }else{
        replayCollection.doc(replay.replayId).update(newReplay);
      }
    }catch(e){
      print("some error: $e");
    }
  }

  @override
  Future<void> deleteReplay(ReplayEntity replay)async {
    final replayCollection=firebaseFirestore.collection(FirebaseConst.posts).doc(replay.postId).collection(FirebaseConst.comment).doc(replay.commentId).collection(FirebaseConst.replay);
    try{
       replayCollection.doc(replay.replayId).delete().then((value){
        final  commentCollection=firebaseFirestore.collection(FirebaseConst.posts).doc(replay.postId).collection(FirebaseConst.comment).doc(replay.commentId);
        commentCollection.get().then((value){
          if(value.exists){
            final totalReplays=value.get('totalReplays');
            commentCollection.update({'totalReplays':totalReplays-1});
          }
        });
       });
    }catch(e){
      print("some error: $e");
    }
  }

  @override
  Future<void> likeReplay(ReplayEntity replay)async {
    final replayCollection=firebaseFirestore.collection(FirebaseConst.posts).doc(replay.postId).collection(FirebaseConst.comment).doc(replay.commentId).collection(FirebaseConst.replay);
    final currentUid=await getCurrentUid();
    final replaytRef=await replayCollection.doc(replay.replayId).get();
    if(replaytRef.exists){
      List likes=replaytRef.get("likes");
      if(likes.contains(currentUid)){
        replayCollection.doc(replay.replayId).update({
          "likes":FieldValue.arrayRemove([currentUid])
        });
      }else{
          replayCollection.doc(replay.replayId).update({
          "likes":FieldValue.arrayUnion([currentUid])
        });
      }
    }
  }

  @override
  Stream<List<ReplayEntity>> readReplays(ReplayEntity replay) {
    final replayCollection=firebaseFirestore.collection(FirebaseConst.posts).doc(replay.postId).collection(FirebaseConst.comment).doc(replay.commentId).collection(FirebaseConst.replay);
    return replayCollection.snapshots().map((querySnapshot)=>querySnapshot.docs.map((e)=>ReplayModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateReplay(ReplayEntity replay) async{
    final replayCollection=firebaseFirestore.collection(FirebaseConst.posts).doc(replay.postId).collection(FirebaseConst.comment).doc(replay.commentId).collection(FirebaseConst.replay);
    Map<String,dynamic> replayInfor=Map();
    if(replay.description!=""&&replay.description!=null) replayInfor['description']=replay.description;
    replayInfor['createAt']=FieldValue.serverTimestamp();
    replayCollection.doc(replay.replayId).update(replayInfor);
  }
  
  

}