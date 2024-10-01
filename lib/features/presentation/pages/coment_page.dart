import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig/features/domain/entities/app_entity.dart';
import 'package:ig/features/presentation/cubit/comment/cubit/comment_cubit.dart';
import 'package:ig/features/presentation/cubit/post/single_post/cubit/get_post_single_cubit.dart';
import 'package:ig/features/presentation/cubit/user/get_single_user/cubit/get_single_user_cubit.dart';
import 'package:ig/features/presentation/widgets/comment_main_widget.dart';
import 'package:ig/injection_container.dart' as di;

class ComentPage extends StatelessWidget {
  final AppEntity appEntity;
  const ComentPage({super.key, required this.appEntity});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CommentCubit>(
          create: (context) => di.sl<CommentCubit>(),
        ),
        BlocProvider<GetSingleUserCubit>(
          create: (context) => di.sl<GetSingleUserCubit>(),
        ),
        BlocProvider<GetPostSingleCubit>(
          create: (context) => di.sl<GetPostSingleCubit>(),
        ),
        
      ],
      child: CommentMainWidget(appEntity: appEntity),
    );
  }
}
