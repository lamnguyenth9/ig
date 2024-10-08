import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig/const.dart';
import 'package:ig/features/presentation/cubit/post/single_post/cubit/get_post_single_cubit.dart';
import 'package:ig/features/presentation/widgets/profile_widget.dart';
import 'package:intl/intl.dart';
import 'package:ig/injection_container.dart'as di;
import '../../domain/entities/app_entity.dart';
import '../../domain/entities/posts/post_entity.dart';
import '../../domain/usecases/firebase_usecase/user/get_current_uid_usecase.dart';
import '../cubit/post/cubit/post_cubit.dart';
import '../pages/update_post_page.dart';
import 'like_animation_widget.dart';

class PostDetailMainWidget extends StatefulWidget {
  final String postId;
  const PostDetailMainWidget({super.key, required this.postId});

  @override
  State<PostDetailMainWidget> createState() => _PostDetailMainWidgetState();
}

class _PostDetailMainWidgetState extends State<PostDetailMainWidget> {
   bool  _isLikeAnimating=false;
  String _currentUid="";
  @override
  void initState() {
    di.sl<GetCurrentUidUsecase>().call().then((value){
      setState(() {
        _currentUid=value;
      });
    });
    BlocProvider.of<GetPostSingleCubit>(context).getSinglePost(postId: widget.postId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: BlocBuilder<GetPostSingleCubit,GetPostSingleState>(
          builder: (context, state) {
            if(state is GetPostSingleLoaded){
              final singlePost=state.post;
              return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                              imageUrl: singlePost.userProfileUrl
                            ),
                          ),
                        ),
                        sizehOR(10),
                         Text(
                          "${singlePost.username}",
                          style: const TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    singlePost.creatorUid==_currentUid?
                     GestureDetector(
                      onTap: (){
                        _showBottomModalSheet(context,singlePost);
                      },
                       child: const Icon(
                        Icons.more_vert,
                        color: primaryColor,
                                       ),
                     ):Container()
                  ],
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
                        child: profileWidget(imageUrl: singlePost.postImageUrl ),
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
                          child: Icon(singlePost.likes!.contains(_currentUid)? Icons.favorite:Icons.favorite_outline,color: singlePost.likes!.contains(_currentUid)?Colors.red: Colors.white,)),
                        sizehOR(10),
                         GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, PageConst.commentPage,arguments: AppEntity( uid: _currentUid, postId: singlePost.postId!,));
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
                 Text("${singlePost.totalLikes} likes",style: const TextStyle(
                      color: darkGreyColor,
                      fontWeight: FontWeight.bold
                      
                    ),),
                sizeVer(10),
                Row(
                  children: [
                     Text("${singlePost.username}",style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold
                    ),),
                    sizehOR(10),
                     Text("${singlePost.description}",style: const TextStyle(
                      color: primaryColor,
                      
                    ),)
                  ],
                ),
                sizeVer(10),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, PageConst.commentPage,arguments: AppEntity( uid: _currentUid, postId: singlePost.postId!,));
                    },
                    child: Text("View all ${singlePost.totalComments} comments",style: const TextStyle(
                        color: darkGreyColor,
                        
                      ),),
                  ),
                    sizeVer(10),
                     Text("${DateFormat("dd/MMM/yyy").format(singlePost.createAt!.toDate())}",style: const TextStyle(
                      color: darkGreyColor,
                      
                    ),)
              ],
            ),
          );
            }
            return Container();
          },),
      )
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
                    onTap: deletePost(),
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
    BlocProvider.of<PostCubit>(context).deletePost(post: PostEntity(postId: widget.postId));
  }
  _likePost(){
    BlocProvider.of<PostCubit>(context).likePost(
      post: PostEntity(
        postId: widget.postId,
         
      ));
    
  }
}