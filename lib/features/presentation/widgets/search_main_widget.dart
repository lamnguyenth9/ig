import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig/const.dart';
import 'package:ig/features/domain/entities/posts/post_entity.dart';
import 'package:ig/features/domain/entities/user/user_entity.dart';
import 'package:ig/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:ig/features/presentation/cubit/user/cubit/user_cubit.dart';
import 'package:ig/features/presentation/widgets/profile_widget.dart';
import 'package:ig/features/presentation/widgets/search_widget.dart';

class SearchMainWidget extends StatefulWidget {
  const SearchMainWidget({super.key});

  @override
  State<SearchMainWidget> createState() => _SearchMainWidgetState();
}

class _SearchMainWidgetState extends State<SearchMainWidget> {
  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    BlocProvider.of<PostCubit>(context).getPosts(PostEntity());
     BlocProvider.of<UserCubit>(context).getUsers(user: UserEntity());
    _searchController.addListener((){
         setState(() {
           
         });
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            
            if(state is UserLoaded){
              final filterAllUsers=state.user.where((user)=>
              user.username!.startsWith(_searchController.text)||
              user.username!.toLowerCase().startsWith(_searchController.text.toLowerCase())||
              user.username!.contains(_searchController.text)||
              user.username!.toLowerCase().contains(_searchController.text.toLowerCase())
              ).toList();
            return  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchWidget(controller: _searchController),
                sizeVer(10),
                BlocBuilder<PostCubit, PostState>(
                  builder: (context, state) {
                    if(state is PostLoaded){
                      final posts=state.posts;
                      return 
                      _searchController.text.isNotEmpty
                      ? Expanded(
                        child: ListView.builder(
                          itemCount: filterAllUsers.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, PageConst.singleUserPage,arguments: filterAllUsers[index].uid);
                              },
                              child: Row(
                                children: [
                                   Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                width: 100,
                                height: 100,
                                child: profileWidget(
                                  imageUrl: filterAllUsers[index].profileUrl
                                ),
                              ),
                              sizehOR(10),
                              Text("${filterAllUsers[index].username}")
                                ],
                              ),
                            );
                          },),
                      )
                      : Expanded(
                        child: GridView.builder(
                        itemCount: posts.length,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(context, PageConst.singlePostPage,arguments: posts[index].postId);
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              child: profileWidget(
                                imageUrl: posts[index].postImageUrl
                              ),
                            ),
                          );
                        },
                                            ),
                      );
                    }
                    return Container();
                  },
                )
              ],
            ),
          
        );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
