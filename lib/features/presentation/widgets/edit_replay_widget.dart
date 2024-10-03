import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig/const.dart';
import 'package:ig/features/domain/entities/reply/replay_entity.dart';
import 'package:ig/features/presentation/cubit/user/cubit/replay/cubit/replay_cubit.dart';

import 'button_container_widget.dart';
import 'profile_form_widget.dart';

class EditReplayWidget extends StatefulWidget {
  final ReplayEntity replay;
  const EditReplayWidget({super.key, required this.replay});

  @override
  State<EditReplayWidget> createState() => _EditReplayWidgetState();
}

class _EditReplayWidgetState extends State<EditReplayWidget> {
   TextEditingController? _descriptionController;
   @override
  void initState() {
    _descriptionController=TextEditingController(text:widget.replay.description );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("Edit Replay"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Column(
          children: [
            ProfileFormWidget(
              controller: _descriptionController!, 
              title: "Comment"),
              sizeVer(10),
              ButtonContainerWidget(
                color: Colors.blue,
                text: "Save changed",
                onTapListener: (){
                    updateReplay(replay: widget.replay);
                },
              ),
              
          ],
        ),
      ),
    );
  }
  updateReplay({required ReplayEntity replay}){
    BlocProvider.of<ReplayCubit>(context).updateReplay(
      replay: ReplayEntity(
        postId: replay.postId,
        commentId: replay.commentId,
        replayId: replay.replayId,
        description: _descriptionController!.text
      )
      ).then((value){
       setState(() {
          _descriptionController!.clear();
       });
       Navigator.pop(context);
      });
  }
}