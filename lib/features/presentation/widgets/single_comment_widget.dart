import 'package:flutter/material.dart';
import 'package:ig/features/domain/entities/comment/comment_entity.dart';
import 'package:ig/features/presentation/widgets/profile_widget.dart';
import 'package:intl/intl.dart';
import 'package:ig/injection_container.dart'as di;
import '../../../const.dart';
import '../../domain/usecases/firebase_usecase/user/get_current_uid_usecase.dart';
import 'form_container_widget.dart';

class SingleCommentWidget extends StatefulWidget {
  final CommentEntity comment;
  final VoidCallback onLongPress;
  final VoidCallback onLike;
  const SingleCommentWidget({super.key, required this.comment, required this.onLongPress, required this.onLike});

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  String _currentUid="";
  @override
  void initState() {
    di.sl<GetCurrentUidUsecase>().call().then((value){
      setState(() {
        _currentUid=value;
      });
    });
    super.initState();
  }
  bool _isUserReplaying=false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress:widget.onLongPress ,
      child: Container(
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: profileWidget(imageUrl: widget.comment.userProfileUrl),
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
                                  Text(
                                    "${widget.comment.username}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor),
                                  ),
                                   GestureDetector(
                                    onTap: widget.onLike,
                                     child: Icon(
                                      widget.comment.likes!.contains(_currentUid)
                                      ?Icons.favorite
                                      :Icons.favorite_outline,
                                      color: widget.comment.likes!.contains(_currentUid)
                                      ?Colors.red
                                      :Colors.white,
                                      
                                      
                                                                       ),
                                   )
                                ],
                              ),
                              sizeVer(4),
                              Text("${widget.comment.description}",style: TextStyle(color: primaryColor),),
                              sizeVer(4),
                              Row(
                                children: [
                                  Text("${DateFormat("dd/MMM/yyy").format(widget.comment.createAt!.toDate())}",
                                  style: TextStyle(color: darkGreyColor,fontSize: 12),),
                                  sizehOR(15),
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        _isUserReplaying=!_isUserReplaying;
                                      });
                                    },
                                    child: Text("Replay",
                                    style: TextStyle(color: darkGreyColor,fontSize: 12),),
                                  ),sizehOR(15),
                                  Text("View Replay",
                                  style: TextStyle(color: darkGreyColor,fontSize: 12),)
                                ],
                              ),
                              _isUserReplaying==true
                              ?sizeVer(10)
                              :sizeVer(0),
                              _isUserReplaying==true
                              ?Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  FormContainerWidget(hintText: "Post your replay"),
                                  sizeVer(10),
                                  Text(
                                    "Post"
                                    ,style: TextStyle(
                                      color: blueColor
                                    ),
                                  )
                                ],
                              )
                              :Container()
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
}