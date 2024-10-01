import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig/const.dart';
import 'package:ig/features/domain/entities/comment/comment_entity.dart';
import 'package:ig/features/presentation/cubit/comment/cubit/comment_cubit.dart';
import 'package:ig/features/presentation/widgets/button_container_widget.dart';
import 'package:ig/features/presentation/widgets/profile_form_widget.dart';

class EditCommentWidget extends StatefulWidget {
  final CommentEntity comment;
  const EditCommentWidget({super.key, required this.comment});

  @override
  State<EditCommentWidget> createState() => _EditCommentPageState();
}

class _EditCommentPageState extends State<EditCommentWidget> {
   TextEditingController? _descriptionController;
  bool _isUpdating=false;
  @override
  void initState() {
    _descriptionController=TextEditingController(text: widget.comment.description);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text("Edit Comment"),
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
                    _updateComment(comment: widget.comment);
                },
              ),
              _isUpdating==true
              ? CircularProgressIndicator()
              :Container()
          ],
        ),
      ),
    );
  }
  _updateComment({required CommentEntity comment}){
    setState(() {
      _isUpdating=true;
    });
    BlocProvider.of<CommentCubit>(context).updateComment(
      comment: CommentEntity(
          postId: comment.postId,
          commentId: comment.commentId,
          description: _descriptionController!.text,
          
      )).then((a){
        setState(() {
          _descriptionController!.clear();
        });
        
        Navigator.pop(context);
      });
      setState(() {
        _isUpdating=false;
      });
  }
}