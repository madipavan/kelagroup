import 'package:flutter/material.dart';

import '../../../service/printing_invoices/Printinvoice.dart';

class ChooseInvoiceColor extends StatefulWidget {
  final int invoiceno;
  const ChooseInvoiceColor({super.key, required this.invoiceno});

  @override
  State<ChooseInvoiceColor> createState() => _ChooseInvoiceColor();
}

String _invoicecolor = "Red";

class _ChooseInvoiceColor extends State<ChooseInvoiceColor> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.settings_suggest,
            color: Colors.black,
            size: 60,
          ),
          const SizedBox(height: 20),
          const Text(
            'Invoice Color',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Please Select the color',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          DropdownButton(
            padding: const EdgeInsets.all(5),
            iconSize: 15,
            underline: const Text(""),
            isExpanded: true,
            borderRadius: BorderRadius.circular(5),
            dropdownColor: Colors.white,
            style: const TextStyle(
                fontFamily: "sans", fontSize: 15, color: Colors.black87),
            value: _invoicecolor,
            onChanged: (String? newValue) {
              setState(() {
                _invoicecolor = newValue!;
              });
            },
            items: <String>['Red', 'Blue', 'Grey', 'Green', 'White']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              PrintDocuments()
                  .printInvoice(context, _invoicecolor, widget.invoiceno);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                'PDF generated successfully!',
              )));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'OK',
                style: TextStyle(
                  fontFamily: "sans",
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.grey, fontFamily: "sans"),
              ))
        ],
      ),
    );
  }
}
