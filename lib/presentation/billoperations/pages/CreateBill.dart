import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:form_validator/form_validator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:kelawin/presentation/multikissanbill/page/Multi_kissan.dart';
import 'package:kelawin/presentation/multikissanbill/provider/multi_kissan_pro.dart';
import 'package:kelawin/presentation/multikissanbill/widget/grandtotal_multikissan.dart';
import 'package:kelawin/presentation/multikissanbill/widget/wtdiff_table.dart';
import 'package:kelawin/utils/apputils.dart';
import 'package:kelawin/viewmodel/calcWidgetVisibilty/grandtotalvisible_provider.dart';
import 'package:provider/provider.dart';

import '../../../viewmodel/bill_viewmodel/bill_khata_adding_viewmodel.dart';
import '../../../viewmodel/multikissanbillcalc/multi_grandtotal.dart';

final _formkey = GlobalKey<FormState>();
int currentindex = 0;
int kissanadd_index = 1;
int invoiceno = 0;
DateTime selectedDate = DateTime.now();
// late DateTime selectedDate = now.format("dd-MM-yyy").toString();

TextEditingController selectedvyapari = TextEditingController();
TextEditingController selectedkissan = TextEditingController();

List<dynamic> multi_kissan = [];

int vyapariid = 0;
String vyaparicompany = "";
String vyaparicity = "";
String vyaparistate = "";
String vyapariaddress = "";
String vyapariphone = "";
String kissanphone = "";
int kissanid = 0;
String kissanstate = "";
String kissancity = "";
String kissanaddress = "";

TextEditingController rasController = TextEditingController();
//multicalc
TextEditingController multiGrossController = TextEditingController();
TextEditingController multiTareController = TextEditingController();
TextEditingController multiAreaWtController = TextEditingController();
TextEditingController multiWtDiffController = TextEditingController();
//multicalc
String board = "";
String motorno = "";
String bhuktanpk = "";

double patival = 7.5;
double patiwt = 0;
double dandawt = 0;
double wastagewt = 0;

double dandaval = 6;
double wastageval = 6;
String dropdownValue = "Loose";
String _patiunit = "Percent";
String _dandaunit = "Percent";
String _wastageunit = "KG";
String invoicecolor = "Red";

String parchavillage = "";
double bhav = 0;
double gross = 0;
double tare = 0;
double lungar = 0;

double nettweight = 0;
double kissanamt = 0;
double hammali = 0;
double commission = 0;
double mtax = 0;
double subtotal = 0;
int ot = 40;
double tcs = 0;
double grandtotal = 0;

String note = "";

int hammalipercent = 20;
int commissionpercent = 15;
int mtaxpercent = 1;
int tcspercent = 0;

class CreateBill extends StatefulWidget {
  const CreateBill({super.key});

  @override
  State<CreateBill> createState() => _CreateBillState();
}

