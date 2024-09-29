import 'package:flutter/material.dart';
import 'package:ig/const.dart';

class ProfileFormWidget extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  const ProfileFormWidget({super.key, required this.controller, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$title",style: TextStyle(color: primaryColor,fontSize: 16),),
        sizeVer(10),
        TextFormField(
          
          controller: controller,
          style: TextStyle(
            color: primaryColor
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            labelStyle: TextStyle(color: primaryColor)
          ),
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: secondaryColor,
        )
      ],
    );
  }
}