import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ReplayEntity extends Equatable {
  final String? creatorUid;
  final String? replayId;
  final String? commentId;
  final String? postId;
  final String? description;
  final String? username;
  final String? userprofileUrl;
  final List<String>? likes;
  final Timestamp? createAt;

  ReplayEntity(
      {this.creatorUid,
      this.replayId,
      this.commentId,
      this.postId,
      this.description,
      this.username,
      this.userprofileUrl,
      this.likes,
      this.createAt});

  @override
  // TODO: implement props
  List<Object?> get props => [
        creatorUid,
        replayId,
        commentId,
        postId,
        description,
        username,
        userprofileUrl,
        likes,
        createAt
      ];
}
