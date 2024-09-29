import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ig/const.dart';
import 'package:ig/features/domain/entities/posts/post_entity.dart';
import 'package:ig/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:ig/features/presentation/pages/coment_page.dart';
import 'package:ig/features/presentation/pages/edit_post_page.dart';
import 'package:ig/features/presentation/widgets/post_single_widget.dart';
import 'package:ig/injection_container.dart' as di;
import '../../domain/usecases/firebase_usecase/user/get_current_uid_usecase.dart';
import 'edit_profile_page.dart';
import 'update_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//  @override
//   void initState() {
//     di.sl<GetCurrentUidUsecase>().call().then((value){
//       value
//     })
//     super.initState();
//   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: SvgPicture.asset(
            "assets/ic_ig_white.svg",
            height: 48,
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SvgPicture.asset(
                "assets/messenger.svg",
                color: Colors.white,
              ),
            )
          ],
        ),
        body: BlocProvider<PostCubit>(
          create: (context) => di.sl<PostCubit>()..getPosts(PostEntity()),
          child: BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              if (state is PostLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is PostFailure) {
                toast("Some error");
              }
              if (state is PostLoaded) {
                return ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (context, index) {
                    final post = state.posts[index];
                    return BlocProvider(
                      create: (context) => di.sl<PostCubit>(),
                      child: PostSingleWidget(post: post),
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ));
  }
}
