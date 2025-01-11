import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:form_validator/form_validator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:kelawin/Modules/Mainscreen.dart';
import 'package:kelawin/presentation/billoperations/pages/CreateBill.dart';
import 'package:kelawin/service/printing_invoices/Printinvoice.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

final _formkey = GlobalKey<FormState>();

DateTime selectedDate = DateTime.now();
// late DateTime selectedDate = now.format("dd-MM-yyy").toString();
TextEditingController selectedvyapari = TextEditingController();
TextEditingController selectedkissan = TextEditingController();
String vyapariid = "";
String vyaparicompany = "";
String vyaparicity = "";
String vyaparistate = "";
String vyapariphone = "";
String vyapariaddress = "";
String kissanphone = "";
String kissanid = "";
String kissanstate = "";
String kissancity = "";
String kissanaddress = "";

String _patiunit = "Percent";
String _dandaunit = "Percent";
String _wastageunit = "Percent";

double patiwt = 0;
double dandawt = 0;
double wastagewt = 0;

TextEditingController rascontroller = TextEditingController();
TextEditingController boardcontroller = TextEditingController();
TextEditingController motornocontroller = TextEditingController();
TextEditingController bhuktancontroller = TextEditingController();

TextEditingController villagecontroller = TextEditingController();
TextEditingController bhavcontroller = TextEditingController();
TextEditingController paticontroller = TextEditingController();
TextEditingController dandacontroller = TextEditingController();
TextEditingController wastagecontroller = TextEditingController();
TextEditingController grosscontroller = TextEditingController();
TextEditingController tarecontroller = TextEditingController();
TextEditingController lungarcontroller = TextEditingController();
String ras = "";
String board = "";
String motorno = "";
String bhuktanpk = "";

double patival = 0;
double dandaval = 0;
double wastageval = 0;
String dropdownValue = "Loose";

String parchavillage = "";
double bhav = 0;
double gross = 0;
double tare = 0;
double lungar = 0;
int invoiceno = 0;
double nettweight = 0;
double kissanamt = 0;
double hammnali = 0;
double commission = 0;
double mtax = 0;
double subtotal = 0;
double ot = 40;
double tcs = 0;
double grandtotal = 0;

String note = "";

String hammalipercent = "20";
String commissionpercent = "15";
String mtaxpercent = "1";
String tcspercent = "0";

class Editbill extends StatefulWidget {
  final int billno;
  const Editbill({super.key, required this.billno});

  @override
  State<Editbill> createState() => _EditbillState();
}

class _EditbillState extends State<Editbill> {
  List<String> listItems = ["applew", "zfhd", "banan"];
  bool pati = true;
  bool danda = false;
  bool wastage = false;
  bool downbtn = false;

