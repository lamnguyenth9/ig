import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig/const.dart';
import 'package:ig/features/domain/entities/posts/post_entity.dart';
import 'package:ig/features/domain/entities/user/user_entity.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/upload_image_to_storage.dart';
import 'package:ig/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:ig/features/presentation/widgets/profile_form_widget.dart';
import 'package:ig/features/presentation/widgets/profile_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:ig/injection_container.dart'as di;

class UploadPostMainWidget extends StatefulWidget {
  final UserEntity currentUser;
  const UploadPostMainWidget({super.key, required this.currentUser});

  @override
  State<UploadPostMainWidget> createState() => _UpLoadPageState();
}

class _UpLoadPageState extends State<UploadPostMainWidget> {
  final TextEditingController descriptionController=TextEditingController();
  bool _isUpLoading=false;
  File? _file;
  Future selectImage() async {
    try {
      final pickedFile =
          await ImagePicker.platform.getImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _file = File(pickedFile.path);
        } else {
          print("No Image has been selected");
        }
      });
    } catch (e) {
      toast("Some error: $e");
    }
  }
  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return _file == null
        ? _uploadImageWidget()
        : Scaffold(
          backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: backgroundColor,
              leading: IconButton(
                  onPressed: () {
                    setState(() {
                      _file = null;
                    });
                  },
                  icon: Icon(Icons.close)),
              actions: [IconButton(
                onPressed: (){}, 
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: _submitPost, 
                    icon: Icon(Icons.arrow_forward)),
                ))],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: profileWidget(imageUrl: "${widget.currentUser.profileUrl}"),
                      ),
                    ),
                    sizeVer(10),
                    Text(
                      "${widget.currentUser.username}",style: TextStyle(color: Colors.white),
                    ),
                    sizeVer(10),
                    Container(
                      width: double.infinity,
                      child: profileWidget(
                        image: _file
                      ),
                    ),
                    sizeVer(10),
                    ProfileFormWidget(controller: descriptionController, title: "Description")
                  ],
                ),
              ),
            ),
          );
  }
  _submitPost(){
    setState(() {
      _isUpLoading=true;
    });
    di.sl<UploadImageToStorage>().call(
      _file!, 
      true, 
      "posts").then((value){
        _createSubmitPost(image: value);
      });
  }
  _createSubmitPost({required String image}){
    BlocProvider.of<PostCubit>(context).createPost(
      post: PostEntity(
        
        description: descriptionController.text,
        createAt: Timestamp.now(),
        creatorUid: widget.currentUser.uid,
        postId: Uuid().v1(),
        likes: [],
        postImageUrl: image,
        totalComments: 0,
        totalLikes: 0,
        username: widget.currentUser.username,
        userProfileUrl: widget.currentUser.profileUrl
      )).then((value){
        print("${widget.currentUser.profileUrl}");
        _clear();
      });
  }
  _clear(){
    setState(() {
      _isUpLoading=false;
      descriptionController.clear();
      _file=null;
    });
  }
  _uploadImageWidget() {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: GestureDetector(
            onTap: selectImage,
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.3),
                  shape: BoxShape.circle),
              child: Center(
                child: Icon(
                  Icons.upload,
                  color: primaryColor,
                  size: 40,
                ),
              ),
            ),
          ),
        ));
  }
}
