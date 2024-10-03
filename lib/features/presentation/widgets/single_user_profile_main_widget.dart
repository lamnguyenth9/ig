import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig/const.dart';
import 'package:ig/features/domain/entities/user/user_entity.dart';
import 'package:ig/features/presentation/cubit/auth/cubit/auth_cubit.dart';
import 'package:ig/features/presentation/cubit/user/get_single_user/cubit/get_single_user_cubit.dart';
import 'package:ig/features/presentation/pages/edit_profile_page.dart';
import 'package:ig/features/presentation/widgets/profile_widget.dart';

import '../../domain/entities/posts/post_entity.dart';
import '../cubit/post/cubit/post_cubit.dart';

class SingleUserProfileMainWidget extends StatefulWidget {
  final String otherUid;
  const SingleUserProfileMainWidget({super.key, required this.otherUid});

  @override
  State<SingleUserProfileMainWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<SingleUserProfileMainWidget> {
  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context).getUsers(uid: widget.otherUid);
    BlocProvider.of<PostCubit>(context).getPosts(PostEntity());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, state) {
        if(state is GetSingleUserLoaded){
          final singleUser=state.user;
          return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            title: Text(
              "${singleUser.username}",
              style: TextStyle(color: primaryColor),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: InkWell(
                  onTap: () {
                    _openBottomModelSheet(context: context,user: singleUser);
                  },
                  child: const Icon(
                    Icons.menu,
                    color: primaryColor,
                  ),
                ),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: profileWidget(
                              imageUrl: singleUser.profileUrl),
                        ),
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                "${singleUser.totalPosts}",
                                style: const TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              sizeVer(10),
                              const Text(
                                "Post",
                                style: TextStyle(color: primaryColor),
                              )
                            ],
                          ),
                          sizehOR(25),
                          Column(
                            children: [
                              Text(
                                "${singleUser.totalFollowers}",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              sizeVer(10),
                              const Text(
                                "Followers",
                                style: TextStyle(color: primaryColor),
                              )
                            ],
                          ),
                          sizehOR(25),
                          Column(
                            children: [
                              Text(
                                "${singleUser.totalFollowing}",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              sizeVer(10),
                              const Text(
                                "Following",
                                style: TextStyle(color: primaryColor),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  sizeVer(10),
                  Text(
                    "${singleUser.username.toString()}",
                    style: const TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                  sizeVer(10),
                  const Text(
                    "The bio of the user",
                    style: TextStyle(
                      color: primaryColor,
                    ),
                  ),
                  sizeVer(10),
                  BlocBuilder<PostCubit, PostState>(
                builder: (context, state) {
                  if(state is PostLoaded){
                    final posts=state.posts.where((post)=>post.creatorUid==singleUser.uid).toList();
                    return GridView.builder(
                    itemCount: posts.length,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5),
                    itemBuilder: (context, index) {
                      return Container(
                        width: 100,
                        height: 100,
                        child: profileWidget(imageUrl: posts[index].postImageUrl),
                      );
                    },
                  );
                  }
                  return Container();
                },
              )
                ],
              ),
            ),
          ),
        );
        }
        return Container();
      },
    );
  }

  _openBottomModelSheet({required BuildContext context,required UserEntity user}) {
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
                        Navigator.pushNamed(context, "editProfilePage",
                            arguments: user);
                      },
                      child: const Text(
                        "Edit Profile",
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
                    child: InkWell(
                      onTap: () {
                        BlocProvider.of<AuthCubit>(context).loggedOut();
                        Navigator.pushNamedAndRemoveUntil(
                            context, PageConst.signInPage, (route) => false);
                      },
                      child: const Text(
                        "Log out1",
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
