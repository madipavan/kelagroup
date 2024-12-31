import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class Customtextfeid extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;

  const Customtextfeid({
    super.key,
    required this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final Width = MediaQuery.of(context).size.width;
    return TextFormField(
      validator: ValidationBuilder().minLength(2).maxLength(45).build(),
      cursorColor: Colors.black87,
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(Width * 0.005),
          hoverColor: Colors.grey.shade300,
          hintText: "Search For User",
          hintStyle: TextStyle(
            fontFamily: "sans",
            fontSize: Width * 0.012,
          ),
          hintFadeDuration: const Duration(seconds: 1),
          prefixIcon: Icon(
            Icons.person,
            size: Width * 0.015,
          ),
          fillColor: const Color.fromARGB(255, 229, 241, 248),
          filled: true,
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.grey)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.black87)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
    );
  }
}
