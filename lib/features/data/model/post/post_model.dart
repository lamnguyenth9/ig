import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ig/features/domain/entities/posts/post_entity.dart';

class PostModel extends PostEntity {
  final String? postId;
  final String? creatorUid;
  final String? username;
  final String? description;
  final String? postImageUrl;
  final List<String>? likes;
  final num? totalLikes;
  final num? totalComments;
  final Timestamp? createAt;
  final String? userProfileUrl;

  PostModel(
      {this.postId,
      this.creatorUid,
      this.username,
      this.description,
      this.postImageUrl,
      this.likes,
      this.totalLikes,
      this.totalComments,
      this.createAt,
      this.userProfileUrl})
      : super(
            postId: postId,
            creatorUid: creatorUid,
            username: username,
            description: description,
            postImageUrl: postImageUrl,
            likes: likes,
            totalLikes: totalLikes,
            totalComments: totalComments,
            createAt: createAt,
            userProfileUrl: userProfileUrl);
  factory PostModel.fromSnapshot(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return PostModel(
      postId: snap['postId'],
      creatorUid: snap['creatorUid'],
      username: snap['username'],
      description: snap['description'],
      postImageUrl: snap['postImageUrl'],
      likes: List.from(snap['likes']),
      totalLikes: snap['totalLikes'],
      totalComments: snap['totalComments'],
      createAt: snap['createAt'],
      userProfileUrl: snap['userProfileUrl'],
    );
  }
  Map<String, dynamic> toJson() => {
        "postId": postId,
        "creatorUid": creatorUid,
        "username": username,
        "description": description,
        "postImageUrl": postImageUrl,
        "likes": likes,
        "totalLikes": totalLikes,
        "totalComments": totalComments,
        "createAt": createAt,
        "userProfileUrl": userProfileUrl,
      };
}
