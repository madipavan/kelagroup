import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kelawin/Modules/Editacc.dart';

class Editaccount extends StatefulWidget {
  const Editaccount({super.key});

  @override
  State<Editaccount> createState() => _EditaccountState();
}

String _searchval = "Kissan";
List<dynamic> data = [];
List<dynamic> foundList = [];
List<dynamic> kissanlist = [];
List<dynamic> vyaparilist = [];
String userid = "kissan_id";

class _EditaccountState extends State<Editaccount> {
  @override
  void initState() {
    _getdata();
    // TODO: implement initState
    super.initState();
  }

  Future _getdata() async {
    var kissan = await FirebaseFirestore.instance.collection("kissan").get();
    var vyapari = await FirebaseFirestore.instance.collection("vyapari").get();
    setState(() {
      foundList = kissan.docs;
      data = foundList;
      kissanlist = kissan.docs;
      vyaparilist = vyapari.docs;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: Width * 0.02),
              color: Colors.white,
              height: Height * 0.05,
              width: Width * 0.28,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    color: Colors.white,
                    height: Height * 0.05,
                    width: Width * 0.2,
                    child: TextField(
                      onChanged: (val) async {
                        var result = await _searching(val);
                        setState(() {
                          foundList = result;
                        });
                      },
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 79, 79, 79))),
                        hintFadeDuration: const Duration(milliseconds: 1000),
                        hintText: "Search & Filter",
                        hintStyle: TextStyle(
                            fontFamily: "sans",
                            fontSize: Width * 0.008,
                            fontWeight: FontWeight.bold),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: Width * 0.015,
                        ),
                        contentPadding: const EdgeInsets.all(20),
                        border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(25)),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(Width * 0.003),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                        border: Border.all(width: 1, color: Colors.grey)),
                    height: Height * 0.05,
                    width: Width * 0.05,
                    child: DropdownButton(
                      borderRadius: BorderRadius.circular(25),
                      padding: EdgeInsets.all(Width * 0.0025),
                      iconSize: Width * 0.01,
                      underline: const Text(""),
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      style: TextStyle(
                          fontFamily: "sans",
                          fontWeight: FontWeight.bold,
                          fontSize: Width * 0.008,
                          color: Colors.black87),
                      value: _searchval,
                      onChanged: (String? newValue) async {
                        setState(() {
                          _searchval = newValue!;
                          userid = _searchval.toLowerCase() + "_id";
                          if (_searchval == "Kissan") {
                            foundList = kissanlist;
                          } else if (_searchval == "Vyapari") {
                            foundList = vyaparilist;
                          }
                        });
                      },
                      items: <String>[
                        'Kissan',
                        'Vyapari',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                  border: Border.all(width: 1, color: Colors.grey)),
              margin: EdgeInsets.only(top: Width * 0.015, left: Width * 0.02),
              height: Height * 0.9,
              width: Width * 0.9,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25)),
                        color: Colors.grey.shade200,
                        border: Border.all(width: 1, color: Colors.grey)),
                    height: Height * 0.05,
                    width: Width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: Width * 0.01),
                          child: Text(
                            "S No.",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontFamily: "sans",
                                fontSize: Width * 0.008),
                          ),
                        ),
                        SizedBox(
                          width: Width * 0.13,
                          height: Height * 0.06,
                          child: Center(
                            child: Text(
                              "Name",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans",
                                  fontSize: Width * 0.009),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Width * 0.06,
                          height: Height * 0.06,
                          child: Center(
                            child: Text(
                              "Role",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans",
                                  fontSize: Width * 0.009),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Width * 0.08,
                          height: Height * 0.06,
                          child: Center(
                            child: Text(
                              "State",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans",
                                  fontSize: Width * 0.009),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Width * 0.075,
                          height: Height * 0.06,
                          child: Center(
                            child: Text(
                              "City",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans",
                                  fontSize: Width * 0.009),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: Width * 0.015),
                          width: Width * 0.045,
                          height: Height * 0.1,
                          child: Center(
                            child: Text(
                              "Pincode",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans",
                                  fontSize: Width * 0.008),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Width * 0.06,
                          height: Height * 0.1,
                          child: Center(
                            child: Text(
                              "Phone",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans",
                                  fontSize: Width * 0.008),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: Width * 0.015),
                          width: Width * 0.07,
                          height: Height * 0.06,
                          child: Center(
                            child: Text(
                              "UserId",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans",
                                  fontSize: Width * 0.009),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: Width * 0.02),
                          width: Width * 0.07,
                          height: Height * 0.06,
                          child: Center(
                            child: Text(
                              "Email",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans",
                                  fontSize: Width * 0.009),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: Width * 0.07),
                          width: Width * 0.04,
                          height: Height * 0.06,
                          child: Center(
                            child: Text(
                              "Address",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans",
                                  fontSize: Width * 0.009),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: Width * 0.052),
                          width: Width * 0.08,
                          height: Height * 0.06,
                          child: Center(
                            child: Text(
                              "Action",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans",
                                  fontSize: Width * 0.009),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: foundList.length,
                        itemBuilder: (context, index) {
                          int i = index + 1;
                          return Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Colors.grey))),
                            height: Height * 0.05,
                            width: Width * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: Width * 0.032,
                                  height: Height * 0.1,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 1, color: Colors.grey))),
                                  child: Center(
                                    child: Text(
                                      "$i",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "sans",
                                          fontSize: Width * 0.009),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: Width * 0.13,
                                  height: Height * 0.06,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 1, color: Colors.grey))),
                                  child: Center(
                                    child: Text(
                                      foundList[index]["name"],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "sans",
                                          fontSize: Width * 0.009),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: Width * 0.05,
                                  height: Height * 0.06,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 1, color: Colors.grey))),
                                  child: Center(
                                    child: Text(
                                      foundList[index]["role"],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "sans",
                                          fontSize: Width * 0.009),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: Width * 0.1,
                                  height: Height * 0.06,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 1, color: Colors.grey))),
                                  child: Center(
                                    child: Text(
                                      foundList[index]["state"],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "sans",
                                          fontSize: Width * 0.009),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: Width * 0.05,
                                  height: Height * 0.06,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 1, color: Colors.grey))),
                                  child: Center(
                                    child: Text(
                                      foundList[index]["city"],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "sans",
                                          fontSize: Width * 0.009),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: Width * 0.05,
                                  height: Height * 0.1,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 1, color: Colors.grey))),
                                  child: Center(
                                    child: Text(
                                      foundList[index]["pincode"],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "sans",
                                          fontSize: Width * 0.009),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: Width * 0.08,
                                  height: Height * 0.1,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 1, color: Colors.grey))),
                                  child: Center(
                                    child: Text(
                                      foundList[index]["phone"],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "sans",
                                          fontSize: Width * 0.008),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 1, color: Colors.grey))),
                                  width: Width * 0.08,
                                  height: Height * 0.06,
                                  child: Center(
                                    child: Text(
                                      foundList[index]["$userid"].toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "sans",
                                          fontSize: Width * 0.009),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 1, color: Colors.grey))),
                                  width: Width * 0.1,
                                  height: Height * 0.06,
                                  child: Center(
                                    child: Text(
                                      foundList[index]["email"],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "sans",
                                          fontSize: Width * 0.009),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 1, color: Colors.grey))),
                                  width: Width * 0.15,
                                  height: Height * 0.06,
                                  child: Center(
                                    child: Text(
                                      foundList[index]["address"],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "sans",
                                          fontSize: Width * 0.009),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: Width * 0.009),
                                  width: Width * 0.05,
                                  height: Height * 0.06,
                                  child: Center(
                                    child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            elevation: 10,
                                            shadowColor: Colors.black,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)))),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Editacc(
                                                        userid: foundList[index]
                                                            ["$userid"],
                                                        role: foundList[index]
                                                            ["role"],
                                                      )));
                                        },
                                        child: Text(
                                          "Edit",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "sans",
                                              fontSize: Width * 0.009),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> _searching(val) async {
  List<dynamic> resultList;
  if (val.toString().isEmpty) {
    if (_searchval == "Kissan") {
      resultList = kissanlist;
    } else if (_searchval == "Vyapari") {
      resultList = vyaparilist;
    } else {
      resultList = kissanlist;
    }
  } else {
    resultList = foundList
        .where(
            (element) => element["name"].toString().toLowerCase().contains(val))
        .toList();
  }

  return resultList;
}
