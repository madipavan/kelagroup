import 'package:flutter/material.dart';

class KgpercentDropdowm extends StatelessWidget {
  final String text;
  final String dropdownval;
  final dynamic onchanged;
  const KgpercentDropdowm(
      {super.key,
      required this.dropdownval,
      required this.onchanged,
      required this.text});

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
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 229, 241, 248),
            borderRadius: BorderRadius.circular(5),
          ),
          height: Height * 0.05,
          width: Width * 0.07,
          child: DropdownButton(
            value: dropdownval,
            padding: EdgeInsets.all(Width * 0.0045),
            iconSize: Width * 0.01,
            underline: const Text(""),
            isExpanded: true,
            borderRadius: BorderRadius.circular(5),
            dropdownColor: Colors.white,
            style: TextStyle(
                fontFamily: "sans",
                fontSize: Width * 0.01,
                color: Colors.black87),
            onChanged: onchanged,
            items: <String>[
              'Percent',
              'KG',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
