import 'package:flutter/material.dart';
import 'package:ig/const.dart';

class ButtonContainerWidget extends StatelessWidget {
  final Color? color;
  final String? text;
  final VoidCallback? onTapListener;

  const ButtonContainerWidget({super.key, this.color, this.text, this.onTapListener});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapListener,
      child: Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child: Text(
            "$text",
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w600
            ),
          ),
        ),
      ),
    );
  }
}