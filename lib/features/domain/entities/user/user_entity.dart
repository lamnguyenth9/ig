import 'dart:io';

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
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
  final File? imageFile;
  final String? password;
  final String? otherUid;

  UserEntity(

      {this.uid,
      this.imageFile,
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
      this.otherUid,this.totalPosts});

  @override
  // TODO: implement props
  List<Object?> get props => [
        uid,
        username,
        onlyname,
        bio,
        website,
        email,
        profileUrl,
        followers,
        following,
        totalFollowers,
        totalFollowing,
        password,
        otherUid,
        totalPosts,
        imageFile
      ];
}
