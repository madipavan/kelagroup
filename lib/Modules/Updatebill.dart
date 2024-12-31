import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kelawin/Modules/Editbill.dart';
import 'package:kelawin/service/printing_invoices/Printinvoice.dart';

class Updatebill extends StatefulWidget {
  const Updatebill({super.key});

  @override
  State<Updatebill> createState() => _UpdatebillState();
}

DateTime selectedDate = DateTime.now();
List<dynamic> data = [];
List<dynamic> foundList = [];
String _searchval = "Kissan";
String _userval = "Kissan";
bool uservisible = false;
bool datevisible = false;
String invoicecolor = "Red";
TextEditingController search = TextEditingController();

class _UpdatebillState extends State<Updatebill> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _getdata();
  }

  Future _getdata() async {
    await Future.delayed(const Duration(seconds: 1));
    var bills = await FirebaseFirestore.instance
        .collection("Bills")
        .orderBy("bill_no", descending: true)
        .get();
    if (mounted) {
      setState(() {
        data = bills.docs;
        foundList = bills.docs;
      });
    }
  }

  @override
  void dispose() {
    // Clean up any resources here
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
              margin: EdgeInsets.only(top: Width * 0.02, left: Width * 0.02),
              color: Colors.white,
              height: Height * 0.05,
              width: Width * 0.4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    color: Colors.white,
                    height: Height * 0.05,
                    width: Width * 0.2,
                    child: TextField(
                      controller: search,
                      onChanged: (val) async {
                        String searchcatogary = "";
                        if (_searchval == "Kissan") {
                          searchcatogary = "kissan_name";
                        } else if (_searchval == "Vyapari") {
                          searchcatogary = "vyapari_name";
                        } else if (_searchval == "Bill No") {
                          searchcatogary = "bill_no";
                        } else if (_searchval == "Date") {
                          searchcatogary = "date";
                        } else if (_searchval == "User Id") {
                          searchcatogary = "${_userval}_id".toLowerCase();
                        }
                        var result = await _searching(
                            val.toString().trimLeft().trimRight(),
                            searchcatogary);
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
                      onChanged: (String? newValue) {
                        setState(() {
                          _searchval = newValue!;
                          if (_searchval == "User Id") {
                            uservisible = true;
                            datevisible = false;
                          } else if (_searchval == "Date") {
                            uservisible = false;
                            datevisible = true;
                          } else {
                            uservisible = false;
                            datevisible = false;
                          }
                        });
                      },
                      items: <String>[
                        'Kissan',
                        'Vyapari',
                        'Bill No',
                        'Date',
                        'User Id',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Visibility(
                    visible: datevisible,
                    child: Container(
                      padding: EdgeInsets.all(Width * 0.003),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                          border: Border.all(width: 1, color: Colors.grey)),
                      height: Height * 0.05,
                      width: Width * 0.075,
                      child: InkWell(
                        onTap: () async {
                          await _selectDate(context);
                          String date = "";
                          setState(() {
                            date =
                                DateFormat('dd-MM-yyyy').format(selectedDate);

                            search.text = date.toString();
                          });
                          var result =
                              await _searching(date.toString(), "date");
                          setState(() {
                            foundList = result;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: Colors.grey,
                              size: Width * 0.01,
                            ),
                            Text(
                              DateFormat('dd-MM-yyyy').format(selectedDate),
                              style: TextStyle(
                                  fontFamily: "sans",
                                  fontWeight: FontWeight.bold,
                                  fontSize: Width * 0.008),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                              size: Width * 0.01,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: uservisible,
                    child: Container(
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
                        value: _userval,
                        onChanged: (String? newValue) {
                          setState(() {
                            _userval = newValue!;
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
                              "Vyapari",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans",
                                  fontSize: Width * 0.009),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Width * 0.13,
                          height: Height * 0.06,
                          child: Center(
                            child: Text(
                              "Kissan",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans",
                                  fontSize: Width * 0.009),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Width * 0.12,
                          height: Height * 0.06,
                          child: Center(
                            child: Text(
                              "Company",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans",
                                  fontSize: Width * 0.009),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Width * 0.1,
                          height: Height * 0.06,
                          child: Center(
                            child: Text(
                              "Amount",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans",
                                  fontSize: Width * 0.009),
                            ),
                          ),
                        ),
                        SizedBox(
                          // padding: EdgeInsets.only(left: Width * 0.01),
                          width: Width * 0.04,
                          height: Height * 0.1,
                          child: Center(
                            child: Text(
                              "Bill No.",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans",
                                  fontSize: Width * 0.008),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Width * 0.05,
                          height: Height * 0.1,
                          child: Center(
                            child: Text(
                              "Date",
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
                          width: Width * 0.05,
                          height: Height * 0.06,
                          child: Center(
                            child: Text(
                              "Village",
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
                          width: Width * 0.05,
                          height: Height * 0.06,
                          child: Center(
                            child: Text(
                              "Bhav",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans",
                                  fontSize: Width * 0.009),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: Width * 0.04),
                          width: Width * 0.027,
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
                        Container(
                          margin: EdgeInsets.only(left: Width * 0.015),
                          width: Width * 0.08,
                          height: Height * 0.06,
                          child: Center(
                            child: Text(
                              "Invoice",
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
                        itemBuilder: (contex, index) {
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
                                      foundList[index]["vyapari_name"],
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
                                      foundList[index]["kissan_name"],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "sans",
                                          fontSize: Width * 0.009),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: Width * 0.12,
                                  height: Height * 0.06,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 1, color: Colors.grey))),
                                  child: Center(
                                    child: Text(
                                      foundList[index]["vyapari_company"],
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
                                      foundList[index]["grandtotal"].toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "sans",
                                          fontSize: Width * 0.009),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: Width * 0.04,
                                  height: Height * 0.1,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 1, color: Colors.grey))),
                                  child: Center(
                                    child: Text(
                                      foundList[index]["bill_no"].toString(),
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
                                      foundList[index]["date"],
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
                                      "null",
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
                                    width: Width * 0.08,
                                    height: Height * 0.06,
                                    child: OutlinedButton(
                                        onPressed: () {
                                          PrintDocuments().printJantri(
                                              foundList[index]["bill_no"],
                                              context);
                                        },
                                        child: const Text("jantri"))),
                                Container(
                                  margin: EdgeInsets.only(left: Width * 0.009),
                                  width: Width * 0.05,
                                  height: Height * 0.06,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 1, color: Colors.grey))),
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
                                                  builder: (context) =>
                                                      Editbill(
                                                        billno: foundList[index]
                                                            ["bill_no"],
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
                                Container(
                                  margin: EdgeInsets.only(left: Width * 0.009),
                                  width: Width * 0.05,
                                  height: Height * 0.06,
                                  child: Center(
                                    child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.black87,
                                            elevation: 10,
                                            shadowColor: Colors.black,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)))),
                                        onPressed: () async {
                                          setState(() {
                                            _choosecolor(context,
                                                foundList[index]["bill_no"]);
                                            invoicecolor = invoicecolor;
                                          });
                                        },
                                        child: Text(
                                          "Download",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "sans",
                                              fontSize: Width * 0.005),
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                appBarTheme: const AppBarTheme(backgroundColor: Colors.red),
                colorScheme: const ColorScheme.light(
                  inversePrimary: Colors.red,
                  surface: Colors.white,
                  primary: Colors.blue, // header background color
                  onPrimary: Colors.black, // header text color
                  onSurface: Colors.black, // body text color
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black, // button text color
                  ),
                )), // This will change to light theme.
            child: child!,
          );
        });
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future _choosecolor(context, invoiceno) async {
    showDialog(
        context: context,
        builder: (contex) {
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
                  value: invoicecolor,
                  onChanged: (String? newValue) {
                    setState(() {
                      invoicecolor = newValue!;
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();

                    //

                    PrintDocuments()
                        .printInvoice(context, invoicecolor, invoiceno);

                    //

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('PDF generated successfully!')));
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
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
    return invoicecolor;
  }
}

Future<dynamic> _searching(val, searchcatogary) async {
  List<dynamic> resultList;
  if (val.toString().isEmpty) {
    resultList = data;
  } else {
    resultList = data
        .where((element) =>
            element[searchcatogary].toString().toLowerCase().contains(val))
        .toList();
  }

  return resultList;
}
