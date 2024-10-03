import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig/features/domain/entities/app_entity.dart';
import 'package:ig/features/domain/entities/posts/post_entity.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/user/get_current_uid_usecase.dart';
import 'package:ig/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:ig/features/presentation/pages/update_post_page.dart';
import 'package:ig/features/presentation/widgets/like_animation_widget.dart';
import 'package:ig/features/presentation/widgets/profile_widget.dart';
import 'package:intl/intl.dart';
import 'package:ig/injection_container.dart'as di;

import '../../../const.dart';
import '../pages/edit_post_page.dart';

class PostSingleWidget extends StatefulWidget {
  final PostEntity post;
  const PostSingleWidget({super.key, required this.post});

  @override
  State<PostSingleWidget> createState() => _PostSingleWidgetState();
}

class _PostSingleWidgetState extends State<PostSingleWidget> {
  
  bool  _isLikeAnimating=false;
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
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, PageConst.singleUserPage,arguments: widget.post.creatorUid);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: profileWidget(
                            imageUrl: widget.post.userProfileUrl
                          ),
                        ),
                      ),
                      sizehOR(10),
                       Text(
                        "${widget.post.username}",
                        style: const TextStyle(
                            color: primaryColor, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  widget.post.creatorUid==_currentUid?
                   GestureDetector(
                    onTap: (){
                      _showBottomModalSheet(context,widget.post);
                    },
                     child: const Icon(
                      Icons.more_vert,
                      color: primaryColor,
                                     ),
                   ):Container()
                ],
              ),
            ),
            sizeVer(10),
            GestureDetector(
              onTap: (){
                _likePost();
                setState(() {
                  _isLikeAnimating=true;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  color: secondaryColor,
                  child: ClipRRect(
                    child: profileWidget(imageUrl: widget.post.postImageUrl ),
                  ),
                ),
                AnimatedOpacity(
                  
                  opacity: _isLikeAnimating?1:0,
                  duration: Duration(milliseconds: 200),
                  child: LikeAnimationWidget(
                    child:  const Icon( Icons.favorite,size: 100,color:Colors.white,), 
                    duration: Duration(milliseconds: 300), 
                    isLikeAnimating: _isLikeAnimating,
                    onLikeFinish: (){
                      setState(() {
                        _isLikeAnimating=false;
                      });
                    },),
                )
                ]
              ),
            ),
            sizeVer(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: _likePost,
                      child: Icon(widget.post.likes!.contains(_currentUid)? Icons.favorite:Icons.favorite_outline,color: widget.post.likes!.contains(_currentUid)?Colors.red: Colors.white,)),
                    sizehOR(10),
                     GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, PageConst.commentPage,arguments: AppEntity( uid: _currentUid, postId: widget.post.postId!,));
                      },
                      child: const Icon(Icons.messenger_outline_rounded, color: primaryColor)),
                    sizehOR(10),
                    const Icon(Icons.send, color: primaryColor)
                  ],
                ),
                const Icon(Icons.bookmark_border,color: primaryColor,)
              ],
            ),
            sizeVer(10),
             Text("${widget.post.totalLikes} likes",style: const TextStyle(
                  color: darkGreyColor,
                  fontWeight: FontWeight.bold
                  
                ),),
            sizeVer(10),
            Row(
              children: [
                 Text("${widget.post.username}",style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold
                ),),
                sizehOR(10),
                 Text("${widget.post.description}",style: const TextStyle(
                  color: primaryColor,
                  
                ),)
              ],
            ),
            sizeVer(10),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, PageConst.commentPage,arguments: AppEntity( uid: _currentUid, postId: widget.post.postId!,));
                },
                child: Text("View all ${widget.post.totalComments} comments",style: const TextStyle(
                    color: darkGreyColor,
                    
                  ),),
              ),
                sizeVer(10),
                 Text("${DateFormat("dd/MMM/yyy").format(widget.post.createAt!.toDate())}",style: const TextStyle(
                  color: darkGreyColor,
                  
                ),)
          ],
        ),
      );
  }

  _showBottomModalSheet(BuildContext context,PostEntity post){
    return showBottomSheet(context: context, builder: (context) {
      return Container(
        height: 150,
        decoration: BoxDecoration(
          color: backgroundColor.withOpacity(0.8),

        ),child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "More options",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: primaryColor
                        ),
                      ),
                      IconButton(
                        onPressed: (){
                         Navigator.pop(context);
                        }, 
                        icon: const Icon(Icons.close,color: Colors.white,))
                    ],
                  ),
                  
                ),
                const SizedBox(height: 10,),
                const Divider(
                  thickness: 1,
                  color: secondaryColor,
                ),
                const SizedBox(height: 8,),
                 Padding(padding: const EdgeInsets.only(left: 10),
                child: GestureDetector.new(
                  onTap: (){
                    Navigator.pushNamed(context, PageConst.editProfilePage,arguments: post);
                  },
                  child: GestureDetector(
                    onTap: deletePost,
                    child: const Text(
                      "Delete Post"
                      ,style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: primaryColor
                      ),
                    ),
                  ),
                ),),
                sizeVer(7),
                const  Divider(
                  thickness: 1,
                  color: secondaryColor,
                ),
                 Padding(padding: const EdgeInsets.only(left: 10),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>UpdatePostPage(post: post,)));
                  },
                  child: const Text(
                    "Update Post"
                    ,style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: primaryColor
                    ),
                  ),
                ),),
                sizeVer(7)
              ],
            ),
          ),
        ),
      );
    },);
  }
  deletePost(){
    BlocProvider.of<PostCubit>(context).deletePost(post: PostEntity(postId: widget.post.postId));
  }
  _likePost(){
    BlocProvider.of<PostCubit>(context).likePost(
      post: PostEntity(
        postId: widget.post.postId,
         
      ));
  }
}