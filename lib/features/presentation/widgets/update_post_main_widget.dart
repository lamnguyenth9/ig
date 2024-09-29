import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig/const.dart';
import 'package:ig/features/domain/entities/posts/post_entity.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/upload_image_to_storage.dart';
import 'package:ig/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:ig/features/presentation/widgets/profile_form_widget.dart';
import 'package:ig/features/presentation/widgets/profile_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ig/injection_container.dart'as di;

class UpdatePostMainWidget extends StatefulWidget {
  final PostEntity postEntity;
  const UpdatePostMainWidget({super.key, required this.postEntity});

  @override
  State<UpdatePostMainWidget> createState() => _UpdatePostPageState();
}

class _UpdatePostPageState extends State<UpdatePostMainWidget> {
  late TextEditingController descriptionController;
  @override
  void initState() {
    descriptionController=TextEditingController(text: widget.postEntity.description);
    super.initState();
  }
  File? _file;
  Future selectImage()async{
    try{
      final pickedFile=await ImagePicker.platform.getImage(source: ImageSource.gallery);
      setState(() {
        if(pickedFile!=null){
          _file=File(pickedFile.path);
        }else{
          print("No Image has been selected");
        }
      });
    }catch(e){
      toast("Some error: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("Edit Post"),
        actions: [
          Padding(padding: EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: _updatePost,
            child: Icon(Icons.done)),)
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: SingleChildScrollView(
          child: 
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: profileWidget(imageUrl: widget.postEntity.userProfileUrl),
                ),
              ),
              sizeVer(10),
              Text("${widget.postEntity.username}",style: TextStyle(
                color: primaryColor
              ),),
               sizeVer(10),
               Container(
                width: double.infinity,
                height: 200,
                child: profileWidget(
                  imageUrl: widget.postEntity.postImageUrl,
                  image: _file
                ),
               ),
               Positioned(
                top: 15
                ,
                right: 15,
                 child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(50)
                  ),
                  child: IconButton(
                    onPressed: selectImage, 
                    icon: Icon(Icons.edit,color: Colors.blue,)),
                 ),
               ),
               sizeVer(10),
               ProfileFormWidget(controller: descriptionController, title: "description",)
            ],
          ),
        ),
      ),
    );
  }
  _updatePost(){
    if(_file==null){
        _submitUpdatePost(image: widget.postEntity.postImageUrl!);
    }else{
       di.sl<UploadImageToStorage>().call(_file, true, "posts").then((imageUrl){
        _submitUpdatePost(image: imageUrl);
       });
    }
  }
  _submitUpdatePost({ required String image}){
    BlocProvider.of<PostCubit>(context).updatePost(
      post: PostEntity(
        postImageUrl: image,
        description: descriptionController.text,
        creatorUid: widget.postEntity.creatorUid,
        postId: widget.postEntity.postId
      )).then((value){
        clear();
      });
  }
  clear(){
    setState(() {
      _file=null;
      descriptionController.clear();
      Navigator.pop(context);
    });
  }
}