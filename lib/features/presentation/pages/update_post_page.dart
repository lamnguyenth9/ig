import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig/features/domain/entities/posts/post_entity.dart';
import 'package:ig/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:ig/features/presentation/widgets/update_post_main_widget.dart';
import 'package:ig/injection_container.dart'as di;
class UpdatePostPage extends StatelessWidget {
  final PostEntity post;
  const UpdatePostPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<PostCubit>(),
      child: UpdatePostMainWidget(postEntity: post),
    );
  }
}
