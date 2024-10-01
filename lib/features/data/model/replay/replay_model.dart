import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ig/features/domain/entities/reply/replay_entity.dart';

class ReplayModel extends ReplayEntity {
  final String? creatorUid;
  final String? replayId;
  final String? commentId;
  final String? postId;
  final String? description;
  final String? username;
  final String? userprofileUrl;
  final List<String>? likes;
  final Timestamp? createAt;

  ReplayModel(
      {this.creatorUid,
      this.replayId,
      this.commentId,
      this.postId,
      this.description,
      this.username,
      this.userprofileUrl,
      this.likes,
      this.createAt}):super(
        creatorUid: creatorUid,
        replayId: replayId,
        commentId: commentId,
        postId: postId,
        description: description,
        username: username,
        userprofileUrl: userprofileUrl,
        likes: likes,
        createAt: createAt
      );
    factory ReplayModel.fromSnapshot(DocumentSnapshot snapshot){
      var snap=snapshot.data()as Map<String,dynamic>;
      return ReplayModel(
        creatorUid: snap['creatorUid'],
        replayId: snap['replayId'],
        commentId: snap['commentId'],
        postId: snap['postId'],
        description: snap['description'],
        username: snap['username'],
        userprofileUrl: snap['userprofileUrl'],
        likes: List.from(snap['likes']),
        createAt: snap['createAt'],
      );
    }
    Map<String,dynamic> toJson()=>{
      "creatorUid": creatorUid,
      "replayId": replayId,
      "commentId": commentId,
      "postId": postId,
      "description": description,
      "username": username,
      "userprofileUrl": userprofileUrl,
      "likes": likes,
      "createAt": createAt,
    };
}
