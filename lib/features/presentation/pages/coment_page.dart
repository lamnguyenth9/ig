import 'package:flutter/material.dart';
import 'package:ig/const.dart';
import 'package:ig/features/presentation/widgets/form_container_widget.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  bool _isUserReplaying=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: primaryColor,
            )),
        title: const Text(
          "Comment",
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: secondaryColor),
                ),
                sizehOR(10),
                const Text(
                  "User Name",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                )
              ],
            ),
            const Text(
              "This is very beautiful",
              style: TextStyle(color: primaryColor),
            ),
            sizeVer(10),
            const Divider(
              color: secondaryColor,
            ),
            sizeVer(10),
            Expanded (
              child: Container(
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                          color: secondaryColor, shape: BoxShape.circle),
                    ),
                    sizehOR(10),
                     Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "User Name",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor),
                                ),
                                Icon(
                                  Icons.favorite_outline,
                                  color: primaryColor,
                                  size: 20,
                                )
                              ],
                            ),
                            sizeVer(4),
                            Text("THis is commetn",style: TextStyle(color: primaryColor),),
                            sizeVer(4),
                            Row(
                              children: [
                                Text("13/09/2024",
                                style: TextStyle(color: darkGreyColor,fontSize: 12),),
                                sizehOR(15),
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      _isUserReplaying=!_isUserReplaying;
                                    });
                                  },
                                  child: Text("Replay",
                                  style: TextStyle(color: darkGreyColor,fontSize: 12),),
                                ),sizehOR(15),
                                Text("View Replay",
                                style: TextStyle(color: darkGreyColor,fontSize: 12),)
                              ],
                            ),
                            _isUserReplaying==true
                            ?sizeVer(10)
                            :sizeVer(0),
                            _isUserReplaying==true
                            ?Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                FormContainerWidget(hintText: "Post your replay"),
                                sizeVer(10),
                                Text(
                                  "Post"
                                  ,style: TextStyle(
                                    color: blueColor
                                  ),
                                )
                              ],
                            )
                            :Container()
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
           _commentSection()
          ],
        ),
      ),
    );
  }

  _commentSection(){
    return Container(
      width: double.infinity,
      height: 55,
      color: Colors.grey[800],
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(20),

            ),
          ),
          sizehOR(10),
          Expanded(child: TextFormField(
              style: TextStyle(color: primaryColor),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Post your comment",
                hintStyle: TextStyle(color: secondaryColor)
              )  ,
          ))
        ],
      ),
    );
  }
}
