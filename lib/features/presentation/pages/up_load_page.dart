import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig/features/domain/entities/user/user_entity.dart';
import 'package:ig/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:ig/features/presentation/widgets/upload_post_main_widget.dart';
import 'package:ig/injection_container.dart' as di;


class UpLoadPage extends StatelessWidget {
  final UserEntity currentUser;
  const UpLoadPage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (_)=>di.sl<PostCubit>(),
      child: UploadPostMainWidget(currentUser: currentUser),);
  }
}