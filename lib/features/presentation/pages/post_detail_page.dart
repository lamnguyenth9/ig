import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:ig/features/presentation/cubit/post/single_post/cubit/get_post_single_cubit.dart';
import 'package:ig/features/presentation/widgets/post_detail_main_widget.dart';
import 'package:ig/injection_container.dart' as di;

class PostDetailPage extends StatelessWidget {
  final String postId;
  const PostDetailPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<GetPostSingleCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<PostCubit>(),
        ),
      ],
      child: PostDetailMainWidget(
        postId: postId,
      ),
    );
  }
}
