import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ig/features/domain/entities/user/user_entity.dart';

class UserModel extends UserEntity {
  final String? uid;
  final String? username;
  final String? onlyname;
  final String? bio;
  final String? website;
  final String? email;
  final String? profileUrl;
  final List? followers;
  final List? following;
  final num? totalFollowers;
  final num? totalFollowing;
  final num? totalPosts;

  //
  final String? password;
  final String? otherUid;

  UserModel(
      {this.uid,
      this.username,
      this.onlyname,
      this.bio,
      this.website,
      this.email,
      this.profileUrl,
      this.followers,
      this.following,
      this.totalFollowers,
      this.totalFollowing,
      this.password,
      this.otherUid, this.totalPosts}):super(
        uid: uid,
        username: username,
        onlyname: onlyname,
        bio: bio,
        website: website,
        email: email,
        profileUrl: profileUrl,
        followers: followers,
        following: following,
        totalPosts: totalPosts
      );

    factory UserModel.fromSnapshot(DocumentSnapshot snapshot){
      var snap=snapshot.data() as Map<String, dynamic>;
      return UserModel(
        uid: snap['uid'],
        username: snap['username'],
        onlyname: snap['onlyname'],
        bio: snap['bio'],
        website: snap['website'],
        email: snap['email'],
        profileUrl: snap['profileUrl'],
        followers: List.from(snapshot.get("followers")),
        following: List.from(snapshot.get("following")),
        totalFollowers: snap['totalFollowers'],
        totalFollowing: snap['totalFollowing'],
        totalPosts: snap['totalPosts']
      );
    }
    Map<String, dynamic> toJson()=>
    {
      "uid":uid,
      "username":username,
      "onlyname":onlyname,
      "bio":bio,
      "website":website,
      "email":email,
      "profileUrl":profileUrl,
      "followers":followers,
      "following":following,
      "totalFollowers":totalFollowers,
      "totalFollowing":totalFollowing,
      "totalPosts":totalPosts,
    };
}
