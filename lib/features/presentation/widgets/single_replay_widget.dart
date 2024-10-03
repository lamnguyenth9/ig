import 'package:flutter/material.dart';
import 'package:ig/features/domain/entities/reply/replay_entity.dart';

import 'package:intl/intl.dart';
import 'package:ig/injection_container.dart' as di;
import '../../../const.dart';
import '../../domain/usecases/firebase_usecase/user/get_current_uid_usecase.dart';
import 'profile_widget.dart';

class SingleReplayWidget extends StatefulWidget {
  final ReplayEntity replay;
  final VoidCallback onLongPress;
  final VoidCallback onLikePress;
  const SingleReplayWidget(
      {super.key,
      required this.replay,
      required this.onLongPress,
      required this.onLikePress});

  @override
  State<SingleReplayWidget> createState() => _SingleReplayWidgetState();
}

class _SingleReplayWidgetState extends State<SingleReplayWidget> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, PageConst.singleUserPage,
                  arguments: widget.replay.creatorUid);
            },
            child: Container(
              height: 40,
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: profileWidget(imageUrl: widget.replay.userprofileUrl),
              ),
            ),
          ),
          sizehOR(10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, PageConst.singleUserPage,
                              arguments: widget.replay.creatorUid);
                        },
                        child: Text(
                          "${widget.replay.username}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: widget.onLikePress,
                            child: Icon(
                              widget.replay.likes!.contains(_currentUid)
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: widget.replay.likes!.contains(_currentUid)
                                  ? Colors.red
                                  : Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: widget.replay.creatorUid == _currentUid
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
                    "${widget.replay.description}",
                    style: TextStyle(color: primaryColor),
                  ),
                  sizeVer(4),
                  Text(
                    "${DateFormat("dd/MMM/yyy").format(widget.replay.createAt!.toDate())}",
                    style: TextStyle(color: darkGreyColor, fontSize: 12),
                  ),
                  // Row(
                  //   children: [
                  //     Text("Time",style: TextStyle(color: primaryColor),),
                  //     // Text("${DateFormat("dd/MMM/yyy").format(widget.comment.createAt!.toDate())}",
                  //     // style: TextStyle(color: darkGreyColor,fontSize: 12),),
                  //     sizehOR(15),
                  //     GestureDetector(
                  //       onTap: (){
                  //         setState(() {
                  //           _isUserReplaying=!_isUserReplaying;
                  //         });
                  //       },
                  //       child: Text("Replay",
                  //       style: TextStyle(color: darkGreyColor,fontSize: 12),),
                  //     ),sizehOR(15),
                  //     Text("View Replay",
                  //     style: TextStyle(color: darkGreyColor,fontSize: 12),)
                  //   ],
                  // ),
                  // _isUserReplaying==true
                  // ?sizeVer(10)
                  // :sizeVer(0),
                  // _isUserReplaying==true
                  // ?Column(
                  //   crossAxisAlignment: CrossAxisAlignment.end,
                  //   children: [
                  //     FormContainerWidget(hintText: "Post your replay",controller: _replayController,),
                  //     sizeVer(10),
                  //     GestureDetector(
                  //       onTap: (){
                  //         _createReplay();
                  //       },
                  //       child: Text(
                  //         "Post"
                  //         ,style: TextStyle(
                  //           color: blueColor
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // )
                  // :Container()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
