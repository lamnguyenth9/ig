import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig/const.dart';
import 'package:ig/features/domain/entities/app_entity.dart';
import 'package:ig/features/domain/entities/comment/comment_entity.dart';
import 'package:ig/features/domain/entities/posts/post_entity.dart';
import 'package:ig/features/domain/entities/user/user_entity.dart';
import 'package:ig/features/presentation/cubit/comment/cubit/comment_cubit.dart';
import 'package:ig/features/presentation/cubit/post/single_post/cubit/get_post_single_cubit.dart';
import 'package:ig/features/presentation/cubit/user/get_single_user/cubit/get_single_user_cubit.dart';
import 'package:ig/features/presentation/widgets/form_container_widget.dart';
import 'package:ig/features/presentation/widgets/profile_widget.dart';
import 'package:ig/features/presentation/widgets/single_comment_widget.dart';
import 'package:uuid/uuid.dart';

class CommentMainWidget extends StatefulWidget {
  final AppEntity appEntity;
  const CommentMainWidget({super.key, required this.appEntity});

  @override
  State<CommentMainWidget> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentMainWidget> {
  final TextEditingController descriptionController = TextEditingController();

  bool _isUserReplaying = false;
  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context)
        .getUsers(uid: widget.appEntity.uid);
    BlocProvider.of<CommentCubit>(context)
        .getComments(postId: widget.appEntity.postId);
    BlocProvider.of<GetPostSingleCubit>(context).getSinglePost(postId: widget.appEntity.postId);
    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: primaryColor,
            )),
        title: const Text(
          "Comment",
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
        builder: (context, state) {
          if (state is GetSingleUserLoaded) {
            final singleUser = state.user;
            print("${singleUser.username}");

            return BlocBuilder<GetPostSingleCubit, GetPostSingleState>(
              builder: (context, state) {

                if(state is GetPostSingleLoaded){
                  final singlePost=state.post;
                  return BlocBuilder<CommentCubit, CommentState>(
                  builder: (context, state) {
                    if (state is CommentLoad) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: profileWidget(
                                    imageUrl: singlePost.userProfileUrl,
                                  ),
                                ),
                              ),
                              sizehOR(10),
                               Text(
                                "${singlePost.username}",
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor),
                              )
                            ],
                          ),
                           Text(
                            "${singlePost.description}",
                            style: TextStyle(color: primaryColor),
                          ),
                          sizeVer(10),
                          const Divider(
                            color: secondaryColor,
                          ),
                          sizeVer(10),
                          Expanded(
                              child: ListView.builder(
                            itemCount: state.comments.length,
                            itemBuilder: (context, index) {
                              final singleComment = state.comments[index];
                              return SingleCommentWidget(
                                comment: singleComment,
                                onLongPress: () {
                                  _showBottomModalSheet(context, singleComment);
                                },
                                onLike: () {
                                  likeComment(comment: singleComment);
                                },
                              );
                            },
                          )),
                          _commentSection(currentUser: singleUser)
                        ],
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
                }
                 return const Center(
                  child: CircularProgressIndicator(),
                 );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  _commentSection({required UserEntity currentUser}) {
    return Container(
      width: double.infinity,
      height: 55,
      color: Colors.grey[800],
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: profileWidget(imageUrl: currentUser.profileUrl),
            ),
          ),
          sizehOR(10),
          Expanded(
              child: TextFormField(
            controller: descriptionController,
            style: const TextStyle(color: primaryColor),
            decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Post your comment",
                hintStyle: TextStyle(color: secondaryColor)),
          )),
          TextButton(
              onPressed: () => _createComment(currentUser),
              child: const Text(
                "Post",
                style: TextStyle(color: Colors.blue),
              ))
        ],
      ),
    );
  }

  _createComment(UserEntity currentUser) {
    BlocProvider.of<CommentCubit>(context)
        .createComment(
            comment: CommentEntity(
                totalReplays: 0,
                commentId: const Uuid().v1(),
                createAt: Timestamp.now(),
                likes: [],
                username: currentUser.username,
                userProfileUrl: currentUser.profileUrl,
                description: descriptionController.text,
                creatorUid: currentUser.uid,
                postId: widget.appEntity.postId))
        .then((value) {
      setState(() {
        descriptionController.clear();
      });
    });
  }

  _showBottomModalSheet(BuildContext context, CommentEntity comment) {
    return showBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(0.8),
          ),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "More options",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: primaryColor),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    thickness: 1,
                    color: secondaryColor,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.pushNamed(context, PageConst.editProfilePage,arguments: post);
                      },
                      child: GestureDetector(
                        onTap: () =>
                            deleteComment(comment.commentId, comment.postId),
                        child: const Text(
                          "Delete Comment",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: primaryColor),
                        ),
                      ),
                    ),
                  ),
                  sizeVer(7),
                  const Divider(
                    thickness: 1,
                    color: secondaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, PageConst.updateCommentPage,
                            arguments: comment);
                      },
                      child: const Text(
                        "Update Comment",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: primaryColor),
                      ),
                    ),
                  ),
                  sizeVer(7)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void deleteComment(String? commentId, String? postId) {
    BlocProvider.of<CommentCubit>(context).deleteComment(
        comment: CommentEntity(commentId: commentId, postId: postId));
  }

  void likeComment({required CommentEntity comment}) {
    BlocProvider.of<CommentCubit>(context).likeComment(
        comment: CommentEntity(
            commentId: comment.commentId, postId: comment.postId));
  }
}
