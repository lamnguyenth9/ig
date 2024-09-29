import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ig/const.dart';
import 'package:ig/features/domain/entities/user/user_entity.dart';
import 'package:ig/features/presentation/cubit/auth/cubit/auth_cubit.dart';
import 'package:ig/features/presentation/cubit/credential/cubit/credential_cubit.dart';
import 'package:ig/features/presentation/main_screen/main_screen.dart';
import 'package:ig/features/presentation/pages/credential/sign_in_page.dart';
import 'package:ig/features/presentation/widgets/button_container_widget.dart';
import 'package:ig/features/presentation/widgets/form_container_widget.dart';
import 'package:ig/features/presentation/widgets/profile_widget.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSignIn=false;
  @override
  void dispose() {
    _emailController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
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
      body: BlocConsumer<CredentialCubit,CredentialState>(
        builder: (context, state) {
          if(state is CredentialSuccess){
            return BlocBuilder<AuthCubit,AuthState>(
              builder: (context, state) {
                if(state is Authenticated){
                  return MainScreen(uid: state.uid);
                }else{
                  return _body();
                }
              }, );
          }
          return _body();
          
        }, 
        listener: (context, state) {
          if(state is CredentialSuccess){
            BlocProvider.of<AuthCubit>(context).loggedIn(); 
          }
          if(state is CredentialFailure){
            
            toast("Invalid Email and Password");
          }
        },)
    );
  }
   _body(){
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(flex: 2, child: Container()),
            Center(child: Image.asset("assets/Instagram.png")),
            sizeVer(15),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    
                    child: ClipRRect(borderRadius: BorderRadius.circular(30),child: profileWidget(image: _file),),
                  ),
                  Positioned(
                      right: -10,
                      bottom: -15,
                      child: IconButton(
                          onPressed: selectImage  ,
                          icon: Icon(
                            Icons.add_a_photo,
                            color: blueColor,
                          )))
                ],
              ),
            ),
            sizeVer(30),
            FormContainerWidget(
              controller: _usernameController,
              hintText: "UserName",
            ),
            sizeVer(15),
            FormContainerWidget(
              controller: _bioController,
              hintText: "Bio",
            ),
            sizeVer(15),
            FormContainerWidget(
              controller: _emailController,
              hintText: "Email",
            ),
            sizeVer(15),
            FormContainerWidget(
              controller: _passwordController,
              hintText: "Password",
              isPasswordField: true,
            ),
            sizeVer(15),
            ButtonContainerWidget(
              color: blueColor,
              text: "Sign Up",
              onTapListener: () {
                _signUpUser();
              },
            ),
            Flexible(flex: 2, child: Container()),
            const Divider(
              color: secondaryColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have account?",
                  style: TextStyle(color: primaryColor),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, PageConst.signUpPage);
                  },
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                )
              ],
            ),
            sizeVer(10),
            _isSignIn==true
            ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Please wait",style: TextStyle(color: primaryColor,fontSize: 16),),
                sizehOR(10),
                CircularProgressIndicator(),
              ],
            )
            : Container()
          ],
        ),
      );
   }
  void _signUpUser() {
    setState(() {
      _isSignIn=true;
    });
    BlocProvider.of<CredentialCubit>(context).signUpUser(
        user: UserEntity(
            email: _emailController.text,
            bio: _bioController.text,
            username: _usernameController.text,
            password: _passwordController.text,
            totalFollowers: 0,
            totalFollowing: 0,
            totalPosts: 0,
            profileUrl: "",
            followers: [],
            website: "",
            onlyname: "",
            imageFile: _file,
            following: [],
            
            )).then((value){
              print("2");
              _clear();
            });
  }
  _clear(){
    setState(() {
      _emailController.clear();
      _bioController.clear();
      _usernameController.clear();
      _passwordController.clear();
      _isSignIn=false;
    });
  }
}
