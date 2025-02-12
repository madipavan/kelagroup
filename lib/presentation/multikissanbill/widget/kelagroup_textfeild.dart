import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kelawin/presentation/multikissanbill/widget/customtextfeid.dart';
import 'package:provider/provider.dart';

import '../provider/multi_kissan_pro.dart';

class KelagroupTextfeild extends StatelessWidget {
  final int index;
  final TextEditingController typecontroller;

  const KelagroupTextfeild(
      {super.key, required this.typecontroller, required this.index});

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      builder: (context, controller, focusNode) {
        controller = typecontroller;
        return Customtextfeid(
          controller: typecontroller,
          focusNode: focusNode,
        );
      },
      onSelected: (dynamic val) {
        typecontroller.text = val["name"];
        Provider.of<MultiKissanPro>(context, listen: false).multikissan[index]
            ["userId"] = val["userId"];
      },
      suggestionsCallback: (search) async {
        return await _getdata(search, "kelagroup");
      },
      itemBuilder: (BuildContext context, dynamic suggestion) {
        final random = Random();
        final color = Color.fromARGB(
          320,
          random.nextInt(150),
          random.nextInt(243),
          random.nextInt(1),
        );
        return ListTile(
          trailing: Text(suggestion["userId"].toString(),
              style: const TextStyle(
                  fontFamily: "sans", fontWeight: FontWeight.bold)),
          subtitle: Text(suggestion["city"],
              style: const TextStyle(
                  fontFamily: "sans", fontWeight: FontWeight.bold)),
          leading: CircleAvatar(
            backgroundColor: color,
            child: Text(
              suggestion["name"].toString().toUpperCase()[0],
              style: const TextStyle(
                  fontFamily: "sans", fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(suggestion["name"],
              style: const TextStyle(
                  fontFamily: "sans",
                  fontWeight: FontWeight
                      .bold)), // Adjust the field name as per your data structure
          // Add other widget properties as needed
        );
      },
    );
  }
}

Future _getdata(search, role) async {
  try {
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection("Users")
        .where("role", isEqualTo: role)
        .get();

    List<Map<String, dynamic>> foundList = data.docs
        .where((element) => element["name"]
            .toString()
            .toLowerCase()
            .contains(search.toLowerCase()))
        .map((e) => e.data())
        .toList();

    return foundList;
  } catch (e) {
    // Handle errors
    print("Error fetching data: $e");
    return [];
  }
}
