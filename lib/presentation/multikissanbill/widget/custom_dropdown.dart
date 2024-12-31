import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String val;
  final dynamic onChanged;
  final List<DropdownMenuItem<String>> percentlist;
  const CustomDropdown(
      {super.key,
      required this.val,
      required this.onChanged,
      required this.percentlist});

  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 229, 241, 248),
        borderRadius: BorderRadius.circular(5),
      ),
      height: Height * 0.035,
      width: Width * 0.03,
      child: DropdownButton(
          padding: EdgeInsets.all(Width * 0.0025),
          iconSize: Width * 0.01,
          underline: const Text(""),
          isExpanded: true,
          dropdownColor: Colors.white,
          style: TextStyle(
              fontFamily: "sans",
              fontSize: Width * 0.01,
              color: Colors.black87),
          value: val,
          onChanged: onChanged,
          items: percentlist),
    );
  }
}