class _CreateBillState extends State<CreateBill> {
  bool pati = true;
  bool danda = false;
  bool wastage = false;
  bool downbtn = false;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    selectedDate = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Call your function here
      var comingnumber = await _getinvoiceno();
      setState(() {
        invoiceno = comingnumber;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;

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
                        Navigator.of(context).pop();
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
                    "Fill out the invoice details below.",
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
                                              selectedkissan.text = val["name"];
                                              kissanid = val["kissan_id"];
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
                                                    suggestion["name"]
                                                        .toString()
                                                        .toUpperCase()[0],
                                                    style: const TextStyle(
                                                        fontFamily: "sans",
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                title: Text(suggestion["name"],
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
                                                kissanid.toString(),
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
                                                    val["name"];
                                                vyapariid = val["vyapari_id"];
                                                vyaparicompany = val["company"];
                                                vyapariaddress = val["address"];
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
                                                      suggestion["name"]
                                                          .toString()
                                                          .toUpperCase()[0],
                                                      style: const TextStyle(
                                                          fontFamily: "sans",
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  title: Text(
                                                      suggestion["name"],
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
                                  validator: ValidationBuilder()
                                      .minLength(1)
                                      .maxLength(45)
                                      .build(),
                                  controller: rasController,
                                  keyboardType: TextInputType.number,
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
                              width: Width * 0.8, //working on this container

                              margin: EdgeInsets.only(top: Width * 0.02),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: Width * 0.025),
                                        child: Text(
                                          "Parcha details",
                                          style: TextStyle(
                                              fontFamily: "sans",
                                              fontSize: Width * 0.01,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width: Width * 0.25,
                                      ),
                                      SizedBox(
                                        height: Height * 0.04,
                                        width: Width * 0.045,
                                        child:
                                            Consumer<GrandtotalVisibleProvider>(
                                          builder: (context, value, child) =>
                                              Switch(
                                                  activeColor: const Color(
                                                      0xFF2196F3), // Blue for the knob
                                                  activeTrackColor: const Color(
                                                      0xFFBBDEFB), // Light Blue for the track
                                                  value: value.issinglekissan,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      val
                                                          ? value.ismultikissan =
                                                              false
                                                          : value.ismultikissan =
                                                              true;
                                                      value.issinglekissan =
                                                          val;
                                                    });
                                                  }),
                                        ),
                                      ),
                                      Container(
                                        height: Height * 0.04,
                                        width: Width * 0.07,
                                        margin:
                                            EdgeInsets.only(left: Width * 0.05),
                                        child: Text(
                                          "Multiple kissan",
                                          style: TextStyle(
                                              fontFamily: "sans",
                                              fontSize: Width * 0.01,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width: Width * 0.2,
                                      ),
                                      SizedBox(
                                        height: Height * 0.04,
                                        width: Width * 0.045,
                                        child:
                                            Consumer<GrandtotalVisibleProvider>(
                                          builder: (context, value, child) =>
                                              Switch(
                                                  activeColor: const Color(
                                                      0xFF2196F3), // Blue for the knob
                                                  activeTrackColor:
                                                      const Color(0xFFBBDEFB),
                                                  value: value.ismultikissan,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      val
                                                          ? value.issinglekissan =
                                                              false
                                                          : value.issinglekissan =
                                                              true;
                                                      value.ismultikissan = val;
                                                    });
                                                  }),
                                        ),
                                      ),
                                      Consumer<GrandtotalVisibleProvider>(
                                        builder: (context, value, child) =>
                                            Visibility(
                                          visible: value.ismultikissan,
                                          child: SizedBox(
                                            child: Consumer<MultiKissanPro>(
                                              builder: (context, value,
                                                      child) =>
                                                  OutlinedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Colors.blue,
                                                              shape:
                                                                  const CircleBorder()),
                                                      onPressed: () {
                                                        setState(() {
                                                          value.addintolist();
                                                          value.scrollToEnd(
                                                              _scrollController);
                                                          kissanadd_index++;
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            content: Text(
                                                              "Added kissan",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "sans",
                                                                  fontSize:
                                                                      Width *
                                                                          0.01,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ));
                                                        });
                                                      },
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                        ),
                                                      )),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
                                        child:
                                            Consumer<GrandtotalVisibleProvider>(
                                          builder: (context, value, child) =>
                                              value.ismultikissan
                                                  ? const Center(
                                                      child: Text(
                                                      "MultiKissan Bill Is In Use!",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ))
                                                  : Visibility(
                                                      visible:
                                                          value.issinglekissan,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Container(
                                                                height: Height *
                                                                    0.1,
                                                                width: Width *
                                                                    0.08,
                                                                color: Colors
                                                                    .white,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "Village",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "sans",
                                                                          fontSize: Width *
                                                                              0.008,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    SizedBox(
                                                                      height: Height *
                                                                          0.005,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          Height *
                                                                              0.05,
                                                                      width: Width *
                                                                          0.07,
                                                                      child:
                                                                          TextFormField(
                                                                        validator: ValidationBuilder()
                                                                            .minLength(1)
                                                                            .maxLength(45)
                                                                            .build(),
                                                                        onChanged:
                                                                            (val) {
                                                                          parchavillage = val
                                                                              .toString()
                                                                              .toLowerCase();
                                                                        },
                                                                        cursorColor:
                                                                            Colors.black87,
                                                                        decoration: InputDecoration(
                                                                            contentPadding: EdgeInsets.all(Width * 0.005),
                                                                            hoverColor: Colors.grey.shade300,
                                                                            hintText: "Village",
                                                                            hintStyle: TextStyle(
                                                                              fontFamily: "sans",
                                                                              fontSize: Width * 0.01,
                                                                            ),
                                                                            hintFadeDuration: const Duration(seconds: 1),
                                                                            prefixIcon: Icon(
                                                                              Icons.numbers,
                                                                              size: Width * 0.015,
                                                                            ),
                                                                            fillColor: const Color.fromARGB(255, 229, 241, 248),
                                                                            filled: true,
                                                                            enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey)),
                                                                            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black87)),
                                                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                height: Height *
                                                                    0.1,
                                                                width: Width *
                                                                    0.08,
                                                                color: Colors
                                                                    .white,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "Bhav",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "sans",
                                                                          fontSize: Width *
                                                                              0.008,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    SizedBox(
                                                                      height: Height *
                                                                          0.005,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          Height *
                                                                              0.05,
                                                                      width: Width *
                                                                          0.07,
                                                                      child:
                                                                          TextFormField(
                                                                        validator: ValidationBuilder()
                                                                            .minLength(1)
                                                                            .maxLength(45)
                                                                            .build(),
                                                                        keyboardType:
                                                                            TextInputType.number,
                                                                        onChanged:
                                                                            (val) {
                                                                          setState(
                                                                              () {
                                                                            bhav =
                                                                                double.parse(val);
                                                                          });
                                                                        },
                                                                        cursorColor:
                                                                            Colors.black87,
                                                                        decoration: InputDecoration(
                                                                            contentPadding: EdgeInsets.all(Width * 0.005),
                                                                            hoverColor: Colors.grey.shade300,
                                                                            hintText: "Bhav",
                                                                            hintStyle: TextStyle(
                                                                              fontFamily: "sans",
                                                                              fontSize: Width * 0.01,
                                                                            ),
                                                                            hintFadeDuration: const Duration(seconds: 1),
                                                                            prefixIcon: Icon(
                                                                              Icons.numbers,
                                                                              size: Width * 0.015,
                                                                            ),
                                                                            fillColor: const Color.fromARGB(255, 229, 241, 248),
                                                                            filled: true,
                                                                            enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey)),
                                                                            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black87)),
                                                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                height: Height *
                                                                    0.1,
                                                                width: Width *
                                                                    0.08,
                                                                color: Colors
                                                                    .white,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "Lungar",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "sans",
                                                                          fontSize: Width *
                                                                              0.008,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    SizedBox(
                                                                      height: Height *
                                                                          0.005,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          Height *
                                                                              0.05,
                                                                      width: Width *
                                                                          0.07,
                                                                      child:
                                                                          TextFormField(
                                                                        validator: ValidationBuilder()
                                                                            .minLength(1)
                                                                            .maxLength(45)
                                                                            .build(),
                                                                        keyboardType:
                                                                            TextInputType.number,
                                                                        onChanged:
                                                                            (val) {
                                                                          setState(
                                                                              () {
                                                                            lungar =
                                                                                double.parse(val);
                                                                          });
                                                                        },
                                                                        cursorColor:
                                                                            Colors.black87,
                                                                        decoration: InputDecoration(
                                                                            contentPadding: EdgeInsets.all(Width * 0.005),
                                                                            hoverColor: Colors.grey.shade300,
                                                                            hintText: "Lungar",
                                                                            hintStyle: TextStyle(
                                                                              fontFamily: "sans",
                                                                              fontSize: Width * 0.01,
                                                                            ),
                                                                            hintFadeDuration: const Duration(seconds: 1),
                                                                            prefixIcon: Icon(
                                                                              Icons.numbers,
                                                                              size: Width * 0.015,
                                                                            ),
                                                                            fillColor: const Color.fromARGB(255, 229, 241, 248),
                                                                            filled: true,
                                                                            enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey)),
                                                                            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black87)),
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
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Container(
                                                                height: Height *
                                                                    0.1,
                                                                width: Width *
                                                                    0.08,
                                                                color: Colors
                                                                    .white,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "Gross Wt(kg)",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "sans",
                                                                          fontSize: Width *
                                                                              0.008,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    SizedBox(
                                                                      height: Height *
                                                                          0.005,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          Height *
                                                                              0.05,
                                                                      width: Width *
                                                                          0.07,
                                                                      child:
                                                                          TextFormField(
                                                                        validator: ValidationBuilder()
                                                                            .minLength(1)
                                                                            .maxLength(45)
                                                                            .build(),
                                                                        keyboardType:
                                                                            TextInputType.number,
                                                                        onChanged:
                                                                            (val) {
                                                                          setState(
                                                                              () {
                                                                            gross =
                                                                                double.parse(val.toString());
                                                                          });
                                                                        },
                                                                        cursorColor:
                                                                            Colors.black87,
                                                                        decoration: InputDecoration(
                                                                            contentPadding: EdgeInsets.all(Width * 0.005),
                                                                            hoverColor: Colors.grey.shade300,
                                                                            hintText: "Gross",
                                                                            hintStyle: TextStyle(
                                                                              fontFamily: "sans",
                                                                              fontSize: Width * 0.01,
                                                                            ),
                                                                            hintFadeDuration: const Duration(seconds: 1),
                                                                            prefixIcon: Icon(
                                                                              Icons.numbers,
                                                                              size: Width * 0.015,
                                                                            ),
                                                                            fillColor: const Color.fromARGB(255, 229, 241, 248),
                                                                            filled: true,
                                                                            enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey)),
                                                                            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black87)),
                                                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                height: Height *
                                                                    0.1,
                                                                width: Width *
                                                                    0.08,
                                                                color: Colors
                                                                    .white,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "Tare Wt(kg)",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "sans",
                                                                          fontSize: Width *
                                                                              0.008,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    SizedBox(
                                                                      height: Height *
                                                                          0.005,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          Height *
                                                                              0.05,
                                                                      width: Width *
                                                                          0.07,
                                                                      child:
                                                                          TextFormField(
                                                                        validator: ValidationBuilder()
                                                                            .minLength(1)
                                                                            .maxLength(45)
                                                                            .build(),
                                                                        keyboardType:
                                                                            TextInputType.number,
                                                                        onChanged:
                                                                            (val) {
                                                                          setState(
                                                                              () {
                                                                            tare =
                                                                                double.parse(val);
                                                                          });
                                                                        },
                                                                        cursorColor:
                                                                            Colors.black87,
                                                                        decoration: InputDecoration(
                                                                            contentPadding: EdgeInsets.all(Width * 0.005),
                                                                            hoverColor: Colors.grey.shade300,
                                                                            hintText: "Tare",
                                                                            hintStyle: TextStyle(
                                                                              fontFamily: "sans",
                                                                              fontSize: Width * 0.01,
                                                                            ),
                                                                            hintFadeDuration: const Duration(seconds: 1),
                                                                            prefixIcon: Icon(
                                                                              Icons.numbers,
                                                                              size: Width * 0.015,
                                                                            ),
                                                                            fillColor: const Color.fromARGB(255, 229, 241, 248),
                                                                            filled: true,
                                                                            enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey)),
                                                                            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black87)),
                                                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                height: Height *
                                                                    0.1,
                                                                width: Width *
                                                                    0.08,
                                                                color: Colors
                                                                    .white,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "Units",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "sans",
                                                                          fontSize: Width *
                                                                              0.008,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    SizedBox(
                                                                      height: Height *
                                                                          0.005,
                                                                    ),
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            229,
                                                                            241,
                                                                            248),
                                                                        borderRadius:
                                                                            BorderRadius.circular(5),
                                                                      ),
                                                                      height:
                                                                          Height *
                                                                              0.05,
                                                                      width: Width *
                                                                          0.07,
                                                                      child:
                                                                          DropdownButton(
                                                                        padding:
                                                                            EdgeInsets.all(Width *
                                                                                0.0045),
                                                                        iconSize:
                                                                            Width *
                                                                                0.01,
                                                                        underline:
                                                                            const Text(""),
                                                                        isExpanded:
                                                                            true,
                                                                        borderRadius:
                                                                            BorderRadius.circular(5),
                                                                        dropdownColor:
                                                                            Colors.white,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "sans",
                                                                            fontSize: Width *
                                                                                0.01,
                                                                            color:
                                                                                Colors.black87),
                                                                        value:
                                                                            dropdownValue,
                                                                        onChanged:
                                                                            (String?
                                                                                newValue) {
                                                                          setState(
                                                                              () {
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
                                                                            value:
                                                                                value,
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
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  width: Width *
                                                                      0.018,
                                                                ),
                                                                Container(
                                                                  height:
                                                                      Height *
                                                                          0.1,
                                                                  width: Width *
                                                                      0.08,
                                                                  color: Colors
                                                                      .white,
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
                                                                            fontSize: Width *
                                                                                0.008,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      SizedBox(
                                                                        height: Height *
                                                                            0.005,
                                                                      ),
                                                                      SizedBox(
                                                                        height: Height *
                                                                            0.05,
                                                                        width: Width *
                                                                            0.07,
                                                                        child:
                                                                            TextFormField(
                                                                          initialValue:
                                                                              patival.toString(),
                                                                          validator: ValidationBuilder()
                                                                              .minLength(1)
                                                                              .maxLength(45)
                                                                              .build(),
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                          onChanged:
                                                                              (val) {
                                                                            setState(() {
                                                                              patival = double.parse(val);
                                                                            });
                                                                          },
                                                                          cursorColor:
                                                                              Colors.black87,
                                                                          decoration: InputDecoration(
                                                                              contentPadding: EdgeInsets.all(Width * 0.005),
                                                                              hoverColor: Colors.grey.shade300,
                                                                              hintText: "Pati",
                                                                              hintStyle: TextStyle(
                                                                                fontFamily: "sans",
                                                                                fontSize: Width * 0.01,
                                                                              ),
                                                                              hintFadeDuration: const Duration(seconds: 1),
                                                                              prefixIcon: Icon(
                                                                                Icons.numbers,
                                                                                size: Width * 0.015,
                                                                              ),
                                                                              fillColor: const Color.fromARGB(255, 229, 241, 248),
                                                                              filled: true,
                                                                              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey)),
                                                                              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black87)),
                                                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: Width *
                                                                      0.037,
                                                                ),
                                                                Container(
                                                                  height:
                                                                      Height *
                                                                          0.1,
                                                                  width: Width *
                                                                      0.08,
                                                                  color: Colors
                                                                      .white,
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
                                                                            fontSize: Width *
                                                                                0.008,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      SizedBox(
                                                                        height: Height *
                                                                            0.005,
                                                                      ),
                                                                      Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              229,
                                                                              241,
                                                                              248),
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                        ),
                                                                        height: Height *
                                                                            0.05,
                                                                        width: Width *
                                                                            0.07,
                                                                        child:
                                                                            DropdownButton(
                                                                          padding:
                                                                              EdgeInsets.all(Width * 0.0045),
                                                                          iconSize:
                                                                              Width * 0.01,
                                                                          underline:
                                                                              const Text(""),
                                                                          isExpanded:
                                                                              true,
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                          dropdownColor:
                                                                              Colors.white,
                                                                          style: TextStyle(
                                                                              fontFamily: "sans",
                                                                              fontSize: Width * 0.01,
                                                                              color: Colors.black87),
                                                                          value:
                                                                              _patiunit,
                                                                          onChanged:
                                                                              (String? newValue) {
                                                                            setState(() {
                                                                              _patiunit = newValue!;
                                                                            });
                                                                          },
                                                                          items:
                                                                              <String>[
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
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: Width *
                                                                      0.037,
                                                                ),
                                                                Container(
                                                                  height:
                                                                      Height *
                                                                          0.1,
                                                                  width: Width *
                                                                      0.08,
                                                                  color: Colors
                                                                      .white,
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
                                                                            fontSize: Width *
                                                                                0.008,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      SizedBox(
                                                                        height: Height *
                                                                            0.005,
                                                                      ),
                                                                      Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              229,
                                                                              241,
                                                                              248),
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                        ),
                                                                        height: Height *
                                                                            0.05,
                                                                        width: Width *
                                                                            0.07,
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.all(Width * 0.004),
                                                                          height:
                                                                              Height * 0.05,
                                                                          width:
                                                                              Width * 0.07,
                                                                          decoration: BoxDecoration(
                                                                              color: const Color(0xffd5ecfa),
                                                                              border: Border.all(width: 1, color: Colors.grey),
                                                                              borderRadius: BorderRadius.circular(5)),
                                                                          child: Text(
                                                                              "$patiwt",
                                                                              style: TextStyle(fontFamily: "sans", fontWeight: FontWeight.bold, color: Colors.black87, fontSize: Width * 0.008)),
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
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  width: Width *
                                                                      0.018,
                                                                ),
                                                                Container(
                                                                  height:
                                                                      Height *
                                                                          0.1,
                                                                  width: Width *
                                                                      0.08,
                                                                  color: Colors
                                                                      .white,
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
                                                                            fontSize: Width *
                                                                                0.008,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      SizedBox(
                                                                        height: Height *
                                                                            0.005,
                                                                      ),
                                                                      SizedBox(
                                                                        height: Height *
                                                                            0.05,
                                                                        width: Width *
                                                                            0.07,
                                                                        child:
                                                                            TextFormField(
                                                                          initialValue:
                                                                              dandaval.toString(),
                                                                          validator: ValidationBuilder()
                                                                              .minLength(1)
                                                                              .maxLength(45)
                                                                              .build(),
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                          onChanged:
                                                                              (val) {
                                                                            setState(() {
                                                                              dandaval = double.parse(val);
                                                                            });
                                                                          },
                                                                          cursorColor:
                                                                              Colors.black87,
                                                                          decoration: InputDecoration(
                                                                              contentPadding: EdgeInsets.all(Width * 0.005),
                                                                              hoverColor: Colors.grey.shade300,
                                                                              hintText: "Danda",
                                                                              hintStyle: TextStyle(
                                                                                fontFamily: "sans",
                                                                                fontSize: Width * 0.01,
                                                                              ),
                                                                              hintFadeDuration: const Duration(seconds: 1),
                                                                              prefixIcon: Icon(
                                                                                Icons.numbers,
                                                                                size: Width * 0.015,
                                                                              ),
                                                                              fillColor: const Color.fromARGB(255, 229, 241, 248),
                                                                              filled: true,
                                                                              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey)),
                                                                              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black87)),
                                                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: Width *
                                                                      0.037,
                                                                ),
                                                                Container(
                                                                  height:
                                                                      Height *
                                                                          0.1,
                                                                  width: Width *
                                                                      0.08,
                                                                  color: Colors
                                                                      .white,
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
                                                                            fontSize: Width *
                                                                                0.008,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      SizedBox(
                                                                        height: Height *
                                                                            0.005,
                                                                      ),
                                                                      Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              229,
                                                                              241,
                                                                              248),
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                        ),
                                                                        height: Height *
                                                                            0.05,
                                                                        width: Width *
                                                                            0.07,
                                                                        child:
                                                                            DropdownButton(
                                                                          padding:
                                                                              EdgeInsets.all(Width * 0.0045),
                                                                          iconSize:
                                                                              Width * 0.01,
                                                                          underline:
                                                                              const Text(""),
                                                                          isExpanded:
                                                                              true,
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                          dropdownColor:
                                                                              Colors.white,
                                                                          style: TextStyle(
                                                                              fontFamily: "sans",
                                                                              fontSize: Width * 0.01,
                                                                              color: Colors.black87),
                                                                          value:
                                                                              _dandaunit,
                                                                          onChanged:
                                                                              (String? newValue) {
                                                                            setState(() {
                                                                              _dandaunit = newValue!;
                                                                            });
                                                                          },
                                                                          items:
                                                                              <String>[
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
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: Width *
                                                                      0.037,
                                                                ),
                                                                Container(
                                                                  height:
                                                                      Height *
                                                                          0.1,
                                                                  width: Width *
                                                                      0.08,
                                                                  color: Colors
                                                                      .white,
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
                                                                            fontSize: Width *
                                                                                0.008,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      SizedBox(
                                                                        height: Height *
                                                                            0.005,
                                                                      ),
                                                                      Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              229,
                                                                              241,
                                                                              248),
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                        ),
                                                                        height: Height *
                                                                            0.05,
                                                                        width: Width *
                                                                            0.07,
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.all(Width * 0.004),
                                                                          height:
                                                                              Height * 0.05,
                                                                          width:
                                                                              Width * 0.07,
                                                                          decoration: BoxDecoration(
                                                                              color: const Color(0xffd5ecfa),
                                                                              border: Border.all(width: 1, color: Colors.grey),
                                                                              borderRadius: BorderRadius.circular(5)),
                                                                          child:
                                                                              Text(
                                                                            dandawt.toString(),
                                                                            style: TextStyle(
                                                                                fontFamily: "sans",
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black87,
                                                                                fontSize: Width * 0.008),
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
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  width: Width *
                                                                      0.018,
                                                                ),
                                                                Container(
                                                                  height:
                                                                      Height *
                                                                          0.1,
                                                                  width: Width *
                                                                      0.08,
                                                                  color: Colors
                                                                      .white,
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
                                                                            fontSize: Width *
                                                                                0.008,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      SizedBox(
                                                                        height: Height *
                                                                            0.005,
                                                                      ),
                                                                      SizedBox(
                                                                        height: Height *
                                                                            0.05,
                                                                        width: Width *
                                                                            0.07,
                                                                        child:
                                                                            TextFormField(
                                                                          initialValue:
                                                                              wastageval.toString(),
                                                                          validator: ValidationBuilder()
                                                                              .minLength(1)
                                                                              .maxLength(45)
                                                                              .build(),
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                          onChanged:
                                                                              (val) {
                                                                            setState(() {
                                                                              wastageval = double.parse(val);
                                                                            });
                                                                          },
                                                                          cursorColor:
                                                                              Colors.black87,
                                                                          decoration: InputDecoration(
                                                                              contentPadding: EdgeInsets.all(Width * 0.005),
                                                                              hoverColor: Colors.grey.shade300,
                                                                              hintText: "Wastage",
                                                                              hintStyle: TextStyle(
                                                                                fontFamily: "sans",
                                                                                fontSize: Width * 0.01,
                                                                              ),
                                                                              hintFadeDuration: const Duration(seconds: 1),
                                                                              prefixIcon: Icon(
                                                                                Icons.numbers,
                                                                                size: Width * 0.015,
                                                                              ),
                                                                              fillColor: const Color.fromARGB(255, 229, 241, 248),
                                                                              filled: true,
                                                                              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey)),
                                                                              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black87)),
                                                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: Width *
                                                                      0.037,
                                                                ),
                                                                Container(
                                                                  height:
                                                                      Height *
                                                                          0.1,
                                                                  width: Width *
                                                                      0.08,
                                                                  color: Colors
                                                                      .white,
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
                                                                            fontSize: Width *
                                                                                0.008,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      SizedBox(
                                                                        height: Height *
                                                                            0.005,
                                                                      ),
                                                                      Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              229,
                                                                              241,
                                                                              248),
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                        ),
                                                                        height: Height *
                                                                            0.05,
                                                                        width: Width *
                                                                            0.07,
                                                                        child:
                                                                            DropdownButton(
                                                                          padding:
                                                                              EdgeInsets.all(Width * 0.0045),
                                                                          iconSize:
                                                                              Width * 0.01,
                                                                          underline:
                                                                              const Text(""),
                                                                          isExpanded:
                                                                              true,
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                          dropdownColor:
                                                                              Colors.white,
                                                                          style: TextStyle(
                                                                              fontFamily: "sans",
                                                                              fontSize: Width * 0.01,
                                                                              color: Colors.black87),
                                                                          value:
                                                                              _wastageunit,
                                                                          onChanged:
                                                                              (String? newValue) {
                                                                            setState(() {
                                                                              _wastageunit = newValue!;
                                                                            });
                                                                          },
                                                                          items:
                                                                              <String>[
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
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: Width *
                                                                      0.037,
                                                                ),
                                                                Container(
                                                                  height:
                                                                      Height *
                                                                          0.1,
                                                                  width: Width *
                                                                      0.08,
                                                                  color: Colors
                                                                      .white,
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
                                                                            fontSize: Width *
                                                                                0.008,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      SizedBox(
                                                                        height: Height *
                                                                            0.005,
                                                                      ),
                                                                      Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              229,
                                                                              241,
                                                                              248),
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                        ),
                                                                        height: Height *
                                                                            0.05,
                                                                        width: Width *
                                                                            0.07,
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.all(Width * 0.004),
                                                                          height:
                                                                              Height * 0.05,
                                                                          width:
                                                                              Width * 0.07,
                                                                          decoration: BoxDecoration(
                                                                              color: const Color(0xffd5ecfa),
                                                                              border: Border.all(width: 1, color: Colors.grey),
                                                                              borderRadius: BorderRadius.circular(5)),
                                                                          child:
                                                                              Text(
                                                                            wastagewt.toString(),
                                                                            style: TextStyle(
                                                                                fontFamily: "sans",
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black87,
                                                                                fontSize: Width * 0.008),
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
                                                            child:
                                                                ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .red),
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
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
                                                                          fontFamily:
                                                                              "sans",
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              Width * 0.008),
                                                                    )),
                                                          )
                                                        ], //this
                                                      ),
                                                    ),
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
                                        child:
                                            Consumer<GrandtotalVisibleProvider>(
                                          builder: (context, value, child) =>
                                              value.issinglekissan
                                                  ? const Center(
                                                      child: Text(
                                                      "SingleKissan Bill Is In Use!",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ))
                                                  : Visibility(
                                                      visible:
                                                          value.ismultikissan,
                                                      child: MultiKissan(
                                                          controller:
                                                              _scrollController),
                                                    ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Consumer<GrandtotalVisibleProvider>(
                                      builder: (context, value, child) =>
                                          Visibility(
                                        visible: value.ismultikissan,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            const SizedBox(
                                              width: 750,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Gross(kg)",
                                                  style: TextStyle(
                                                      fontFamily: "sans",
                                                      fontSize: Width * 0.008,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: Height * 0.005,
                                                ),
                                                SizedBox(
                                                  height: 100,
                                                  width: 120,
                                                  child: TextFormField(
                                                    controller:
                                                        multiGrossController,
                                                    validator:
                                                        ValidationBuilder()
                                                            .minLength(1)
                                                            .maxLength(45)
                                                            .build(),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    onChanged: (val) {},
                                                    cursorColor: Colors.black87,
                                                    decoration: InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.all(
                                                                Width * 0.005),
                                                        hoverColor: Colors
                                                            .grey.shade300,
                                                        hintText: "gross",
                                                        hintStyle: TextStyle(
                                                          fontFamily: "sans",
                                                          fontSize:
                                                              Width * 0.01,
                                                        ),
                                                        hintFadeDuration:
                                                            const Duration(
                                                                seconds: 1),
                                                        prefixIcon: Icon(
                                                          Icons.numbers,
                                                          size: Width * 0.015,
                                                        ),
                                                        fillColor:
                                                            const Color.fromARGB(
                                                                255, 229, 241, 248),
                                                        filled: true,
                                                        enabledBorder:
                                                            const OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .grey)),
                                                        focusedBorder:
                                                            const OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        width: 1,
                                                                        color: Colors.black87)),
                                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Tare(kg)",
                                                  style: TextStyle(
                                                      fontFamily: "sans",
                                                      fontSize: Width * 0.008,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: Height * 0.005,
                                                ),
                                                SizedBox(
                                                  height: 100,
                                                  width: 120,
                                                  child: TextFormField(
                                                    controller:
                                                        multiTareController,
                                                    validator:
                                                        ValidationBuilder()
                                                            .minLength(1)
                                                            .maxLength(45)
                                                            .build(),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    onChanged: (val) {},
                                                    cursorColor: Colors.black87,
                                                    decoration: InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.all(
                                                                Width * 0.005),
                                                        hoverColor: Colors
                                                            .grey.shade300,
                                                        hintText: "Tare",
                                                        hintStyle: TextStyle(
                                                          fontFamily: "sans",
                                                          fontSize:
                                                              Width * 0.01,
                                                        ),
                                                        hintFadeDuration:
                                                            const Duration(
                                                                seconds: 1),
                                                        prefixIcon: Icon(
                                                          Icons.numbers,
                                                          size: Width * 0.015,
                                                        ),
                                                        fillColor:
                                                            const Color.fromARGB(
                                                                255, 229, 241, 248),
                                                        filled: true,
                                                        enabledBorder:
                                                            const OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .grey)),
                                                        focusedBorder:
                                                            const OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        width: 1,
                                                                        color: Colors.black87)),
                                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Area Wt(kg)",
                                                  style: TextStyle(
                                                      fontFamily: "sans",
                                                      fontSize: Width * 0.008,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: Height * 0.005,
                                                ),
                                                SizedBox(
                                                  height: 100,
                                                  width: 120,
                                                  child: TextFormField(
                                                    controller:
                                                        multiAreaWtController,
                                                    readOnly: true,
                                                    validator:
                                                        ValidationBuilder()
                                                            .minLength(1)
                                                            .maxLength(45)
                                                            .build(),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    onChanged: (val) {},
                                                    cursorColor: Colors.black87,
                                                    decoration: InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.all(
                                                                Width * 0.005),
                                                        hoverColor: Colors
                                                            .grey.shade300,
                                                        hintText: "Area",
                                                        hintStyle: TextStyle(
                                                          fontFamily: "sans",
                                                          fontSize:
                                                              Width * 0.01,
                                                        ),
                                                        hintFadeDuration:
                                                            const Duration(
                                                                seconds: 1),
                                                        prefixIcon: Icon(
                                                          Icons.numbers,
                                                          size: Width * 0.015,
                                                        ),
                                                        fillColor:
                                                            const Color.fromARGB(
                                                                255, 229, 241, 248),
                                                        filled: true,
                                                        enabledBorder:
                                                            const OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .grey)),
                                                        focusedBorder:
                                                            const OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        width: 1,
                                                                        color: Colors.black87)),
                                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 30,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Wt Diff(Q)",
                                                  style: TextStyle(
                                                      fontFamily: "sans",
                                                      fontSize: Width * 0.008,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: Height * 0.005,
                                                ),
                                                SizedBox(
                                                  height: 100,
                                                  width: 120,
                                                  child: TextFormField(
                                                    controller:
                                                        multiWtDiffController,
                                                    readOnly: true,
                                                    validator:
                                                        ValidationBuilder()
                                                            .minLength(1)
                                                            .maxLength(45)
                                                            .build(),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    onChanged: (val) {},
                                                    cursorColor: Colors.black87,
                                                    decoration: InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.all(
                                                                Width * 0.005),
                                                        hoverColor: Colors
                                                            .grey.shade300,
                                                        hintText: "Diff",
                                                        hintStyle: TextStyle(
                                                          fontFamily: "sans",
                                                          fontSize:
                                                              Width * 0.01,
                                                        ),
                                                        hintFadeDuration:
                                                            const Duration(
                                                                seconds: 1),
                                                        prefixIcon: Icon(
                                                          Icons.numbers,
                                                          size: Width * 0.015,
                                                        ),
                                                        fillColor:
                                                            const Color.fromARGB(
                                                                255, 229, 241, 248),
                                                        filled: true,
                                                        enabledBorder:
                                                            const OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .grey)),
                                                        focusedBorder:
                                                            const OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        width: 1,
                                                                        color: Colors.black87)),
                                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            )
                                            //
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: Height * 0.08,
                                    width: Width * 0.36,
                                    margin: EdgeInsets.only(left: Width * 0.42),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // get multikissan final grandtotal
                                        Consumer<GrandtotalVisibleProvider>(
                                          builder: (context, value, child) =>
                                              Visibility(
                                            visible: value.ismultikissan,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.red),
                                                onPressed: () {
                                                  Provider.of<MultiGrandtotal>(
                                                          context,
                                                          listen: false)
                                                      .calc(
                                                          double.parse(
                                                              multiGrossController
                                                                  .text
                                                                  .toString()),
                                                          double.parse(
                                                              multiTareController
                                                                  .text
                                                                  .toString()));
                                                  setState(() {
                                                    multiAreaWtController
                                                        .text = (Provider.of<
                                                                    MultiGrandtotal>(
                                                                context,
                                                                listen: false)
                                                            .multiAreaWt)
                                                        .toString();
                                                    multiWtDiffController
                                                        .text = (Provider.of<
                                                                    MultiGrandtotal>(
                                                                context,
                                                                listen: false)
                                                            .multiWtDiff)
                                                        .toString();
                                                    rasController
                                                        .text = (Provider.of<
                                                                        MultiGrandtotal>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .nettWett /
                                                            Provider.of<MultiGrandtotal>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .totalLungar)
                                                        .toString();
                                                  });
                                                },
                                                child: const Text(
                                                  "Get Wt",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: Height * 0.03,
                        ),
                        Divider(
                          color: Colors.grey.shade500,
                          endIndent: 40,
                          indent: 40,
                        ),
                        Consumer<GrandtotalVisibleProvider>(
                            builder: (context, value, child) => Visibility(
                                visible: value.ismultikissan,
                                child: const WtdiffTable())),
                        Divider(
                          color: Colors.grey.shade500,
                          endIndent: 40,
                          indent: 40,
                        ),
                        Consumer<GrandtotalVisibleProvider>(
                          builder: (context, value, child) => Visibility(
                            visible: value.issinglekissan,
                            child: Container(
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
                                                  color:
                                                      const Color(0xff2278fd),
                                                  fontSize: Width * 0.01),
                                            ),
                                            Text(
                                              "$nettweight Q",
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
                                                  color:
                                                      const Color(0xff2278fd),
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                            0xff2278fd),
                                                        fontSize: Width * 0.01),
                                                  ),
                                                  SizedBox(
                                                    width: Width * 0.01,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              229,
                                                              241,
                                                              248),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    height: Height * 0.035,
                                                    width: Width * 0.03,
                                                    child: DropdownButton(
                                                      padding: EdgeInsets.all(
                                                          Width * 0.0025),
                                                      iconSize: Width * 0.01,
                                                      underline: const Text(""),
                                                      isExpanded: true,
                                                      dropdownColor:
                                                          Colors.white,
                                                      style: TextStyle(
                                                          fontFamily: "sans",
                                                          fontSize:
                                                              Width * 0.01,
                                                          color:
                                                              Colors.black87),
                                                      value: hammalipercent,
                                                      onChanged:
                                                          (int? newValue) {
                                                        setState(() {
                                                          hammalipercent =
                                                              newValue!;
                                                        });
                                                      },
                                                      items: <int>[
                                                        5,
                                                        10,
                                                        15,
                                                        20,
                                                        25,
                                                        30
                                                      ].map<
                                                              DropdownMenuItem<
                                                                  int>>(
                                                          (int value) {
                                                        return DropdownMenuItem<
                                                            int>(
                                                          value: value,
                                                          child: Text(
                                                              value.toString()),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              "₹$hammali",
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                            0xff2278fd),
                                                        fontSize: Width * 0.01),
                                                  ),
                                                  SizedBox(
                                                    width: Width * 0.01,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              229,
                                                              241,
                                                              248),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    height: Height * 0.035,
                                                    width: Width * 0.03,
                                                    child: DropdownButton(
                                                      padding: EdgeInsets.all(
                                                          Width * 0.0025),
                                                      iconSize: Width * 0.01,
                                                      underline: const Text(""),
                                                      isExpanded: true,
                                                      dropdownColor:
                                                          Colors.white,
                                                      style: TextStyle(
                                                          fontFamily: "sans",
                                                          fontSize:
                                                              Width * 0.01,
                                                          color:
                                                              Colors.black87),
                                                      value: commissionpercent,
                                                      onChanged:
                                                          (int? newValue) {
                                                        setState(() {
                                                          commissionpercent =
                                                              newValue!;
                                                        });
                                                      },
                                                      items: <int>[
                                                        5,
                                                        10,
                                                        15,
                                                        20,
                                                        25,
                                                        30,
                                                      ].map<
                                                              DropdownMenuItem<
                                                                  int>>(
                                                          (int value) {
                                                        return DropdownMenuItem<
                                                            int>(
                                                          value: value,
                                                          child: Text(
                                                              value.toString()),
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                            0xff2278fd),
                                                        fontSize: Width * 0.01),
                                                  ),
                                                  SizedBox(
                                                    width: Width * 0.01,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              229,
                                                              241,
                                                              248),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    height: Height * 0.035,
                                                    width: Width * 0.03,
                                                    child: DropdownButton(
                                                      padding: EdgeInsets.all(
                                                          Width * 0.0025),
                                                      iconSize: Width * 0.01,
                                                      underline: const Text(""),
                                                      isExpanded: true,
                                                      dropdownColor:
                                                          Colors.white,
                                                      style: TextStyle(
                                                          fontFamily: "sans",
                                                          fontSize:
                                                              Width * 0.01,
                                                          color:
                                                              Colors.black87),
                                                      value: mtaxpercent,
                                                      onChanged:
                                                          (int? newValue) {
                                                        setState(() {
                                                          mtaxpercent =
                                                              newValue!;
                                                        });
                                                      },
                                                      items: <int>[
                                                        1,
                                                        2,
                                                        3,
                                                        4,
                                                        5,
                                                      ].map<
                                                              DropdownMenuItem<
                                                                  int>>(
                                                          (int value) {
                                                        return DropdownMenuItem<
                                                            int>(
                                                          value: value,
                                                          child: Text(
                                                              value.toString()),
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
                                                  color:
                                                      const Color(0xff2278fd),
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
                                                  color:
                                                      const Color(0xff2278fd),
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                            0xff2278fd),
                                                        fontSize: Width * 0.01),
                                                  ),
                                                  SizedBox(
                                                    width: Width * 0.01,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              229,
                                                              241,
                                                              248),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    height: Height * 0.035,
                                                    width: Width * 0.03,
                                                    child: DropdownButton(
                                                      padding: EdgeInsets.all(
                                                          Width * 0.0025),
                                                      iconSize: Width * 0.01,
                                                      underline: const Text(""),
                                                      isExpanded: true,
                                                      dropdownColor:
                                                          Colors.white,
                                                      style: TextStyle(
                                                          fontFamily: "sans",
                                                          fontSize:
                                                              Width * 0.01,
                                                          color:
                                                              Colors.black87),
                                                      value: ot,
                                                      onChanged:
                                                          (int? newValue) {
                                                        setState(() {
                                                          ot = newValue!;
                                                        });
                                                      },
                                                      items: <int>[
                                                        40,
                                                        50,
                                                        60,
                                                        70,
                                                        80,
                                                        90
                                                      ].map<
                                                              DropdownMenuItem<
                                                                  int>>(
                                                          (int value) {
                                                        return DropdownMenuItem<
                                                            int>(
                                                          value: value,
                                                          child: Text(
                                                              value.toString()),
                                                        );
                                                      }).toList(),
                                                    ),
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                            0xff2278fd),
                                                        fontSize: Width * 0.01),
                                                  ),
                                                  SizedBox(
                                                    width: Width * 0.01,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              229,
                                                              241,
                                                              248),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    height: Height * 0.035,
                                                    width: Width * 0.03,
                                                    child: DropdownButton(
                                                      padding: EdgeInsets.all(
                                                          Width * 0.0025),
                                                      iconSize: Width * 0.01,
                                                      underline: const Text(""),
                                                      isExpanded: true,
                                                      dropdownColor:
                                                          Colors.white,
                                                      style: TextStyle(
                                                          fontFamily: "sans",
                                                          fontSize:
                                                              Width * 0.01,
                                                          color:
                                                              Colors.black87),
                                                      value: tcspercent,
                                                      onChanged:
                                                          (int? newValue) {
                                                        setState(() {
                                                          tcspercent =
                                                              newValue!;
                                                        });
                                                      },
                                                      items: <int>[
                                                        0,
                                                        1,
                                                        2,
                                                        3,
                                                        4,
                                                        5,
                                                      ].map<
                                                              DropdownMenuItem<
                                                                  int>>(
                                                          (int value) {
                                                        return DropdownMenuItem<
                                                            int>(
                                                          value: value,
                                                          child: Text(
                                                              value.toString()),
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
                                                  color:
                                                      const Color(0xff2278fd),
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
                          ),
                        ),
                        Consumer<GrandtotalVisibleProvider>(
                          builder: (context, value, child) => Visibility(
                              visible: value.ismultikissan,
                              child: const GrandtotalMultikissan()),
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
                                        const Color.fromARGB(221, 255, 0, 0),
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
                                            Consumer<GrandtotalVisibleProvider>(
                                              builder:
                                                  (context, value, child) =>
                                                      TextButton(
                                                onPressed: () async {
                                                  bool already =
                                                      await _alreadyaccountcheck();
                                                  if (already == false) {
                                                    if (value.ismultikissan) {
                                                      await multikissanbill(
                                                          context);
                                                    } else {
                                                      await _addbill(context);
                                                    }

                                                    setState(() {
                                                      downbtn = true;
                                                    });
                                                  } else {
                                                    Apputils()
                                                        .accountAlreadyExist(
                                                            context);
                                                  }
                                                },
                                                child: const Text(
                                                  'Confirm',
                                                  style: TextStyle(
                                                      fontFamily: "sanss",
                                                      color: Colors.green),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: Text(
                                  "Submit",
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
                                    backgroundColor:
                                        const Color.fromARGB(255, 0, 84, 252),
                                    padding: EdgeInsets.all(Width * 0.01),
                                    shape: ContinuousRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                onPressed: () {},
                                child: Text(
                                  "Print",
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
                                  onPressed: () async {},
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
}

Future _Getdata(search, role) async {
  try {
    QuerySnapshot<Map<String, dynamic>> data =
        await FirebaseFirestore.instance.collection("$role").get();

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

Future _getinvoiceno() async {
  var data = await FirebaseFirestore.instance
      .collection("Bills")
      .orderBy("bill_no", descending: true)
      .get();

  int currentbillno = data.docs[0]["bill_no"] + 1;
  return currentbillno;
}

Future _addbill(context) async {
  String billdate = DateFormat('dd-MM-yyyy').format(selectedDate);

  bool isDevicesConnected = await InternetConnectionChecker().hasConnection;
  bool validations = _formkey.currentState!.validate();
  if (validations == true) {
    Apputils().loader(context);
    if (isDevicesConnected == true) {
      Map<String, dynamic> bill = await addobject(
          invoiceno,
          billdate,
          selectedkissan.text,
          kissanid,
          selectedvyapari.text,
          vyapariid,
          vyaparicompany,
          rasController.text,
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
          hammali,
          commission,
          mtax,
          ot,
          tcs,
          grandtotal,
          context,
          note);

      try {
        BillandKhataAddingViewmodel().billAndKhataAmountupdate(
            bill, vyapariid, grandtotal, kissanid, kissanamt, context);
      } catch (e) {
        print("-------$e");
      }
    } else if (isDevicesConnected == false) {
      Apputils().noInternetConnection(context);
    }
  } else {
    Apputils().formisinComplete(context);
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
    hammali,
    commission,
    mtax,
    ot,
    tcs,
    grandtotal,
    context,
    note) async {
  return {
    "bill_no": invoiceno,
    "date": date,
    "kissan_name": selectedkissan,
    "kissan_id": kissanid,
    "vyapari_name": selectedvyapari,
    "vyapari_id": vyapariid,
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
    "hammali": hammali,
    "hammalipercent": hammalipercent,
    "commission": commission,
    "commissionpercent": commissionpercent,
    "mtax": mtax,
    "mtaxpercent": mtaxpercent,
    "ot": ot,
    "tcs": tcs,
    "subtotal": subtotal,
    "grandtotal": grandtotal,
    "ismultikissan":
        Provider.of<GrandtotalVisibleProvider>(context, listen: false)
            .ismultikissan,
    "adminname": "admin1",
    "note": note,
  };
}

Future _alreadyaccountcheck() async {
  bool found = false;
  var data = await FirebaseFirestore.instance
      .collection("Bills")
      .where("board", isEqualTo: board)
      .get();
  var billdata = await FirebaseFirestore.instance
      .collection("Bills")
      .where("bill_no", isEqualTo: invoiceno)
      .get();
  if (data.docs.isEmpty && billdata.docs.isEmpty) {
    found = false;
  } else {
    found = true;
  }
  return found;
}

_loosecalc() {
  double mainwt = gross - tare;
  if (_patiunit == "Percent") {
    patiwt = mainwt * (patival / 100);
    //to convert it in 2 decimal roudoff value
    patiwt = double.parse(
        ((patiwt * 1000).roundToDouble() / 1000).toStringAsFixed(2));
  } else {
    patiwt = patival;
  }

  nettweight = ((mainwt - patiwt) / 100);
  //to convert it in 2 decimal roudoff value
  nettweight = double.parse(
      ((nettweight * 1000).roundToDouble() / 1000).toStringAsFixed(2));

  kissanamt = (nettweight * bhav).round().toDouble();
  hammali = ((nettweight * (hammalipercent / 100)) * 100).round().toDouble();
  commission =
      ((nettweight * (commissionpercent / 100)) * 100).round().toDouble();
  mtax = (kissanamt * (mtaxpercent / 100)).round().toDouble();
  subtotal = (kissanamt + hammali + commission + mtax).round().toDouble();
  grandtotal = subtotal + ot + tcs;
  //ras calc
  rasController.text = (nettweight / lungar).toString();
}

_caratecalc() {
  double mainwt = gross - tare;
  if (_patiunit == "Percent") {
    patiwt = mainwt * patival / 100;
    //to convert it in 2 decimal roudoff value
    patiwt = double.parse(
        ((patiwt * 1000).roundToDouble() / 1000).toStringAsFixed(2));
  } else {
    patiwt = patival;
  }

  if (_dandaunit == "Percent") {
    dandawt = (mainwt - patiwt) * dandaval / 100;
    //to convert it in 2 decimal roudoff value
    dandawt = double.parse(
        ((dandawt * 1000).roundToDouble() / 1000).toStringAsFixed(2));
  } else {
    dandawt = dandaval;
  }

  nettweight = ((mainwt - patiwt + dandawt) / 100);
  //to convert it in 2 decimal roudoff value
  nettweight = double.parse(
      ((nettweight * 1000).roundToDouble() / 1000).toStringAsFixed(2));
  kissanamt = (nettweight * bhav).round().toDouble();
  hammali = ((nettweight * (hammalipercent / 100)) * 100).round().toDouble();
  commission =
      ((nettweight * (commissionpercent / 100)) * 100).round().toDouble();
  mtax = (kissanamt * (mtaxpercent / 100)).round().toDouble();
  subtotal = (kissanamt + hammali + commission + mtax).round().toDouble();
  grandtotal = subtotal + ot + tcs;
  //ras calc
  rasController.text = (nettweight / lungar).toString();
}

_boxcalc() {
  double mainwt = gross - tare;
  if (_patiunit == "Percent") {
    patiwt = mainwt * patival / 100;
    //to convert it in 2 decimal roudoff value
    patiwt = double.parse(
        ((patiwt * 1000).roundToDouble() / 1000).toStringAsFixed(2));
  } else {
    patiwt = patival;
  }

  if (_dandaunit == "Percent") {
    dandawt = (mainwt - patiwt) * dandaval / 100;
    //to convert it in 2 decimal roudoff value
    dandawt = double.parse(
        ((dandawt * 1000).roundToDouble() / 1000).toStringAsFixed(2));
  } else {
    dandawt = dandaval;
  }

  if (_wastageunit == "Percent") {
    wastagewt = mainwt * wastageval / 100;
    //to convert it in 2 decimal roudoff value
    wastagewt = double.parse(
        ((wastagewt * 1000).roundToDouble() / 1000).toStringAsFixed(2));
  } else {
    wastagewt = wastageval;
  }

  nettweight = ((mainwt - patiwt + dandawt + wastagewt) / 100);
  //to convert it in 2 decimal roudoff value
  nettweight = double.parse(
      ((nettweight * 1000).roundToDouble() / 1000).toStringAsFixed(2));
  kissanamt = (nettweight * bhav).round().toDouble();
  hammali = ((nettweight * (hammalipercent / 100)) * 100).round().toDouble();
  commission =
      ((nettweight * (commissionpercent / 100)) * 100).round().toDouble();
  mtax = (kissanamt * (mtaxpercent / 100)).round().toDouble();
  subtotal = (kissanamt + hammali + commission + mtax).round().toDouble();

  grandtotal = subtotal + ot + tcs;
  //ras calc
  rasController.text = (nettweight / lungar).toString();
}

Future<void> multikissanbill(context) async {
  String date = DateFormat('dd-MM-yyyy').format(selectedDate);
  bool isDevicesConnected = await InternetConnectionChecker().hasConnection;
  bool validations = _formkey.currentState!.validate();

  if (validations) {
    if (isDevicesConnected) {
      Apputils().loader(context);
      await BillandKhataAddingViewmodel().multiKissanbillAndKhataAmountupdate(
          await MultiGrandtotal().generateMultikissanBill(
              context,
              invoiceno,
              date,
              selectedkissan,
              kissanid,
              selectedvyapari,
              vyapariid,
              vyaparicompany,
              vyapariaddress,
              rasController.text,
              board,
              motorno,
              bhuktanpk,
              note),
          await MultiGrandtotal().returnMultikissanlist(context),
          context);
    } else {
      Apputils().noInternetConnection(context);
    }
  } else {
    Apputils().formisinComplete(context);
  }
}
