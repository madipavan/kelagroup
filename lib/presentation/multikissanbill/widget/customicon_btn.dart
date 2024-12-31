import 'package:flutter/material.dart';

class CustomIconbtn extends StatelessWidget {
  final Icon icon;
  final dynamic onPressed;
  const CustomIconbtn({super.key, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final Width = MediaQuery.of(context).size.width;
    return IconButton.outlined(
      color: Colors.black,
      style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      )),
      onPressed: onPressed,
      icon: icon,
      iconSize: Width * 0.015,
    );
  }
}
