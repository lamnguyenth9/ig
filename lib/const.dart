import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const backgroundColor=Color.fromRGBO(0, 0, 0, 1);
const blueColor=Color.fromRGBO(0, 149, 246, 1);
const primaryColor=Colors.white;
const secondaryColor=Colors.grey;
const darkGreyColor=Color.fromRGBO(97, 97, 97, 1);

Widget sizeVer(double height){
  return SizedBox(height: height,);
}
Widget sizehOR(double width){
  return SizedBox(width: width,);
}
class PageConst{
  static const String editProfilePage="editProfilePage";
  static const String updatePostPage="updatePostPage";
  static const String commentPage="commentPage";
  static const String signInPage="signInPage";
  static const String signUpPage="signUpPage";
  static const String updateCommentPage="updateCommentPage";
  static const String updateReplayPage="updateReplayPage";
  static const String singlePostPage="singlePostPage";
  static const String singleUserPage="singleUserPage";
}
class FirebaseConst{
  static const String users='users';
  static const String posts='posts';
  static const String comment='comment';
  static const String replay='replay';
}
void toast(String message){
  Fluttertoast.showToast(msg: 
  message,
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 1,
  backgroundColor: blueColor,
  textColor: Colors.white,
  fontSize: 16);
}