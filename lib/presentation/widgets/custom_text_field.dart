import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextInputType keyboardType;
  final bool hidePassword;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;
  final Widget suffixIcon;

  CustomTextField(
      {required this.hintText,
      required this.keyboardType,
      required this.hidePassword,
      required this.validator,
      required this.suffixIcon,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Theme(
        data: ThemeData(splashColor: Color(0xFFF3F3F3)),
        child: TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: hidePassword,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            hintText: hintText,
            border: InputBorder.none,
            filled: true,
            hintStyle: TextStyle(
              color: Color(0xFF404040),
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
