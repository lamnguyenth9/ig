import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ig/features/data/model/post/post_model.dart';
import 'package:ig/features/domain/entities/comment/comment_entity.dart';

class CommentModel extends CommentEntity {
  final String? commentId;
  final String? postId;
  final String? creatorUid;
  final String? description;
  final String? username;
  final String? userProfileUrl;
  final Timestamp? createAt;
  final List<String>? likes;
  final num? totalReplays;

  CommentModel(
      {this.commentId,
      this.postId,
      this.creatorUid,
      this.description,
      this.username,
      this.userProfileUrl,
      this.createAt,
      this.likes,
      this.totalReplays}):super(
        commentId: commentId,
        postId: postId,
        creatorUid: creatorUid,
        description: description,
        username: username,
        userProfileUrl: userProfileUrl,
        createAt: createAt,
        likes: likes,
        totalReplays: totalReplays
      );
      factory CommentModel.fromSnapshot(DocumentSnapshot snapshot){
        var snap=snapshot.data()as Map<String,dynamic>;
        return CommentModel(
           commentId: snap['commentId'],
           postId: snap['postId'],
           creatorUid: snap['creatorUid'],
           description: snap['description'],
           username: snap['username'],
           userProfileUrl: snap['userProfileUrl'],
           createAt: snap['createAt'],
           likes: List.from(snap['likes']),
           totalReplays: snap['totalLikes']
        );
      }
      Map<String,dynamic> toJson()=>{
        'commentId':commentId,
        'postId':postId,
        'creatorUid':creatorUid,
        'description':description,
        'username':username,
        'userProfileUrl':userProfileUrl,
        'createAt':createAt,
        'likes':likes,
        'totalReplays':totalReplays,
      };  
}
