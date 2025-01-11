import 'package:flutter/material.dart';

class CustomKhataDetails extends StatelessWidget {
  final String label;
  final String amount;
  final IconData icon;
  final Color color;
  const CustomKhataDetails(
      {super.key,
      required this.amount,
      required this.color,
      required this.icon,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.black,
              size: 35,
            ),
            Text(
              amount,
              style: TextStyle(
                  fontSize: 25, fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              label,
              style: const TextStyle(
                  fontFamily: "sans",
                  color: Colors.grey,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
