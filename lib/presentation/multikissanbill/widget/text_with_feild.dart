import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class TextwithFeild extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  const TextwithFeild(
      {super.key, required this.text, required this.controller});

  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
              fontFamily: "sans",
              fontSize: Width * 0.008,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: Height * 0.005,
        ),
        SizedBox(
          height: Height * 0.05,
          width: Width * 0.07,
          child: TextFormField(
            controller: controller,
            validator: ValidationBuilder().minLength(1).maxLength(45).build(),
            keyboardType: TextInputType.number,
            onChanged: (val) {},
            cursorColor: Colors.black87,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(Width * 0.005),
                hoverColor: Colors.grey.shade300,
                hintText: text,
                hintStyle: TextStyle(
                  fontFamily: "sans",
                  fontSize: Width * 0.01,
                ),
                hintFadeDuration: const Duration(seconds: 1),
                prefixIcon: Icon(
                  Icons.numbers,
                  size: Width * 0.015,
                ),
                fillColor: const Color.fromARGB(255, 229, 241, 248),
                filled: true,
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.grey)),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.black87)),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          ),
        ),
      ],
    );
  }
}
