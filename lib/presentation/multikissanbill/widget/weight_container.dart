import 'package:flutter/material.dart';

class WeightContainer extends StatelessWidget {
  final String text;
  final double val;
  const WeightContainer({super.key, required this.text, required this.val});

  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;
    return Container(
        height: Height * 0.08,
        width: Width * 0.08,
        color: Colors.white,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            child: Container(
              padding: EdgeInsets.all(Width * 0.004),
              height: Height * 0.05,
              width: Width * 0.07,
              decoration: BoxDecoration(
                  color: const Color(0xffd5ecfa),
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(val.toString(),
                  style: TextStyle(
                      fontFamily: "sans",
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: Width * 0.008)),
            ),
          ),
        ]));
  }
}
