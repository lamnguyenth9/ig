import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:ig/features/presentation/cubit/user/get_single_user/cubit/get_single_user_cubit.dart';
import 'package:ig/features/presentation/widgets/single_user_profile_main_widget.dart';
import 'package:ig/injection_container.dart' as di;

class SingleUserProfilePage extends StatelessWidget {
  final String otherUid;
  const SingleUserProfilePage({super.key, required this.otherUid});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetSingleUserCubit>(
          create: (context) => di.sl<GetSingleUserCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<PostCubit>(),
        ),
      ],
      child: SingleUserProfileMainWidget(otherUid: otherUid),
    );
  }
}
