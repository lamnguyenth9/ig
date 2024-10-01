import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig/features/domain/entities/comment/comment_entity.dart';
import 'package:ig/features/presentation/cubit/comment/cubit/comment_cubit.dart';
import 'package:ig/features/presentation/widgets/edit_comment_widget.dart';
import 'package:ig/injection_container.dart'as di;

class EditCommentPage extends StatelessWidget {
  final CommentEntity comment;
  const EditCommentPage({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<CommentCubit>(),
      child: EditCommentWidget(comment: comment),
    );
  }
}
