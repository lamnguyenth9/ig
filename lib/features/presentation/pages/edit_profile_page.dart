import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig/const.dart';
import 'package:ig/features/domain/usecases/firebase_usecase/upload_image_to_storage.dart';
import 'package:ig/features/presentation/cubit/user/cubit/user_cubit.dart';
import 'package:ig/features/presentation/widgets/profile_form_widget.dart';
import 'package:ig/features/presentation/widgets/profile_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ig/injection_container.dart'as di;
import '../../domain/entities/user/user_entity.dart';

class EditProfilePage extends StatefulWidget {
  final UserEntity currentUser;
  const EditProfilePage({super.key,required this.currentUser});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
   TextEditingController? nameController ;
   TextEditingController? userNameController;
   TextEditingController? emailController;
   TextEditingController? bioController ;
  @override
  void initState() {
    nameController=TextEditingController(text: widget.currentUser.onlyname);
    userNameController=TextEditingController(text: widget.currentUser.username);
    emailController=TextEditingController(text: widget.currentUser.email);
    bioController=TextEditingController(text: widget.currentUser.bio);
    super.initState();
  }
  bool _isUpdating=false;
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
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: primaryColor),
        ),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.close,
              color: Colors.white,
            )),
        actions:  [
           Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: _updateUserProfileData, 
              icon: Icon(Icons.done,color: Colors.blue,))
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: profileWidget(imageUrl: widget.currentUser.profileUrl,image: _file,),
                ),
              ),
            ),
            sizeVer(15),
             Center(
              child: GestureDetector(
                onTap: selectImage,
                child: Text(
                  "Change Profile Photo",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            sizeVer(15),
            ProfileFormWidget(controller: nameController!, title: "Name"),
            sizeVer(15),
            ProfileFormWidget(
                controller: userNameController!, title: "User Name"),
            sizeVer(15),
            ProfileFormWidget(controller: emailController!, title: "Email"),
            sizeVer(15),
            ProfileFormWidget(controller: bioController!, title: "Bio"),
            sizeVer(10),
            _isUpdating==true
            ? CircularProgressIndicator()
            :Container()
          ],
        ),
      ),
    );
  }
  _updateUserProfileData(){
    if(_file==null){
      _updateUserProfile("");
    }else{
         di.sl<UploadImageToStorage>().call(_file,false,"profileImages").then((value)async{
          _updateUserProfile(value);
         });
    }
  }
  _updateUserProfile(String profileUrl){
    setState(() {
      _isUpdating=true; 
    });
    BlocProvider.of<UserCubit>(context).updateUser(user: 
    UserEntity(
      bio:  bioController!.text,
      onlyname: nameController!.text,
      username: userNameController!.text,
      email: emailController!.text,
      uid: widget.currentUser.uid,
      profileUrl: profileUrl
    )).then((value)=>clear());
    Navigator.pop(context);
  }
  
  clear(){
    setState(() {
      _isUpdating=false;
      bioController!.clear();
      userNameController!.clear();
      nameController!.clear();
      emailController!.clear();
    });
  }
}
