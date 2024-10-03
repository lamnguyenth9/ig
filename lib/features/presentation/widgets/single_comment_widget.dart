import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig/features/domain/entities/comment/comment_entity.dart';
import 'package:ig/features/domain/entities/reply/replay_entity.dart';
import 'package:ig/features/domain/entities/user/user_entity.dart';
import 'package:ig/features/presentation/cubit/user/cubit/replay/cubit/replay_cubit.dart';
import 'package:ig/features/presentation/widgets/profile_widget.dart';
import 'package:ig/features/presentation/widgets/single_replay_widget.dart';
import 'package:intl/intl.dart';
import 'package:ig/injection_container.dart' as di;
import 'package:uuid/uuid.dart';
import '../../../const.dart';
import '../../domain/usecases/firebase_usecase/user/get_current_uid_usecase.dart';
import 'form_container_widget.dart';

class SingleCommentWidget extends StatefulWidget {
  final UserEntity currentUser;
  final CommentEntity comment;
  final VoidCallback onLongPress;
  final VoidCallback onLike;
  const SingleCommentWidget(
      {super.key,
      required this.comment,
      required this.onLongPress,
      required this.onLike,
      required this.currentUser});

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  final TextEditingController _replayController = TextEditingController();
  String _currentUid = "";
  @override
  void initState() {
    di.sl<GetCurrentUidUsecase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });

    super.initState();
  }

  bool _isUserReplaying = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, PageConst.singleUserPage,
                  arguments: widget.comment.creatorUid);
            },
            child: Container(
              height: 40,
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: profileWidget(imageUrl: widget.comment.userProfileUrl),
              ),
            ),
          ),
          sizehOR(10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, PageConst.singleUserPage,
                              arguments: widget.comment.creatorUid);
                        },
                        child: Text(
                          "${widget.comment.username}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: widget.onLike,
                            child: Icon(
                              widget.comment.likes!.contains(_currentUid)
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: widget.comment.likes!.contains(_currentUid)
                                  ? Colors.red
                                  : Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: widget.comment.creatorUid == _currentUid
                                ? widget.onLongPress
                                : null,
                            child: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  sizeVer(4),
                  Text(
                    "${widget.comment.description}",
                    style: TextStyle(color: primaryColor),
                  ),
                  sizeVer(4),
                  Row(
                    children: [
                      Text(
                        "${DateFormat("dd/MMM/yyy").format(widget.comment.createAt!.toDate())}",
                        style: TextStyle(color: darkGreyColor, fontSize: 12),
                      ),
                      sizehOR(15),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isUserReplaying = !_isUserReplaying;
                          });
                        },
                        child: Text(
                          "Replay",
                          style: TextStyle(color: darkGreyColor, fontSize: 12),
                        ),
                      ),
                      sizehOR(15),
                      GestureDetector(
                        onTap: () {
                          print("huhu ${widget.comment.description}");
                          BlocProvider.of<ReplayCubit>(context).getReplay(
                              replay: ReplayEntity(
                                  commentId: widget.comment.commentId,
                                  postId: widget.comment.postId));
                        },
                        child: Text(
                          "View Replay",
                          style: TextStyle(color: darkGreyColor, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                  BlocBuilder<ReplayCubit, ReplayState>(
                    builder: (context, state) {
                      if (state is ReplayLoaded) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: state.replays.length,
                          itemBuilder: (context, index) {
                            final singleReplay = state.replays[index];
                            return SingleReplayWidget(
                              replay: singleReplay,
                              onLongPress: () {
                                _showBottomModalSheet(context, singleReplay);
                              },
                              onLikePress: () {
                                _likeReplay(replay: singleReplay);
                              },
                            );
                          },
                        );
                      }
                      return Container();
                    },
                  ),
                  _isUserReplaying == true ? sizeVer(10) : sizeVer(0),
                  _isUserReplaying == true
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            FormContainerWidget(
                              hintText: "Post your replay",
                              controller: _replayController,
                            ),
                            sizeVer(10),
                            GestureDetector(
                              onTap: () {
                                _createReplay();
                              },
                              child: Text(
                                "Post",
                                style: TextStyle(color: blueColor),
                              ),
                            )
                          ],
                        )
                      : Container()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _createReplay() {
    if (widget.currentUser.uid == _currentUid) {
      print("Lam dep trai");
      print(widget.currentUser.uid);
    }
    setState(() {
      _isUserReplaying = true;
    });
    BlocProvider.of<ReplayCubit>(context)
        .createReplay(
            replay: ReplayEntity(
                commentId: widget.comment.commentId,
                createAt: Timestamp.now(),
                creatorUid: widget.currentUser.uid,
                description: _replayController.text,
                likes: [],
                postId: widget.comment.postId,
                replayId: Uuid().v1(),
                username: widget.currentUser.username,
                userprofileUrl: widget.currentUser.profileUrl))
        .then((value) {
      setState(() {
        _replayController.clear();
        _isUserReplaying = false;
      });
    });
    print("NBL" + "${widget.comment.totalReplays}");
  }

  _showBottomModalSheet(BuildContext context, ReplayEntity replay) {
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
                      onTap: () => deleteReplay(
                          postId: replay.postId,
                          commentId: replay.commentId,
                          replayId: replay.replayId),
                      child: const Text(
                        "Delete Replay",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: primaryColor),
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
                        Navigator.pushNamed(context, PageConst.updateReplayPage,
                            arguments: replay);
                      },
                      child: const Text(
                        "Update Replay",
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

  deleteReplay({String? postId, String? commentId, String? replayId}) {
    BlocProvider.of<ReplayCubit>(context).deleteReplay(
        replay: ReplayEntity(
            postId: postId, commentId: commentId, replayId: replayId));
  }

  _likeReplay({required ReplayEntity replay}) {
    BlocProvider.of<ReplayCubit>(context).likeReplay(
        replay: ReplayEntity(
            postId: replay.postId,
            commentId: replay.commentId,
            replayId: replay.replayId));
  }
}
