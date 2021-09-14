import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final double width;
  final double height;
  final ButtonStyle style;
  final Widget child;
  final VoidCallback onPressed;

  const CustomElevatedButton(
      {Key? key,
      required this.width,
      required this.height,
      required this.style,
      required this.child,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        child: child,
        style: style,
        onPressed: onPressed,
      ),
    );
  }
}