  @override
  void initState() {
    selectedDate = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getinbilldata(context);
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;
    invoiceno = widget.billno;
    return Scaffold(
      backgroundColor: const Color(0xffd5ecfa),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              shadowColor: Colors.black,
              elevation: 10,
              child: Container(
                height: Height * 0.1,
                width: Width,
                color: Colors.white,
                child: ListTile(
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Mainscreen()));
                      },
                      icon: const Icon(
                        Icons.arrow_circle_left,
                        color: Colors.black87,
                        size: 45,
                      )),
                  title: Text(
                    "Invoice From Swami Samarth Kelagroup",
                    style: TextStyle(
                        fontFamily: "sans",
                        fontSize: Width * 0.02,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Edit Your invoice details below.",
                    style: TextStyle(
                        fontFamily: "sans",
                        fontSize: Width * 0.01,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Form(
              key: _formkey,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 40, left: 60),
                    height: Height * 2,
                    width: Width * 0.8,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          width: Width,
                          height: Height * 0.15,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(Width * 0.015),
                                    color: Colors.white,
                                    height: Height * 0.03,
                                    width: Width * 0.12,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          size: Width * 0.01,
                                          color: Colors.black87,
                                        ),
                                        Text(
                                          "Date:",
                                          style: TextStyle(
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.bold,
                                              fontSize: Width * 0.01),
                                        ),
                                        Text(
                                          DateFormat('dd-MM-yyyy')
                                              .format(selectedDate),
                                          style: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.w600,
                                              fontSize: Width * 0.01),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _selectDate(context);
                                          },
                                          child: Icon(
                                            Icons.arrow_drop_down,
                                            size: Width * 0.017,
                                          ),
                                        )
                                      ],
                                    ),
                                  ) //date
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Invoice",
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold,
                                        fontSize: Width * 0.02),
                                  ),
                                  SizedBox(
                                    width: Width * 0.01,
                                  ),
                                  Text(
                                    "#$invoiceno",
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.bold,
                                        fontSize: Width * 0.02),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey.shade500,
                          endIndent: 40,
                          indent: 40,
                        ),
                        Container(
                          color: Colors.white,
                          width: Width * 0.8,
                          height: Height * 0.35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: Width * 0.35,
                                height: Height * 0.4,
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Kissan details",
                                      style: TextStyle(
                                          fontFamily: "sans",
                                          fontSize: Width * 0.01,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: Height * 0.05,
                                          width: Width * 0.25,
                                          child: TypeAheadField(builder:
                                              (context, controller, focusNode) {
                                            selectedkissan = controller;
                                            return TextFormField(
                                              validator: ValidationBuilder()
                                                  .minLength(2)
                                                  .maxLength(45)
                                                  .build(),
                                              cursorColor: Colors.black87,
                                              controller: selectedkissan,
                                              focusNode: focusNode,
                                              decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.all(
                                                      Width * 0.005),
                                                  hoverColor:
                                                      Colors.grey.shade300,
                                                  hintText: "Search For kissan",
                                                  hintStyle: TextStyle(
                                                    fontFamily: "sans",
                                                    fontSize: Width * 0.012,
                                                  ),
                                                  hintFadeDuration: const Duration(
                                                      seconds: 1),
                                                  prefixIcon: Icon(
                                                    Icons.person,
                                                    size: Width * 0.015,
                                                  ),
                                                  fillColor: const Color.fromARGB(
                                                      255, 229, 241, 248),
                                                  filled: true,
                                                  enabledBorder: const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          color: Colors.grey)),
                                                  focusedBorder:
                                                      const OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              width: 1,
                                                              color: Colors
                                                                  .black87)),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(5))),
                                            );
                                          }, suggestionsCallback:
                                              (search) async {
                                            return await _Getdata(
                                                search, "kissan");
                                          }, onSelected: (dynamic val) {
                                            setState(() {
                                              selectedkissan.text =
                                                  val["first_name"];
                                              kissanid =
                                                  val["kissan_id"].toString();
                                              kissanaddress = val["address"];
                                              kissancity = val["city"];
                                              kissanstate = val["state"];
                                              kissanphone = val["phone"];
                                            });
                                          }, itemBuilder:
                                              (context, dynamic suggestion) {
                                            final random = Random();
                                            final color = Color.fromARGB(
                                              320,
                                              random.nextInt(150),
                                              random.nextInt(243),
                                              random.nextInt(1),
                                            );
                                            if (suggestion != null) {
                                              // Add null check to ensure itemData is not null
                                              return ListTile(
                                                trailing: Text(
                                                    suggestion["kissan_id"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontFamily: "sans",
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                subtitle: Text(
                                                    suggestion["city"],
                                                    style: const TextStyle(
                                                        fontFamily: "sans",
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                leading: CircleAvatar(
                                                  backgroundColor: color,
                                                  child: Text(
                                                    suggestion["first_name"]
                                                        .toString()
                                                        .toUpperCase()[0],
                                                    style: const TextStyle(
                                                        fontFamily: "sans",
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                title: Text(
                                                    suggestion["first_name"] +
                                                        suggestion["last_name"],
                                                    style: const TextStyle(
                                                        fontFamily: "sans",
                                                        fontWeight: FontWeight
                                                            .bold)), // Adjust the field name as per your data structure
                                                // Add other widget properties as needed
                                              );
                                            } else {
                                              return const SizedBox(); // or any other placeholder widget
                                            }
                                          }),
                                        ),
                                        SizedBox(
                                          width: Width * 0.02,
                                        ),
                                        Container(
                                          height: Height * 0.05,
                                          width: Width * 0.065,
                                          decoration: BoxDecoration(
                                              color: const Color(0xffd5ecfa),
                                              border: Border.all(
                                                  width: 1, color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(
                                                Icons.card_membership_outlined,
                                                color: Colors.black87,
                                                size: Width * 0.015,
                                              ),
                                              Text(
                                                kissanid,
                                                style: TextStyle(
                                                    fontFamily: "sans",
                                                    fontSize: Width * 0.01,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: Height * 0.03),
                                      padding: EdgeInsets.all(Width * 0.008),
                                      height: Height * 0.2,
                                      width: Width * 0.25,
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 229, 241, 248),
                                          border: Border.all(
                                              width: 1, color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "State",
                                                    style: TextStyle(
                                                        fontFamily: "sans",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            Width * 0.008),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    height: Height * 0.05,
                                                    width: Width * 0.15,
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffd5ecfa),
                                                        border: Border.all(
                                                            width: 1,
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.location_city,
                                                          color: Colors.black87,
                                                          size: Width * 0.015,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          kissanstate,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "sans",
                                                              fontSize:
                                                                  Width * 0.01,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: Width * 0.015,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "City",
                                                    style: TextStyle(
                                                        fontFamily: "sans",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            Width * 0.008),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    height: Height * 0.05,
                                                    width: Width * 0.065,
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffd5ecfa),
                                                        border: Border.all(
                                                            width: 1,
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Icon(
                                                          Icons.location_city,
                                                          color: Colors.black87,
                                                          size: Width * 0.015,
                                                        ),
                                                        Text(
                                                          kissancity,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "sans",
                                                              fontSize:
                                                                  Width * 0.008,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Address",
                                                    style: TextStyle(
                                                        fontFamily: "sans",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            Width * 0.0081),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    height: Height * 0.05,
                                                    width: Width * 0.15,
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffd5ecfa),
                                                        border: Border.all(
                                                            width: 1,
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.location_on,
                                                          color: Colors.black87,
                                                          size: Width * 0.015,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          kissanaddress,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "sans",
                                                              fontSize:
                                                                  Width * 0.01,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: Width * 0.015,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Phone No.",
                                                    style: TextStyle(
                                                        fontFamily: "sans",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            Width * 0.008),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    height: Height * 0.05,
                                                    width: Width * 0.065,
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffd5ecfa),
                                                        border: Border.all(
                                                            width: 1,
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Icon(
                                                          Icons.phone,
                                                          color: Colors.black87,
                                                          size: Width * 0.01,
                                                        ),
                                                        Text(
                                                          kissanphone,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "sans",
                                                              fontSize:
                                                                  Width * 0.008,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ], //
                                ),
                              ),
                              Container(
                                width: Width * 0.35,
                                height: Height * 0.4,
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Vyapari details",
                                      style: TextStyle(
                                          fontFamily: "sans",
                                          fontSize: Width * 0.01,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: Height * 0.05,
                                          width: Width * 0.25,
                                          child: TypeAheadField(
                                            builder: (context, controller,
                                                focusNode) {
                                              selectedvyapari = controller;
                                              return TextFormField(
                                                validator: ValidationBuilder()
                                                    .minLength(2)
                                                    .maxLength(45)
                                                    .build(),
                                                cursorColor: Colors.black87,
                                                controller: selectedvyapari,
                                                focusNode: focusNode,
                                                decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.all(
                                                        Width * 0.005),
                                                    hoverColor:
                                                        Colors.grey.shade300,
                                                    hintText:
                                                        "Search For Vyapari",
                                                    hintStyle: TextStyle(
                                                      fontFamily: "sans",
                                                      fontSize: Width * 0.012,
                                                    ),
                                                    hintFadeDuration:
                                                        const Duration(
                                                            seconds: 1),
                                                    prefixIcon: Icon(
                                                      Icons.person,
                                                      size: Width * 0.015,
                                                    ),
                                                    fillColor: const Color.fromARGB(
                                                        255, 229, 241, 248),
                                                    filled: true,
                                                    enabledBorder: const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.grey)),
                                                    focusedBorder:
                                                        const OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                width: 1,
                                                                color: Colors
                                                                    .black87)),
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(5))),
                                              );
                                            },
                                            suggestionsCallback:
                                                (search) async {
                                              return await _Getdata(
                                                  search, "vyapari");
                                            },
                                            onSelected: (dynamic val) {
                                              setState(() {
                                                selectedvyapari.text =
                                                    val["first_name"];
                                                vyapariid = val["vyapari_id"]
                                                    .toString();
                                                vyaparicompany = val["company"];
                                                vyaparicity = val["city"];
                                                vyaparistate = val["state"];
                                                vyapariphone = val["phone"];
                                              });
                                            },
                                            itemBuilder:
                                                (context, dynamic suggestion) {
                                              final random = Random();
                                              final color = Color.fromARGB(
                                                320,
                                                random.nextInt(150),
                                                random.nextInt(243),
                                                random.nextInt(1),
                                              );
                                              if (suggestion != null) {
                                                // Add null check to ensure itemData is not null
                                                return ListTile(
                                                  trailing: Text(
                                                      suggestion["vyapari_id"]
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontFamily: "sans",
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  subtitle: Text(
                                                      suggestion["company"],
                                                      style: const TextStyle(
                                                          fontFamily: "sans",
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  leading: CircleAvatar(
                                                    backgroundColor: color,
                                                    child: Text(
                                                      suggestion["first_name"]
                                                          .toString()
                                                          .toUpperCase()[0],
                                                      style: const TextStyle(
                                                          fontFamily: "sans",
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  title: Text(
                                                      suggestion["first_name"] +
                                                          suggestion[
                                                              "last_name"],
                                                      style: const TextStyle(
                                                          fontFamily: "sans",
                                                          fontWeight: FontWeight
                                                              .bold)), // Adjust the field name as per your data structure
                                                  // Add other widget properties as needed
                                                );
                                              } else {
                                                return const SizedBox(); // or any other placeholder widget
                                              }
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: Width * 0.02,
                                        ),
                                        Container(
                                          height: Height * 0.05,
                                          width: Width * 0.065,
                                          decoration: BoxDecoration(
                                              color: const Color(0xffd5ecfa),
                                              border: Border.all(
                                                  width: 1, color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(
                                                Icons.card_membership_outlined,
                                                color: Colors.black87,
                                                size: Width * 0.015,
                                              ),
                                              Text(
                                                vyapariid.toString(),
                                                style: TextStyle(
                                                    fontFamily: "sans",
                                                    fontSize: Width * 0.01,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: Height * 0.03),
                                      padding: EdgeInsets.all(Width * 0.008),
                                      height: Height * 0.2,
                                      width: Width * 0.25,
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 229, 241, 248),
                                          border: Border.all(
                                              width: 1, color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "State",
                                                    style: TextStyle(
                                                        fontFamily: "sans",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            Width * 0.008),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    height: Height * 0.05,
                                                    width: Width * 0.15,
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffd5ecfa),
                                                        border: Border.all(
                                                            width: 1,
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.location_city,
                                                          color: Colors.black87,
                                                          size: Width * 0.015,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          vyaparistate
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "sans",
                                                              fontSize:
                                                                  Width * 0.01,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: Width * 0.015,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "City",
                                                    style: TextStyle(
                                                        fontFamily: "sans",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            Width * 0.008),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    height: Height * 0.05,
                                                    width: Width * 0.065,
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffd5ecfa),
                                                        border: Border.all(
                                                            width: 1,
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Icon(
                                                          Icons.location_city,
                                                          color: Colors.black87,
                                                          size: Width * 0.015,
                                                        ),
                                                        Text(
                                                          vyaparicity
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "sans",
                                                              fontSize:
                                                                  Width * 0.008,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Company",
                                                    style: TextStyle(
                                                        fontFamily: "sans",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            Width * 0.008),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    height: Height * 0.05,
                                                    width: Width * 0.15,
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffd5ecfa),
                                                        border: Border.all(
                                                            width: 1,
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.location_on,
                                                          color: Colors.black87,
                                                          size: Width * 0.015,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          vyaparicompany
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "sans",
                                                              fontSize:
                                                                  Width * 0.01,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: Width * 0.015,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Phone No.",
                                                    style: TextStyle(
                                                        fontFamily: "sans",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            Width * 0.008),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    height: Height * 0.05,
                                                    width: Width * 0.065,
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffd5ecfa),
                                                        border: Border.all(
                                                            width: 1,
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Icon(
                                                          Icons.phone,
                                                          color: Colors.black87,
                                                          size: Width * 0.01,
                                                        ),
                                                        Text(
                                                          vyapariphone,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "sans",
                                                              fontSize:
                                                                  Width * 0.008,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey.shade500,
                          endIndent: 40,
                          indent: 40,
                        ),
                        Container(
                          color: Colors.grey.shade300,
                          height: Height * 0.04,
                          width: Width * 0.76,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Ras",
                                style: TextStyle(
                                    fontFamily: "sans",
                                    fontWeight: FontWeight.bold,
                                    fontSize: Width * 0.01),
                              ),
                              Text(
                                "Board/Anuban",
                                style: TextStyle(
                                    fontFamily: "sans",
                                    fontWeight: FontWeight.bold,
                                    fontSize: Width * 0.01),
                              ),
                              Text(
                                "Motor No.",
                                style: TextStyle(
                                    fontFamily: "sans",
                                    fontWeight: FontWeight.bold,
                                    fontSize: Width * 0.01),
                              ),
                              Text(
                                "Bhuktan PK.",
                                style: TextStyle(
                                    fontFamily: "sans",
                                    fontWeight: FontWeight.bold,
                                    fontSize: Width * 0.01),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey.shade500,
                          endIndent: 40,
                          indent: 40,
                        ),
                        Container(
                          color: Colors.white,
                          height: Height * 0.05,
                          width: Width * 0.76,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: Width * 0.04),
                                height: Height * 0.05,
                                width: Width * 0.07,
                                child: TextFormField(
                                  controller: rascontroller,
                                  validator: ValidationBuilder()
                                      .minLength(1)
                                      .maxLength(45)
                                      .build(),
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) {
                                    ras = val.toString().toLowerCase();
                                  },
                                  cursorColor: Colors.black87,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.all(Width * 0.005),
                                      hoverColor: Colors.grey.shade300,
                                      hintText: "Ras",
                                      hintStyle: TextStyle(
                                        fontFamily: "sans",
                                        fontSize: Width * 0.01,
                                      ),
                                      hintFadeDuration:
                                          const Duration(seconds: 1),
                                      prefixIcon: Icon(
                                        Icons.numbers,
                                        size: Width * 0.015,
                                      ),
                                      fillColor: const Color.fromARGB(
                                          255, 229, 241, 248),
                                      filled: true,
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.grey)),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.black87)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: Width * 0.12),
                                height: Height * 0.05,
                                width: Width * 0.07,
                                child: TextFormField(
                                  enabled: false,
                                  controller: boardcontroller,
                                  validator: ValidationBuilder()
                                      .minLength(1)
                                      .maxLength(45)
                                      .build(),
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) {
                                    board = val.toString().toLowerCase();
                                  },
                                  cursorColor: Colors.black87,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.all(Width * 0.005),
                                      hoverColor: Colors.grey.shade300,
                                      hintText: "Board",
                                      hintStyle: TextStyle(
                                        fontFamily: "sans",
                                        fontSize: Width * 0.01,
                                      ),
                                      hintFadeDuration:
                                          const Duration(seconds: 1),
                                      prefixIcon: Icon(
                                        Icons.numbers,
                                        size: Width * 0.015,
                                      ),
                                      fillColor: const Color.fromARGB(
                                          255, 229, 241, 248),
                                      filled: true,
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.grey)),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.black87)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: Width * 0.135),
                                height: Height * 0.05,
                                width: Width * 0.07,
                                child: TextFormField(
                                  controller: motornocontroller,
                                  validator: ValidationBuilder()
                                      .minLength(1)
                                      .maxLength(45)
                                      .build(),
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) {
                                    motorno = val.toString().toLowerCase();
                                  },
                                  cursorColor: Colors.black87,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.all(Width * 0.005),
                                      hoverColor: Colors.grey.shade300,
                                      hintText: "Motor No.",
                                      hintStyle: TextStyle(
                                        fontFamily: "sans",
                                        fontSize: Width * 0.01,
                                      ),
                                      hintFadeDuration:
                                          const Duration(seconds: 1),
                                      prefixIcon: Icon(
                                        Icons.numbers,
                                        size: Width * 0.015,
                                      ),
                                      fillColor: const Color.fromARGB(
                                          255, 229, 241, 248),
                                      filled: true,
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.grey)),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.black87)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: Width * 0.12),
                                height: Height * 0.05,
                                width: Width * 0.07,
                                child: TextFormField(
                                  controller: bhuktancontroller,
                                  validator: ValidationBuilder()
                                      .minLength(1)
                                      .maxLength(45)
                                      .build(),
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) {
                                    bhuktanpk = val.toString().toLowerCase();
                                  },
                                  cursorColor: Colors.black87,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.all(Width * 0.005),
                                      hoverColor: Colors.grey.shade300,
                                      hintText: "Bhuktan PK",
                                      hintStyle: TextStyle(
                                        fontFamily: "sans",
                                        fontSize: Width * 0.01,
                                      ),
                                      hintFadeDuration:
                                          const Duration(seconds: 1),
                                      prefixIcon: Icon(
                                        Icons.numbers,
                                        size: Width * 0.015,
                                      ),
                                      fillColor: const Color.fromARGB(
                                          255, 229, 241, 248),
                                      filled: true,
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.grey)),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.black87)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                ),
                              ), //
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey.shade500,
                          endIndent: 40,
                          indent: 40,
                        ),
                        Row(
                          children: [
                            Container(
                              color: Colors.white,
                              width: Width * 0.8,
                              height: Height * 0.6,
                              margin: EdgeInsets.only(top: Width * 0.02),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: Width * 0.025),
                                    child: Text(
                                      "Parcha details",
                                      style: TextStyle(
                                          fontFamily: "sans",
                                          fontSize: Width * 0.01,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: Height * 0.01,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        width: Width * 0.35,
                                        height: Height * 0.55,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                width: 1, color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Container(
                                                  height: Height * 0.1,
                                                  width: Width * 0.08,
                                                  color: Colors.white,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Village",
                                                        style: TextStyle(
                                                            fontFamily: "sans",
                                                            fontSize:
                                                                Width * 0.008,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: Height * 0.005,
                                                      ),
                                                      SizedBox(
                                                        height: Height * 0.05,
                                                        width: Width * 0.07,
                                                        child: TextFormField(
                                                          controller:
                                                              villagecontroller,
                                                          validator:
                                                              ValidationBuilder()
                                                                  .minLength(1)
                                                                  .maxLength(45)
                                                                  .build(),
                                                          onChanged: (val) {
                                                            parchavillage = val
                                                                .toString()
                                                                .toLowerCase();
                                                          },
                                                          cursorColor:
                                                              Colors.black87,
                                                          decoration:
                                                              InputDecoration(
                                                                  contentPadding:
                                                                      EdgeInsets.all(Width *
                                                                          0.005),
                                                                  hoverColor: Colors
                                                                      .grey
                                                                      .shade300,
                                                                  hintText:
                                                                      "Village",
                                                                  hintStyle:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        "sans",
                                                                    fontSize:
                                                                        Width *
                                                                            0.01,
                                                                  ),
                                                                  hintFadeDuration:
                                                                      const Duration(
                                                                          seconds:
                                                                              1),
                                                                  prefixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .numbers,
                                                                    size: Width *
                                                                        0.015,
                                                                  ),
                                                                  fillColor: const Color.fromARGB(
                                                                      255,
                                                                      229,
                                                                      241,
                                                                      248),
                                                                  filled: true,
                                                                  enabledBorder: const OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          width:
                                                                              1,
                                                                          color: Colors
                                                                              .grey)),
                                                                  focusedBorder: const OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          width:
                                                                              1,
                                                                          color: Colors.black87)),
                                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: Height * 0.1,
                                                  width: Width * 0.08,
                                                  color: Colors.white,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Bhav",
                                                        style: TextStyle(
                                                            fontFamily: "sans",
                                                            fontSize:
                                                                Width * 0.008,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: Height * 0.005,
                                                      ),
                                                      SizedBox(
                                                        height: Height * 0.05,
                                                        width: Width * 0.07,
                                                        child: TextFormField(
                                                          controller:
                                                              bhavcontroller,
                                                          validator:
                                                              ValidationBuilder()
                                                                  .minLength(1)
                                                                  .maxLength(45)
                                                                  .build(),
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .digitsOnly,
                                                          ],
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          onChanged: (val) {
                                                            setState(() {
                                                              bhav =
                                                                  double.parse(
                                                                      val);
                                                            });
                                                          },
                                                          cursorColor:
                                                              Colors.black87,
                                                          decoration:
                                                              InputDecoration(
                                                                  contentPadding:
                                                                      EdgeInsets.all(Width *
                                                                          0.005),
                                                                  hoverColor: Colors
                                                                      .grey
                                                                      .shade300,
                                                                  hintText:
                                                                      "Bhav",
                                                                  hintStyle:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        "sans",
                                                                    fontSize:
                                                                        Width *
                                                                            0.01,
                                                                  ),
                                                                  hintFadeDuration:
                                                                      const Duration(
                                                                          seconds:
                                                                              1),
                                                                  prefixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .numbers,
                                                                    size: Width *
                                                                        0.015,
                                                                  ),
                                                                  fillColor: const Color.fromARGB(
                                                                      255,
                                                                      229,
                                                                      241,
                                                                      248),
                                                                  filled: true,
                                                                  enabledBorder: const OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          width:
                                                                              1,
                                                                          color: Colors
                                                                              .grey)),
                                                                  focusedBorder: const OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          width:
                                                                              1,
                                                                          color: Colors.black87)),
                                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: Height * 0.1,
                                                  width: Width * 0.08,
                                                  color: Colors.white,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Lungar",
                                                        style: TextStyle(
                                                            fontFamily: "sans",
                                                            fontSize:
                                                                Width * 0.008,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: Height * 0.005,
                                                      ),
                                                      SizedBox(
                                                        height: Height * 0.05,
                                                        width: Width * 0.07,
                                                        child: TextFormField(
                                                          controller:
                                                              lungarcontroller,
                                                          validator:
                                                              ValidationBuilder()
                                                                  .minLength(1)
                                                                  .maxLength(45)
                                                                  .build(),
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .digitsOnly,
                                                          ],
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          onChanged: (val) {
                                                            setState(() {
                                                              lungar =
                                                                  double.parse(
                                                                      val);
                                                            });
                                                          },
                                                          cursorColor:
                                                              Colors.black87,
                                                          decoration:
                                                              InputDecoration(
                                                                  contentPadding:
                                                                      EdgeInsets.all(Width *
                                                                          0.005),
                                                                  hoverColor: Colors
                                                                      .grey
                                                                      .shade300,
                                                                  hintText:
                                                                      "Lungar",
                                                                  hintStyle:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        "sans",
                                                                    fontSize:
                                                                        Width *
                                                                            0.01,
                                                                  ),
                                                                  hintFadeDuration:
                                                                      const Duration(
                                                                          seconds:
                                                                              1),
                                                                  prefixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .numbers,
                                                                    size: Width *
                                                                        0.015,
                                                                  ),
                                                                  fillColor: const Color.fromARGB(
                                                                      255,
                                                                      229,
                                                                      241,
                                                                      248),
                                                                  filled: true,
                                                                  enabledBorder: const OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          width:
                                                                              1,
                                                                          color: Colors
                                                                              .grey)),
                                                                  focusedBorder: const OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          width:
                                                                              1,
                                                                          color: Colors.black87)),
                                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Container(
                                                  height: Height * 0.1,
                                                  width: Width * 0.08,
                                                  color: Colors.white,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Gross Wt(kg)",
                                                        style: TextStyle(
                                                            fontFamily: "sans",
                                                            fontSize:
                                                                Width * 0.008,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: Height * 0.005,
                                                      ),
                                                      SizedBox(
                                                        height: Height * 0.05,
                                                        width: Width * 0.07,
                                                        child: TextFormField(
                                                          controller:
                                                              grosscontroller,
                                                          validator:
                                                              ValidationBuilder()
                                                                  .minLength(1)
                                                                  .maxLength(45)
                                                                  .build(),
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          onChanged: (val) {
                                                            setState(() {
                                                              gross =
                                                                  double.parse(
                                                                      val);
                                                            });
                                                          },
                                                          cursorColor:
                                                              Colors.black87,
                                                          decoration:
                                                              InputDecoration(
                                                                  contentPadding:
                                                                      EdgeInsets.all(Width *
                                                                          0.005),
                                                                  hoverColor: Colors
                                                                      .grey
                                                                      .shade300,
                                                                  hintText:
                                                                      "Gross",
                                                                  hintStyle:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        "sans",
                                                                    fontSize:
                                                                        Width *
                                                                            0.01,
                                                                  ),
                                                                  hintFadeDuration:
                                                                      const Duration(
                                                                          seconds:
                                                                              1),
                                                                  prefixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .numbers,
                                                                    size: Width *
                                                                        0.015,
                                                                  ),
                                                                  fillColor: const Color.fromARGB(
                                                                      255,
                                                                      229,
                                                                      241,
                                                                      248),
                                                                  filled: true,
                                                                  enabledBorder: const OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          width:
                                                                              1,
                                                                          color: Colors
                                                                              .grey)),
                                                                  focusedBorder: const OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          width:
                                                                              1,
                                                                          color: Colors.black87)),
                                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: Height * 0.1,
                                                  width: Width * 0.08,
                                                  color: Colors.white,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Tare Wt(kg)",
                                                        style: TextStyle(
                                                            fontFamily: "sans",
                                                            fontSize:
                                                                Width * 0.008,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: Height * 0.005,
                                                      ),
                                                      SizedBox(
                                                        height: Height * 0.05,
                                                        width: Width * 0.07,
                                                        child: TextFormField(
                                                          controller:
                                                              tarecontroller,
                                                          validator:
                                                              ValidationBuilder()
                                                                  .minLength(1)
                                                                  .maxLength(45)
                                                                  .build(),
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          onChanged: (val) {
                                                            setState(() {
                                                              tare =
                                                                  double.parse(
                                                                      val);
                                                            });
                                                          },
                                                          cursorColor:
                                                              Colors.black87,
                                                          decoration:
                                                              InputDecoration(
                                                                  contentPadding:
                                                                      EdgeInsets.all(Width *
                                                                          0.005),
                                                                  hoverColor: Colors
                                                                      .grey
                                                                      .shade300,
                                                                  hintText:
                                                                      "Tare",
                                                                  hintStyle:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        "sans",
                                                                    fontSize:
                                                                        Width *
                                                                            0.01,
                                                                  ),
                                                                  hintFadeDuration:
                                                                      const Duration(
                                                                          seconds:
                                                                              1),
                                                                  prefixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .numbers,
                                                                    size: Width *
                                                                        0.015,
                                                                  ),
                                                                  fillColor: const Color.fromARGB(
                                                                      255,
                                                                      229,
                                                                      241,
                                                                      248),
                                                                  filled: true,
                                                                  enabledBorder: const OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          width:
                                                                              1,
                                                                          color: Colors
                                                                              .grey)),
                                                                  focusedBorder: const OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          width:
                                                                              1,
                                                                          color: Colors.black87)),
                                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: Height * 0.1,
                                                  width: Width * 0.08,
                                                  color: Colors.white,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Units",
                                                        style: TextStyle(
                                                            fontFamily: "sans",
                                                            fontSize:
                                                                Width * 0.008,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: Height * 0.005,
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color
                                                              .fromARGB(255,
                                                              229, 241, 248),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        height: Height * 0.05,
                                                        width: Width * 0.07,
                                                        child: DropdownButton(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  Width *
                                                                      0.0045),
                                                          iconSize:
                                                              Width * 0.01,
                                                          underline:
                                                              const Text(""),
                                                          isExpanded: true,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          dropdownColor:
                                                              Colors.white,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "sans",
                                                              fontSize:
                                                                  Width * 0.01,
                                                              color: Colors
                                                                  .black87),
                                                          value: dropdownValue,
                                                          onChanged: (String?
                                                              newValue) {
                                                            setState(() {
                                                              dropdownValue =
                                                                  newValue!;
                                                              if (dropdownValue ==
                                                                  "Loose") {
                                                                pati = true;
                                                                danda = false;
                                                                wastage = false;
                                                              } else if (dropdownValue ==
                                                                  "Carate") {
                                                                pati = true;
                                                                danda = true;
                                                                wastage = false;
                                                              } else if (dropdownValue ==
                                                                  "Panje") {
                                                                pati = true;
                                                                danda = true;
                                                                wastage = false;
                                                              } else if (dropdownValue ==
                                                                  "Box") {
                                                                pati = true;
                                                                danda = true;
                                                                wastage = true;
                                                              }
                                                            });
                                                          },
                                                          items: <String>[
                                                            'Loose',
                                                            'Carate',
                                                            'Panje',
                                                            'Box'
                                                          ].map<
                                                              DropdownMenuItem<
                                                                  String>>((String
                                                              value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value,
                                                              child:
                                                                  Text(value),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Visibility(
                                              visible: pati,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: Width * 0.018,
                                                  ),
                                                  Container(
                                                    height: Height * 0.1,
                                                    width: Width * 0.08,
                                                    color: Colors.white,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Pati",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "sans",
                                                              fontSize:
                                                                  Width * 0.008,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              Height * 0.005,
                                                        ),
                                                        SizedBox(
                                                          height: Height * 0.05,
                                                          width: Width * 0.07,
                                                          child: TextFormField(
                                                            controller:
                                                                paticontroller,
                                                            validator:
                                                                ValidationBuilder()
                                                                    .minLength(
                                                                        1)
                                                                    .maxLength(
                                                                        45)
                                                                    .build(),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            onChanged: (val) {
                                                              setState(() {
                                                                patival = double
                                                                    .parse(val);
                                                              });
                                                            },
                                                            cursorColor:
                                                                Colors.black87,
                                                            decoration:
                                                                InputDecoration(
                                                                    contentPadding:
                                                                        EdgeInsets.all(Width *
                                                                            0.005),
                                                                    hoverColor: Colors
                                                                        .grey
                                                                        .shade300,
                                                                    hintText:
                                                                        "Pati",
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          "sans",
                                                                      fontSize:
                                                                          Width *
                                                                              0.01,
                                                                    ),
                                                                    hintFadeDuration:
                                                                        const Duration(
                                                                            seconds:
                                                                                1),
                                                                    prefixIcon:
                                                                        Icon(
                                                                      Icons
                                                                          .numbers,
                                                                      size: Width *
                                                                          0.015,
                                                                    ),
                                                                    fillColor:
                                                                        const Color.fromARGB(
                                                                            255,
                                                                            229,
                                                                            241,
                                                                            248),
                                                                    filled:
                                                                        true,
                                                                    enabledBorder: const OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            width:
                                                                                1,
                                                                            color: Colors
                                                                                .grey)),
                                                                    focusedBorder: const OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            width:
                                                                                1,
                                                                            color:
                                                                                Colors.black87)),
                                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: Width * 0.037,
                                                  ),
                                                  Container(
                                                    height: Height * 0.1,
                                                    width: Width * 0.08,
                                                    color: Colors.white,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "PatiUnit",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "sans",
                                                              fontSize:
                                                                  Width * 0.008,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              Height * 0.005,
                                                        ),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                229, 241, 248),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          height: Height * 0.05,
                                                          width: Width * 0.07,
                                                          child: DropdownButton(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    Width *
                                                                        0.0045),
                                                            iconSize:
                                                                Width * 0.01,
                                                            underline:
                                                                const Text(""),
                                                            isExpanded: true,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            dropdownColor:
                                                                Colors.white,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "sans",
                                                                fontSize:
                                                                    Width *
                                                                        0.01,
                                                                color: Colors
                                                                    .black87),
                                                            value: _patiunit,
                                                            onChanged: (String?
                                                                newValue) {
                                                              setState(() {
                                                                _patiunit =
                                                                    newValue!;
                                                              });
                                                            },
                                                            items: <String>[
                                                              'Percent',
                                                              'KG',
                                                            ].map<
                                                                DropdownMenuItem<
                                                                    String>>((String
                                                                value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child:
                                                                    Text(value),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: Width * 0.037,
                                                  ),
                                                  Container(
                                                    height: Height * 0.1,
                                                    width: Width * 0.08,
                                                    color: Colors.white,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Pati Wt",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "sans",
                                                              fontSize:
                                                                  Width * 0.008,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              Height * 0.005,
                                                        ),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                229, 241, 248),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          height: Height * 0.05,
                                                          width: Width * 0.07,
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    Width *
                                                                        0.004),
                                                            height:
                                                                Height * 0.05,
                                                            width: Width * 0.07,
                                                            decoration: BoxDecoration(
                                                                color: const Color(
                                                                    0xffd5ecfa),
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .grey),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            child: Text(
                                                                "$patiwt",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "sans",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black87,
                                                                    fontSize:
                                                                        Width *
                                                                            0.008)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ), //working
                                            Visibility(
                                              visible: danda,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: Width * 0.018,
                                                  ),
                                                  Container(
                                                    height: Height * 0.1,
                                                    width: Width * 0.08,
                                                    color: Colors.white,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Danda",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "sans",
                                                              fontSize:
                                                                  Width * 0.008,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              Height * 0.005,
                                                        ),
                                                        SizedBox(
                                                          height: Height * 0.05,
                                                          width: Width * 0.07,
                                                          child: TextFormField(
                                                            controller:
                                                                dandacontroller,
                                                            validator:
                                                                ValidationBuilder()
                                                                    .minLength(
                                                                        1)
                                                                    .maxLength(
                                                                        45)
                                                                    .build(),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            onChanged: (val) {
                                                              setState(() {
                                                                dandaval =
                                                                    double.parse(
                                                                        val);
                                                              });
                                                            },
                                                            cursorColor:
                                                                Colors.black87,
                                                            decoration:
                                                                InputDecoration(
                                                                    contentPadding:
                                                                        EdgeInsets.all(Width *
                                                                            0.005),
                                                                    hoverColor: Colors
                                                                        .grey
                                                                        .shade300,
                                                                    hintText:
                                                                        "Danda",
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          "sans",
                                                                      fontSize:
                                                                          Width *
                                                                              0.01,
                                                                    ),
                                                                    hintFadeDuration:
                                                                        const Duration(
                                                                            seconds:
                                                                                1),
                                                                    prefixIcon:
                                                                        Icon(
                                                                      Icons
                                                                          .numbers,
                                                                      size: Width *
                                                                          0.015,
                                                                    ),
                                                                    fillColor:
                                                                        const Color.fromARGB(
                                                                            255,
                                                                            229,
                                                                            241,
                                                                            248),
                                                                    filled:
                                                                        true,
                                                                    enabledBorder: const OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            width:
                                                                                1,
                                                                            color: Colors
                                                                                .grey)),
                                                                    focusedBorder: const OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            width:
                                                                                1,
                                                                            color:
                                                                                Colors.black87)),
                                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: Width * 0.037,
                                                  ),
                                                  Container(
                                                    height: Height * 0.1,
                                                    width: Width * 0.08,
                                                    color: Colors.white,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "DandaUnit",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "sans",
                                                              fontSize:
                                                                  Width * 0.008,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              Height * 0.005,
                                                        ),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                229, 241, 248),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          height: Height * 0.05,
                                                          width: Width * 0.07,
                                                          child: DropdownButton(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    Width *
                                                                        0.0045),
                                                            iconSize:
                                                                Width * 0.01,
                                                            underline:
                                                                const Text(""),
                                                            isExpanded: true,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            dropdownColor:
                                                                Colors.white,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "sans",
                                                                fontSize:
                                                                    Width *
                                                                        0.01,
                                                                color: Colors
                                                                    .black87),
                                                            value: _dandaunit,
                                                            onChanged: (String?
                                                                newValue) {
                                                              setState(() {
                                                                _dandaunit =
                                                                    newValue!;
                                                              });
                                                            },
                                                            items: <String>[
                                                              'Percent',
                                                              'KG',
                                                            ].map<
                                                                DropdownMenuItem<
                                                                    String>>((String
                                                                value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child:
                                                                    Text(value),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: Width * 0.037,
                                                  ),
                                                  Container(
                                                    height: Height * 0.1,
                                                    width: Width * 0.08,
                                                    color: Colors.white,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Danda Wt",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "sans",
                                                              fontSize:
                                                                  Width * 0.008,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              Height * 0.005,
                                                        ),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                229, 241, 248),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          height: Height * 0.05,
                                                          width: Width * 0.07,
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    Width *
                                                                        0.004),
                                                            height:
                                                                Height * 0.05,
                                                            width: Width * 0.07,
                                                            decoration: BoxDecoration(
                                                                color: const Color(
                                                                    0xffd5ecfa),
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .grey),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            child: Text(
                                                              dandawt
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "sans",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black87,
                                                                  fontSize:
                                                                      Width *
                                                                          0.008),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ), //working
                                            Visibility(
                                              visible: wastage,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: Width * 0.018,
                                                  ),
                                                  Container(
                                                    height: Height * 0.1,
                                                    width: Width * 0.08,
                                                    color: Colors.white,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Wastage",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "sans",
                                                              fontSize:
                                                                  Width * 0.008,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              Height * 0.005,
                                                        ),
                                                        SizedBox(
                                                          height: Height * 0.05,
                                                          width: Width * 0.07,
                                                          child: TextFormField(
                                                            controller:
                                                                wastagecontroller,
                                                            validator:
                                                                ValidationBuilder()
                                                                    .minLength(
                                                                        1)
                                                                    .maxLength(
                                                                        45)
                                                                    .build(),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            onChanged: (val) {
                                                              setState(() {
                                                                wastageval =
                                                                    double.parse(
                                                                        val);
                                                              });
                                                            },
                                                            cursorColor:
                                                                Colors.black87,
                                                            decoration:
                                                                InputDecoration(
                                                                    contentPadding:
                                                                        EdgeInsets.all(Width *
                                                                            0.005),
                                                                    hoverColor: Colors
                                                                        .grey
                                                                        .shade300,
                                                                    hintText:
                                                                        "Wastage",
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          "sans",
                                                                      fontSize:
                                                                          Width *
                                                                              0.01,
                                                                    ),
                                                                    hintFadeDuration:
                                                                        const Duration(
                                                                            seconds:
                                                                                1),
                                                                    prefixIcon:
                                                                        Icon(
                                                                      Icons
                                                                          .numbers,
                                                                      size: Width *
                                                                          0.015,
                                                                    ),
                                                                    fillColor:
                                                                        const Color.fromARGB(
                                                                            255,
                                                                            229,
                                                                            241,
                                                                            248),
                                                                    filled:
                                                                        true,
                                                                    enabledBorder: const OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            width:
                                                                                1,
                                                                            color: Colors
                                                                                .grey)),
                                                                    focusedBorder: const OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            width:
                                                                                1,
                                                                            color:
                                                                                Colors.black87)),
                                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: Width * 0.037,
                                                  ),
                                                  Container(
                                                    height: Height * 0.1,
                                                    width: Width * 0.08,
                                                    color: Colors.white,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "WastageUnit",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "sans",
                                                              fontSize:
                                                                  Width * 0.008,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              Height * 0.005,
                                                        ),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                229, 241, 248),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          height: Height * 0.05,
                                                          width: Width * 0.07,
                                                          child: DropdownButton(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    Width *
                                                                        0.0045),
                                                            iconSize:
                                                                Width * 0.01,
                                                            underline:
                                                                const Text(""),
                                                            isExpanded: true,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            dropdownColor:
                                                                Colors.white,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "sans",
                                                                fontSize:
                                                                    Width *
                                                                        0.01,
                                                                color: Colors
                                                                    .black87),
                                                            value: _wastageunit,
                                                            onChanged: (String?
                                                                newValue) {
                                                              setState(() {
                                                                _wastageunit =
                                                                    newValue!;
                                                              });
                                                            },
                                                            items: <String>[
                                                              'Percent',
                                                              'KG',
                                                            ].map<
                                                                DropdownMenuItem<
                                                                    String>>((String
                                                                value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child:
                                                                    Text(value),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: Width * 0.037,
                                                  ),
                                                  Container(
                                                    height: Height * 0.1,
                                                    width: Width * 0.08,
                                                    color: Colors.white,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Wastage Wt",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "sans",
                                                              fontSize:
                                                                  Width * 0.008,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              Height * 0.005,
                                                        ),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                229, 241, 248),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          height: Height * 0.05,
                                                          width: Width * 0.07,
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    Width *
                                                                        0.004),
                                                            height:
                                                                Height * 0.05,
                                                            width: Width * 0.07,
                                                            decoration: BoxDecoration(
                                                                color: const Color(
                                                                    0xffd5ecfa),
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .grey),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            child: Text(
                                                              wastagewt
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "sans",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black87,
                                                                  fontSize:
                                                                      Width *
                                                                          0.008),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ), //working
                                            Container(
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.red),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (dropdownValue ==
                                                          "Carate") {
                                                        _caratecalc();
                                                      }
                                                      if (dropdownValue ==
                                                          "Panje") {
                                                        _caratecalc();
                                                      }
                                                      if (dropdownValue ==
                                                          "Loose") {
                                                        _loosecalc();
                                                      }
                                                      if (dropdownValue ==
                                                          "Box") {
                                                        _boxcalc();
                                                      }
                                                    });
                                                  },
                                                  child: Text(
                                                    "Get WT",
                                                    style: TextStyle(
                                                        fontFamily: "sans",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        fontSize:
                                                            Width * 0.008),
                                                  )),
                                            )
                                          ], //this
                                        ),
                                      ),
                                      Container(
                                        height: Height * 0.55,
                                        width: Width * 0.35,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                width: 1, color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: const Center(
                                          child: Text(
                                            "Under Development",
                                            style:
                                                TextStyle(fontFamily: "sans"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: Height * 0.05,
                        ),
                        Divider(
                          color: Colors.grey.shade500,
                          endIndent: 40,
                          indent: 40,
                        ),
                        Container(
                          // margin: EdgeInsets.only(top: Width * 0.02),
                          height: Height * 0.35,
                          width: Width * 0.75,
                          color: Colors.white,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(Width * 0.015),
                                height: Height * 0.35,
                                width: Width * 0.35,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    // border:
                                    //     Border.all(width: 1, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Nett Weight",
                                          style: TextStyle(
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xff2278fd),
                                              fontSize: Width * 0.01),
                                        ),
                                        Text(
                                          "₹$nettweight",
                                          style: TextStyle(
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                              fontSize: Width * 0.01),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Kissan Amount",
                                          style: TextStyle(
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xff2278fd),
                                              fontSize: Width * 0.01),
                                        ),
                                        Text(
                                          "₹$kissanamt",
                                          style: TextStyle(
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                              fontSize: Width * 0.01),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          height: Height * 0.04,
                                          width: Width * 0.08,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Hammali",
                                                style: TextStyle(
                                                    fontFamily: "sans",
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        const Color(0xff2278fd),
                                                    fontSize: Width * 0.01),
                                              ),
                                              SizedBox(
                                                width: Width * 0.01,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 229, 241, 248),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                height: Height * 0.035,
                                                width: Width * 0.03,
                                                child: DropdownButton(
                                                  padding: EdgeInsets.all(
                                                      Width * 0.0025),
                                                  iconSize: Width * 0.01,
                                                  underline: const Text(""),
                                                  isExpanded: true,
                                                  dropdownColor: Colors.white,
                                                  style: TextStyle(
                                                      fontFamily: "sans",
                                                      fontSize: Width * 0.01,
                                                      color: Colors.black87),
                                                  value: hammalipercent,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      hammalipercent =
                                                          newValue!;
                                                    });
                                                  },
                                                  items: <String>[
                                                    '5',
                                                    '10',
                                                    '15',
                                                    '20',
                                                    '25',
                                                    '30',
                                                  ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "₹$hammnali",
                                          style: TextStyle(
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                              fontSize: Width * 0.01),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          height: Height * 0.04,
                                          width: Width * 0.1,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Commission",
                                                style: TextStyle(
                                                    fontFamily: "sans",
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        const Color(0xff2278fd),
                                                    fontSize: Width * 0.01),
                                              ),
                                              SizedBox(
                                                width: Width * 0.01,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 229, 241, 248),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                height: Height * 0.035,
                                                width: Width * 0.03,
                                                child: DropdownButton(
                                                  padding: EdgeInsets.all(
                                                      Width * 0.0025),
                                                  iconSize: Width * 0.01,
                                                  underline: const Text(""),
                                                  isExpanded: true,
                                                  dropdownColor: Colors.white,
                                                  style: TextStyle(
                                                      fontFamily: "sans",
                                                      fontSize: Width * 0.01,
                                                      color: Colors.black87),
                                                  value: commissionpercent,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      commissionpercent =
                                                          newValue!;
                                                    });
                                                  },
                                                  items: <String>[
                                                    '5',
                                                    '10',
                                                    '15',
                                                    '20',
                                                    '25',
                                                    '30',
                                                  ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "₹$commission",
                                          style: TextStyle(
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                              fontSize: Width * 0.01),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          height: Height * 0.04,
                                          width: Width * 0.1,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "M TAX",
                                                style: TextStyle(
                                                    fontFamily: "sans",
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        const Color(0xff2278fd),
                                                    fontSize: Width * 0.01),
                                              ),
                                              SizedBox(
                                                width: Width * 0.01,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 229, 241, 248),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                height: Height * 0.035,
                                                width: Width * 0.03,
                                                child: DropdownButton(
                                                  padding: EdgeInsets.all(
                                                      Width * 0.0025),
                                                  iconSize: Width * 0.01,
                                                  underline: const Text(""),
                                                  isExpanded: true,
                                                  dropdownColor: Colors.white,
                                                  style: TextStyle(
                                                      fontFamily: "sans",
                                                      fontSize: Width * 0.01,
                                                      color: Colors.black87),
                                                  value: mtaxpercent,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      mtaxpercent = newValue!;
                                                    });
                                                  },
                                                  items: <String>[
                                                    '1',
                                                    '2',
                                                    '3',
                                                    '4',
                                                    '5',
                                                  ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "₹$mtax",
                                          style: TextStyle(
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                              fontSize: Width * 0.01),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.grey.shade500,
                                      endIndent: 10,
                                      indent: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Sub Total - ",
                                          style: TextStyle(
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xff2278fd),
                                              fontSize: Width * 0.01),
                                        ),
                                        Text(
                                          "₹$subtotal",
                                          style: TextStyle(
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                              fontSize: Width * 0.01),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: Width * 0.05,
                              ),
                              Container(
                                padding: EdgeInsets.all(Width * 0.015),
                                height: Height * 0.35,
                                width: Width * 0.35,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    // border:
                                    //     Border.all(width: 1, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Sub Total",
                                          style: TextStyle(
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xff2278fd),
                                              fontSize: Width * 0.01),
                                        ),
                                        Text(
                                          "₹$subtotal",
                                          style: TextStyle(
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                              fontSize: Width * 0.01),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          height: Height * 0.04,
                                          width: Width * 0.08,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "OT",
                                                style: TextStyle(
                                                    fontFamily: "sans",
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        const Color(0xff2278fd),
                                                    fontSize: Width * 0.01),
                                              ),
                                              SizedBox(
                                                width: Width * 0.01,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "₹$ot",
                                          style: TextStyle(
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                              fontSize: Width * 0.01),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          height: Height * 0.04,
                                          width: Width * 0.1,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "TCS",
                                                style: TextStyle(
                                                    fontFamily: "sans",
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        const Color(0xff2278fd),
                                                    fontSize: Width * 0.01),
                                              ),
                                              SizedBox(
                                                width: Width * 0.01,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 229, 241, 248),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                height: Height * 0.035,
                                                width: Width * 0.03,
                                                child: DropdownButton(
                                                  padding: EdgeInsets.all(
                                                      Width * 0.0025),
                                                  iconSize: Width * 0.01,
                                                  underline: const Text(""),
                                                  isExpanded: true,
                                                  dropdownColor: Colors.white,
                                                  style: TextStyle(
                                                      fontFamily: "sans",
                                                      fontSize: Width * 0.01,
                                                      color: Colors.black87),
                                                  value: tcspercent,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      tcspercent = newValue!;
                                                    });
                                                  },
                                                  items: <String>[
                                                    '0',
                                                    '1',
                                                    '2',
                                                    '3',
                                                    '4',
                                                    '5',
                                                  ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          tcs.toString(),
                                          style: TextStyle(
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                              fontSize: Width * 0.01),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: Height * 0.04,
                                    ),
                                    Divider(
                                      color: Colors.grey.shade500,
                                      endIndent: 10,
                                      indent: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Grand Total - ",
                                          style: TextStyle(
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xff2278fd),
                                              fontSize: Width * 0.01),
                                        ),
                                        Text(
                                          "₹$grandtotal",
                                          style: TextStyle(
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                              fontSize: Width * 0.01),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Height * 0.05,
                        ),
                        Divider(
                          color: Colors.grey.shade500,
                          endIndent: 40,
                          indent: 40,
                        ),
                        Container(
                          color: Colors.grey.shade300,
                          height: Height * 0.04,
                          width: Width * 0.76,
                          child: TextFormField(
                            onChanged: (val) {
                              note = val.toString().toLowerCase();
                            },
                            cursorColor: Colors.black87,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(Width * 0.005),
                                hoverColor: Colors.grey.shade300,
                                hintText: "Note",
                                hintStyle: TextStyle(
                                  fontFamily: "sans",
                                  fontSize: Width * 0.01,
                                ),
                                hintFadeDuration: const Duration(seconds: 1),
                                prefixIcon: Icon(
                                  Icons.edit,
                                  size: Width * 0.015,
                                ),
                                fillColor:
                                    const Color.fromARGB(255, 229, 241, 248),
                                filled: true,
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.grey)),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.black87)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                        ),
                        Divider(
                          color: Colors.grey.shade500,
                          endIndent: 40,
                          indent: 40,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: Width * 0.01,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: Height * 0.02),
                    color: Colors.transparent,
                    width: Width * 0.15,
                    height: Height * 1.7,
                    child: Column(
                      children: [
                        SizedBox(
                          height: Width * 0.01,
                        ),
                        Container(
                          color: Colors.transparent,
                          width: Width * 0.12,
                          height: Height * 0.04,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 0, 0, 0),
                                  padding: EdgeInsets.all(Width * 0.01),
                                  shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.share,
                                    color: Colors.white,
                                    size: Width * 0.008,
                                  ),
                                  SizedBox(
                                    width: Width * 0.005,
                                  ),
                                  const Text(
                                    "Send Invoice",
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(
                          height: Width * 0.015,
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: Width * 0.015),
                              color: Colors.transparent,
                              width: Width * 0.05,
                              height: Height * 0.04,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 0, 84, 252),
                                    padding: EdgeInsets.all(Width * 0.01),
                                    shape: ContinuousRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (builder) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          title: const Center(
                                            child: Icon(
                                              Icons.info_rounded,
                                              color: Colors.green,
                                              size: 50,
                                            ),
                                          ),
                                          content: const Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                'Confirm Submission',
                                                style: TextStyle(
                                                  fontFamily: "sans",
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Are you sure you want to submit this bill?',
                                                style: TextStyle(
                                                    fontFamily: "sans"),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    fontFamily: "sans",
                                                    color: Colors.red),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                // bool already =
                                                //     await _alreadyaccountcheck();
                                                await _addbill(context);
                                                setState(() {
                                                  downbtn = true;
                                                });
                                              },
                                              child: const Text(
                                                'Confirm',
                                                style: TextStyle(
                                                    fontFamily: "sanss",
                                                    color: Colors.green),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: Text(
                                  "Update",
                                  style: TextStyle(
                                      fontFamily: "sans",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: Width * 0.0065),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Width * 0.019,
                            ),
                            Container(
                              color: Colors.transparent,
                              width: Width * 0.05,
                              height: Height * 0.04,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: EdgeInsets.all(Width * 0.01),
                                    shape: ContinuousRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                onPressed: () async {
                                  await _deletebill(context);
                                },
                                child: Text(
                                  "Delete",
                                  style: TextStyle(
                                      fontFamily: "sans",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: Width * 0.0065),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Width * 0.015,
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: Width * 0.015),
                              color: Colors.transparent,
                              width: Width * 0.05,
                              height: Height * 0.04,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white12,
                                    padding: EdgeInsets.all(Width * 0.01),
                                    shape: ContinuousRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                onPressed: () async {},
                                child: Text(
                                  "Preview",
                                  style: TextStyle(
                                      fontFamily: "sans",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: Width * 0.0065),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Width * 0.019,
                            ),
                            Visibility(
                              visible: downbtn,
                              child: Container(
                                color: Colors.transparent,
                                width: Width * 0.05,
                                height: Height * 0.04,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black87,
                                      padding: EdgeInsets.all(Width * 0.01),
                                      shape: ContinuousRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  onPressed: () {
                                    //
                                    PrintDocuments ob = PrintDocuments();
                                    ob.printInvoice(
                                        context, invoicecolor, invoiceno);
                                    //
                                    // printdoc(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'PDF generated successfully!')));
                                  },
                                  child: Text(
                                    "Download",
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: Width * 0.0065),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ], /////
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

  Future _getinbilldata(context) async {
    var data = await FirebaseFirestore.instance
        .collection("Bills")
        .where("bill_no", isEqualTo: invoiceno)
        .get();
    int id = data.docs[0]["kissan_id"];
    var kissandata = await FirebaseFirestore.instance
        .collection("kissan")
        .where("kissan_id", isEqualTo: id)
        .get();
    int vyaid = data.docs[0]["vyapari_id"];
    var vyaparidata = await FirebaseFirestore.instance
        .collection("vyapari")
        .where("vyapari_id", isEqualTo: vyaid)
        .get();
    setState(() {
      selectedkissan.text = data.docs[0]["kissan_name"];
      kissanid = data.docs[0]["kissan_id"].toString();
      kissanaddress = kissandata.docs[0]["address"];
      kissancity = kissandata.docs[0]["city"];
      kissanphone = kissandata.docs[0]["phone"];
      kissanstate = kissandata.docs[0]["state"];

      selectedvyapari.text = data.docs[0]["vyapari_name"];
      vyapariid = vyaparidata.docs[0]["vyapari_id"].toString();
      vyaparicompany = vyaparidata.docs[0]["company"];
      vyaparistate = vyaparidata.docs[0]["state"];
      vyaparicity = vyaparidata.docs[0]["city"];
      vyapariphone = vyaparidata.docs[0]["phone"];
      vyapariaddress = vyaparidata.docs[0]["address"];
      rascontroller.text = data.docs[0]["ras"];
      ras = data.docs[0]["ras"];
      boardcontroller.text = data.docs[0]["board"];
      board = data.docs[0]["board"];
      bhuktancontroller.text = data.docs[0]["bhuktanpk"];
      bhuktanpk = data.docs[0]["bhuktanpk"];
      motornocontroller.text = data.docs[0]["motorno"];
      motorno = data.docs[0]["motorno"];

      dropdownValue = data.docs[0]["unit"];
      if (dropdownValue == "Loose") {
        pati = true;
        danda = false;
        wastage = false;
      } else if (dropdownValue == "Carate") {
        pati = true;
        danda = true;
        wastage = false;
      } else if (dropdownValue == "Panje") {
        pati = true;
        danda = true;
        wastage = false;
      } else if (dropdownValue == "Box") {
        pati = true;
        danda = true;
        wastage = true;
      }

      villagecontroller.text = data.docs[0]["parchavillage"];
      parchavillage = data.docs[0]["parchavillage"];
      bhavcontroller.text = data.docs[0]["bhav"].toString();
      paticontroller.text = data.docs[0]["patival"].toString();
      dandacontroller.text = data.docs[0]["dandaval"].toString();
      wastagecontroller.text = data.docs[0]["wastageval"].toString();
      grosscontroller.text = data.docs[0]["gross"].toString();
      tarecontroller.text = data.docs[0]["tare"].toString();
      lungarcontroller.text = data.docs[0]["lungar"].toString();
      lungar = data.docs[0]["lungar"];

      patiwt = data.docs[0]["patiwt"];
      dandawt = data.docs[0]["dandawt"];
      wastagewt = data.docs[0]["wastagewt"];

      _patiunit = data.docs[0]["patiunit"];
      _dandaunit = data.docs[0]["dandaunit"];
      _wastageunit = data.docs[0]["wastageunit"];

      bhav = data.docs[0]["bhav"];
      gross = data.docs[0]["gross"];
      tare = data.docs[0]["tare"];
      patival = data.docs[0]["patival"];
      dandaval = data.docs[0]["dandaval"];
      wastageval = data.docs[0]["wastageval"];
      nettweight = data.docs[0]["nettweight"];
      kissanamt = data.docs[0]["kissanamt"];
      hammnali = data.docs[0]["hammnali"];
      hammalipercent = data.docs[0]["hammalipercent"];
      commission = data.docs[0]["commission"];
      commissionpercent = data.docs[0]["commissionpercent"];
      mtax = data.docs[0]["mtax"];
      mtaxpercent = data.docs[0]["mtaxpercent"];
      subtotal = data.docs[0]["subtotal"];

      grandtotal = data.docs[0]["grandtotal"];

      var date = data.docs[0]["date"];
      selectedDate = DateFormat('dd-MM-yyyy').parse(date);
    });
  }
}

Future _Getdata(search, role) async {
  try {
    QuerySnapshot<Map<String, dynamic>> data =
        await FirebaseFirestore.instance.collection("$role").get();

    List<Map<String, dynamic>> foundList = data.docs
        .where((element) => element["first_name"]
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

_addbill(context) async {
  var billdate = DateFormat('dd-MM-yyyy').format(selectedDate);

  var isDevicesConnected = await InternetConnectionChecker().hasConnection;
  var validations = _formkey.currentState!.validate();
  if (validations == true) {
    _loader(context);
    if (isDevicesConnected == true) {
      Map<String, dynamic> bill = await addobject(
          invoiceno,
          billdate,
          selectedkissan.text,
          kissanid,
          selectedvyapari.text,
          vyapariid,
          vyaparicompany,
          ras,
          board,
          motorno,
          bhuktanpk,
          parchavillage,
          bhav,
          dropdownValue,
          patival,
          dandaval,
          wastageval,
          gross,
          tare,
          lungar,
          nettweight,
          hammnali,
          commission,
          mtax,
          ot,
          tcs,
          grandtotal,
          note);
      var updatebillid = await FirebaseFirestore.instance
          .collection("Bills")
          .where("bill_no", isEqualTo: invoiceno)
          .get();

      double kahataamttoadjust = updatebillid.docs[0]["grandtotal"];

      var id = updatebillid.docs[0].id;
      await FirebaseFirestore.instance
          .collection("Bills")
          .doc(id)
          .update(bill)
          .whenComplete(() => _success(context))
          .onError((error, stackTrace) => _unsuccess(context));

      //update kahata
      Map<String, dynamic> khata =
          await _updatekhata(vyapariid, grandtotal, kahataamttoadjust);
      var updatekhatid = await FirebaseFirestore.instance
          .collection("khata")
          .where("vyapari_id", isEqualTo: int.parse(vyapariid))
          .get();
      var ids = updatekhatid.docs[0].id;
      await FirebaseFirestore.instance
          .collection("khata")
          .doc(ids)
          .update(khata)
          .onError((error, stackTrace) => _unsuccesskhata(context));
      print("update");

      ///updatrekahahta
    } else if (isDevicesConnected == false) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.wifi_off,
                    color: Colors.white,
                    size: 50,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No Internet Connection',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please check your internet connection and try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                        // primary: Colors.white,
                        // onPrimary: Colors.redAccent,
                        ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    }
  } else {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            backgroundColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Incomplete Submission',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please fill in all the required fields.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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
  }
}

Future<Map<String, dynamic>> addobject(
    invoiceno,
    date,
    selectedkissan,
    kissanid,
    selectedvyapari,
    vyapariid,
    vyaparicompany,
    ras,
    board,
    motorno,
    bhuktanpk,
    parchavillage,
    bhav,
    unit,
    patival,
    dandaval,
    wastageval,
    gross,
    tare,
    lungar,
    nettweight,
    hammnali,
    commission,
    mtax,
    ot,
    tcs,
    grandtotal,
    note) async {
  return {
    "bill_no": invoiceno,
    "date": date,
    "kissan_name": selectedkissan,
    "kissan_id": int.parse(kissanid),
    "vyapari_name": selectedvyapari,
    "vyapari_id": int.parse(vyapariid),
    "vyapari_company": vyaparicompany,
    "vyapari_address": vyapariaddress,
    "ras": ras,
    "board": board,
    "motorno": motorno,
    "bhuktanpk": bhuktanpk,
    "parchavillage": parchavillage,
    "bhav": bhav,
    "unit": unit,
    "patival": patival,
    "patiunit": _patiunit,
    "patiwt": patiwt,
    "dandaval": dandaval,
    "dandaunit": _dandaunit,
    "dandawt": dandawt,
    "wastageval": wastageval,
    "wastageunit": _wastageunit,
    "wastagewt": wastagewt,
    "gross": gross,
    "tare": tare,
    "lungar": lungar,
    "nettweight": nettweight,
    "kissanamt": kissanamt,
    "hammnali": hammnali,
    "hammalipercent": hammalipercent,
    "commission": commission,
    "commissionpercent": commissionpercent,
    "mtax": mtax,
    "mtaxpercent": mtaxpercent,
    "ot": ot,
    "tcs": tcs,
    "subtotal": subtotal,
    "grandtotal": grandtotal,
    "adminname": "admin1",
    "note": note,
  };
}

_success(context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50,
              ),
              const SizedBox(height: 20),
              const Text(
                'Transaction Complete',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your Bill has been successfully added.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop();
                  // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
}

_unsuccess(context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 50,
              ),
              const SizedBox(height: 20),
              const Text(
                'Transaction Failed',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Oops! Something went wrong during the transaction. Please try again later.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                    // primary: Colors.white,
                    // onPrimary: Colors.redAccent,
                    ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        );
      });
}

_loader(context) {
  showDialog(
      context: context,
      builder: (context) {
        return Center(
            child: LoadingAnimationWidget.discreteCircle(
                color: Colors.red,
                size: 50,
                secondRingColor: Colors.white,
                thirdRingColor: Colors.blueAccent));
      });
}

Future _deletebill(context) async {
  var isDevicesConnected = await InternetConnectionChecker().hasConnection;
  if (isDevicesConnected == true) {
    _loader(context);
    var updatebillid = await FirebaseFirestore.instance
        .collection("Bills")
        .where("bill_no", isEqualTo: invoiceno)
        .get();
    var id = updatebillid.docs[0].id;
    await FirebaseFirestore.instance
        .collection("Bills")
        .doc(id)
        .delete()
        .whenComplete(() => _delsuccess(context))
        .onError((error, stackTrace) => _unsuccess(context));
  } else {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.wifi_off,
                  color: Colors.white,
                  size: 50,
                ),
                const SizedBox(height: 20),
                const Text(
                  'No Internet Connection',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please check your internet connection and try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                      // primary: Colors.white,
                      // onPrimary: Colors.redAccent,
                      ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

_delsuccess(context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50,
              ),
              const SizedBox(height: 20),
              const Text(
                'Transaction Complete',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your Bill has been successfully Deleted.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Mainscreen()));
                  // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
}

_caratecalc() {
  double mainwt = gross - tare;
  if (_patiunit == "Percent") {
    patiwt = mainwt * patival / 100;
  } else {
    patiwt = patival;
  }

  if (_dandaunit == "Percent") {
    dandawt = mainwt * dandaval / 100;
  } else {
    dandawt = dandaval;
  }

  nettweight = ((mainwt - patiwt + dandawt) / 100).round().toDouble();
  kissanamt = (nettweight * bhav).round().toDouble();
  hammnali =
      (kissanamt * (double.parse(hammalipercent) / 100)).round().toDouble();
  commission =
      (kissanamt * (double.parse(commissionpercent) / 100)).round().toDouble();
  mtax = (kissanamt * (double.parse(mtaxpercent) / 100)).round().toDouble();
  subtotal = (kissanamt + hammnali + commission + mtax).round().toDouble();
  grandtotal = subtotal + ot + tcs;
}

_loosecalc() {
  double mainwt = gross - tare;
  if (_patiunit == "Percent") {
    patiwt = mainwt * (patival / 100);
  } else {
    patiwt = patival;
  }

  nettweight = ((mainwt - patiwt) / 100).round().toDouble();
  kissanamt = (nettweight * bhav).round().toDouble();
  hammnali =
      (kissanamt * (double.parse(hammalipercent) / 100)).round().toDouble();
  commission =
      (kissanamt * (double.parse(commissionpercent) / 100)).round().toDouble();
  mtax = (kissanamt * (double.parse(mtaxpercent) / 100)).round().toDouble();
  subtotal = (kissanamt + hammnali + commission + mtax).round().toDouble();
  grandtotal = subtotal + ot + tcs;
}

_boxcalc() {
  double mainwt = gross - tare;
  if (_patiunit == "Percent") {
    patiwt = mainwt * patival / 100;
  } else {
    patiwt = patival;
  }

  if (_dandaunit == "Percent") {
    dandawt = mainwt * dandaval / 100;
  } else {
    dandawt = dandaval;
  }

  if (_wastageunit == "Percent") {
    wastagewt = mainwt * wastageval / 100;
  } else {
    wastagewt = wastageval;
  }

  nettweight =
      ((mainwt - patiwt + dandawt + wastagewt) / 100).round().toDouble();
  kissanamt = (nettweight * bhav).round().toDouble();
  hammnali =
      (kissanamt * (double.parse(hammalipercent) / 100)).round().toDouble();
  commission =
      (kissanamt * (double.parse(commissionpercent) / 100)).round().toDouble();
  mtax = (kissanamt * (double.parse(mtaxpercent) / 100)).round().toDouble();
  subtotal = (kissanamt + hammnali + commission + mtax).round().toDouble();

  grandtotal = subtotal + ot + tcs;
}

Future<Map<String, dynamic>> _updatekhata(
    vyapariid, grandtotal, kahataamttoadjust) async {
  var data = await FirebaseFirestore.instance
      .collection("khata")
      .where("vyapari_id", isEqualTo: int.parse(vyapariid))
      .get();

  double amt = data.docs[0]["Total"] - kahataamttoadjust;
  print(amt);
  return {
    "khata_id": data.docs[0]["khata_id"],
    "vyapari_id": data.docs[0]["vyapari_id"],
    "name": data.docs[0]["name"],
    "phone": data.docs[0]["phone"],
    "Total": amt + grandtotal,
    "Due": 0,
    "Recieved": 0,
  };
}

_unsuccesskhata(context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 50,
              ),
              const SizedBox(height: 20),
              const Text(
                ' Khata Failed',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Oops! Something went wrong during the Khata. Please contact.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                    // primary: Colors.white,
                    // onPrimary: Colors.redAccent,
                    ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        );
      });
}
