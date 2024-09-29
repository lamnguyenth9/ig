import 'package:flutter/material.dart';
import 'package:ig/const.dart';
import 'package:ig/features/presentation/widgets/profile_form_widget.dart';

class EditPostPage extends StatefulWidget {
  const EditPostPage({super.key});

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final TextEditingController descriptionController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: Text("Edit Post",style: TextStyle(color: primaryColor),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(Icons.done,color: blueColor,),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: secondaryColor,
                shape: BoxShape.circle
              ),
              
            ),
            sizeVer(10),
            Text("User Name",style: TextStyle(
              color: primaryColor,fontSize: 16,
              fontWeight: FontWeight.bold
            ),),
            sizeVer(10),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: secondaryColor
              ),
            ),
            sizeVer(10),
            ProfileFormWidget(controller:  descriptionController, title: "Description")
          ],
        ),
      ),
    );
  }
}