import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';

class UserTextfield extends StatelessWidget {
  final String label;
  final Icon? prefix;
  final StringValidationCallback? validationBuilder;
  final bool? isAmount;
  final ValueChanged? onChanged;
  final TextEditingController controller;
  const UserTextfield({
    super.key,
    required this.label,
    this.validationBuilder,
    this.prefix,
    this.onChanged,
    this.isAmount,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validationBuilder,
      onChanged: onChanged ?? (val) {},
      controller: controller,
      style: isAmount ?? false
          ? const TextStyle(fontWeight: FontWeight.bold)
          : null,
      keyboardType: isAmount ?? false
          ? const TextInputType.numberWithOptions(decimal: true)
          : null,
      inputFormatters: isAmount ?? false
          ? [
              FilteringTextInputFormatter
                  .digitsOnly, // Allow digits and a single decimal point
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
