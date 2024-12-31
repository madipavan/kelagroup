import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';

class CustomtextField extends StatelessWidget {
  final String label;
  final Icon? prefix;
  final bool isAmount;
  final bool readOnly;
  final ValueChanged? onChanged;
  final TextEditingController controller;
  const CustomtextField(
      {super.key,
      required this.label,
      this.prefix,
      required this.isAmount,
      this.onChanged,
      required this.controller,
      required this.readOnly});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: ValidationBuilder(requiredMessage: "")
          .minLength(2)
          .maxLength(45)
          .build(),
      onChanged: onChanged ?? (val) {},
      controller: controller,
      readOnly: readOnly,
      style: isAmount ? const TextStyle(fontWeight: FontWeight.bold) : null,
      keyboardType: isAmount
          ? const TextInputType.numberWithOptions(decimal: true)
          : null, // Allow decimal input
      inputFormatters: isAmount
          ? [
              FilteringTextInputFormatter.allow(RegExp(
                  r'^\d*\.?\d*')), // Allow digits and a single decimal point
            ]
          : [],
      cursorColor: Colors.grey,
      decoration: InputDecoration(
          prefixIcon: prefix,
          label: Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.blue.shade700, width: 1),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          )),
    );
  }
}
