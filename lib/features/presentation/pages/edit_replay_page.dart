import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig/features/domain/entities/reply/replay_entity.dart';
import 'package:ig/features/presentation/cubit/user/cubit/replay/cubit/replay_cubit.dart';
import 'package:ig/features/presentation/widgets/edit_replay_widget.dart';
import 'package:ig/injection_container.dart'as di;

class EditReplayPage extends StatelessWidget {
  final ReplayEntity replay;
  const EditReplayPage({super.key, required this.replay});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ReplayCubit>(),
      child: EditReplayWidget(replay: replay),
    );
  }
}
