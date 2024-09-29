import 'package:flutter/material.dart';
import 'package:ig/const.dart';

class FormContainerWidget extends StatefulWidget {
  final TextEditingController? controller;
  final Key? fieldKey;
  final bool? isPasswordField;
  final String hintText;
  final String? lableText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? inputType;
  const FormContainerWidget({super.key, this.controller, this.fieldKey, this.isPasswordField, required this.hintText, this.lableText, this.helperText, this.onSaved, this.validator, this.onFieldSubmitted, this.inputType});

  @override
  State<FormContainerWidget> createState() => _FormContainerWidgetState();
}

class _FormContainerWidgetState extends State<FormContainerWidget> {
  bool _obscureText=true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: secondaryColor.withOpacity(0.35),
        borderRadius: BorderRadius.circular(3)
      ),
      child: new TextFormField(
        style: TextStyle(color: primaryColor),
        controller: widget.controller,
        key: widget.key,
        obscureText: widget.isPasswordField==true?_obscureText:false,
        onSaved: widget.onSaved,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: secondaryColor),
          suffixIcon: GestureDetector(
             onTap: (){
              setState(() {
                _obscureText= !_obscureText;
              });
             },
             child: widget.isPasswordField==true
             ?Icon(_obscureText?Icons.visibility_off:Icons.visibility,color: _obscureText==false?blueColor:secondaryColor,)
             :Text('')
          )
        ), 
      ),
    );
  }
}