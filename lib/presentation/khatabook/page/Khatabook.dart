import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:form_validator/form_validator.dart';
import 'package:intl/intl.dart';
import 'package:kelawin/Models/billmodel.dart';
import 'package:kelawin/Models/khata_model.dart';
import 'package:kelawin/Models/transaction_model.dart';
import 'package:kelawin/Models/user_model.dart';
import 'package:kelawin/presentation/khatabook/widget/make_payment.dart';
import 'package:kelawin/viewmodel/bill_viewmodel/get_bill_from_server.dart';
import 'package:kelawin/viewmodel/khata_viewmodel/add_delete_transaction_onserver.dart';
import 'package:kelawin/viewmodel/khata_viewmodel/getkhata_transaction_viewmodel.dart';

import '../../../service/printing_invoices/Printinvoice.dart';

class Khatabook extends StatefulWidget {
  const Khatabook({super.key});

  @override
  State<Khatabook> createState() => _KhatabookState();
}

List<TransactionModel> transactions = [];
List<TransactionModel> allTransactionList = [];
Key _typeAheadKey = UniqueKey();

String selectedRole = "vyapari";
DateTime selectedDate = DateTime.now();
DateTime selectedtoDate = DateTime.now();

KhataModel khata = KhataModel(khataId: "", received: 0, total: 0, due: 0);
TextEditingController selectedvyapari = TextEditingController();

UserModel user = UserModel(
    name: "",
    password: "",
    phone: "",
    pincode: "",
    role: '',
    state: "",
    address: '',
    city: '',
    company: '',
    email: '',
    userId: 0);

class _KhatabookState extends State<Khatabook> {
  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: _foatingButton(context, Height, Width),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 35),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 250),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.white,
                      height: Height * 0.05,
                      width: Width * 0.3,
                      child: TypeAheadField(
                        key: _typeAheadKey,
                        builder: (context, controller, focusNode) {
                          selectedvyapari = controller;
                          return TextFormField(
                            controller: selectedvyapari,
                            validator: ValidationBuilder()
                                .minLength(2)
                                .maxLength(45)
                                .build(),
                            cursorColor: Colors.black87,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(Width * 0.005),
                                hoverColor: Colors.grey.shade300,
                                hintText: "Search For User",
                                hintStyle: TextStyle(
                                  fontFamily: "sans",
                                  fontSize: Width * 0.012,
                                ),
                                hintFadeDuration: const Duration(seconds: 1),
                                prefixIcon: Icon(
                                  Icons.person,
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
                          );
                        },
                        suggestionsCallback: (search) async {
                          return await _Getdata(search, selectedRole);
                        },
                        onSelected: (dynamic val) async {
                          selectedvyapari.text = val["name"];
                          KhataModel? getkhata =
                              await GetkhataAndTransactionViewmodel()
                                  .getKhataFromServer(
                                      val["${selectedRole}_id"], selectedRole);
                          setState(() {
                            //current user
                            user = UserModel(
                                name: val["name"],
                                password: val["password"],
                                phone: val["phone"],
                                pincode: val["pincode"],
                                role: val["role"],
                                state: val["state"],
                                address: val["address"],
                                city: val["city"],
                                company: val["role"] == "kissan"
                                    ? " "
                                    : val["company"],
                                email: val["email"],
                                userId: val["${val["role"]}_id"]);
                            //current user

                            khata = getkhata!;
                          });
                          transactions = await GetkhataAndTransactionViewmodel()
                              .getTransactionFromServer(user.userId, user.role);
                          allTransactionList = transactions;
                          setState(() {
                            transactions = transactions;
                          });
                        },
                        itemBuilder: (context, dynamic suggestion) {
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
                                  suggestion["${selectedRole}_id"].toString(),
                                  style: const TextStyle(
                                      fontFamily: "sans",
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  selectedRole == "kissan"
                                      ? suggestion["city"]
                                      : suggestion["company"],
                                  style: const TextStyle(
                                      fontFamily: "sans",
                                      fontWeight: FontWeight.bold)),
                              leading: CircleAvatar(
                                backgroundColor: color,
                                child: Text(
                                  suggestion["name"]
                                      .toString()
                                      .toUpperCase()[0],
                                  style: const TextStyle(
                                      fontFamily: "sans",
                                      fontWeight: FontWeight.bold),
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
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                          border: Border.all(width: 1, color: Colors.grey)),
                      width: Width * 0.05,
                      child: DropdownButton(
                        padding: const EdgeInsets.all(5),
                        iconSize: 15,
                        underline: const Text(""),
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(25),
                        dropdownColor: Colors.white,
                        style: const TextStyle(
                            fontFamily: "sans",
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                        value: selectedRole,
                        onChanged: (String? newValue) {
                          setState(() {
                            khata = KhataModel(
                                khataId: "", received: 0, total: 0, due: 0);
                            transactions = [];
                            selectedRole = newValue!;
                            _typeAheadKey = UniqueKey();
                          });
                        },
                        items: <String>['vyapari', 'kissan', 'kelagroup']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(Width * 0.003),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                          border: Border.all(width: 1, color: Colors.grey)),
                      height: Height * 0.05,
                      width: Width * 0.075,
                      child: InkWell(
                        onTap: () async {
                          var fromdate = await _selectDate(context);
                          transactions = allTransactionList;
                          transactions = await _getDateSortedTransactions(
                              transactions, selectedDate, selectedtoDate);

                          setState(() {
                            selectedDate = fromdate;
                            fromdate =
                                DateFormat('dd-MM-yyyy').format(fromdate);
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
                    Container(
                      padding: EdgeInsets.all(Width * 0.003),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                          border: Border.all(width: 1, color: Colors.grey)),
                      height: Height * 0.05,
                      width: Width * 0.075,
                      child: InkWell(
                        onTap: () async {
                          var todate = await _selecttoDate(context);
                          transactions = allTransactionList;
                          transactions = await _getDateSortedTransactions(
                              transactions, selectedDate, selectedtoDate);
                          setState(() {
                            selectedtoDate = todate;
                            todate = DateFormat('dd-MM-yyyy').format(todate);
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
                              DateFormat('dd-MM-yyyy').format(selectedtoDate),
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
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.all(25)),
                        onPressed: () async {
                          PrintDocuments().printTransactions(
                              transactions, user, khata, context);
                        },
                        child: const Text(
                          "Print Transaction",
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              //
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: Width * 0.7,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.grey.shade200,
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: Row(
                      children: [
                        const Text(
                          "Total Amount:",
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontFamily: "sans",
                              fontSize: 25),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            khata.total.toStringAsFixed(2),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: "sans",
                                fontSize: 25),
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          "Recieved Amount:",
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontFamily: "sans",
                              fontSize: 25),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            khata.received.toStringAsFixed(2),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: "sans",
                                fontSize: 25),
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          "Due Amount:",
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontFamily: "sans",
                              fontSize: 25),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            khata.due.toStringAsFixed(2),
                            style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontFamily: "sans",
                                fontSize: 25),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              FutureBuilder<Widget>(
                future: _transactionTable(
                    user.userId, user.role, transactions, context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 100),
                      child: CircularProgressIndicator(
                        color: Colors.blue.shade800,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return snapshot
                        .data!; // Assuming the future returns a Widget
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
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
            .contains(search.toString().toLowerCase()))
        .map((e) => e.data())
        .toList();

    return foundList;
  } catch (e) {
    // Handle errors
    print("Error fetching data: $e");
    return [];
  }
}

Future _selectDate(BuildContext context) async {
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
    selectedDate = picked;

    return selectedDate;
  } else {
    return selectedDate;
  }
}

Future _selecttoDate(BuildContext context) async {
  final DateTime? pickeded = await showDatePicker(
      context: context,
      initialDate: selectedtoDate,
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
  if (pickeded != null && pickeded != selectedtoDate) {
    selectedtoDate = pickeded;
    return selectedtoDate;
  } else {
    return selectedtoDate;
  }
}

Future<Widget> _transactionTable(int userId, String role,
    List<TransactionModel> transactionsList, context) async {
  List<Map> narrations = await _getNarrations(transactionsList);
  List<TableRow> tableRows = [
    const TableRow(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(width: 1, color: Colors.black),
                bottom: BorderSide(width: 1, color: Colors.black))),
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'S No.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "sans",
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Transaction Id',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "sans",
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Date',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "sans",
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Bill No',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "sans",
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Narrattion',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "sans",
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Debit/Credit',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "sans",
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Amount',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "sans",
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Action',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "sans",
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ])
  ];

  int i = 1;
//middle rows
  for (TransactionModel transaction in transactionsList) {
    tableRows.add(TableRow(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Colors.black))),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              i.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: "sans",
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              transaction.transactionId.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: "sans",
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              transaction.date.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: "sans",
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              transaction.billno == 0 ? "NA" : transaction.billno.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: "sans",
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              transaction.paymentMode != ""
                  ? "${narrations[i - 1]["paymentMode"]} - ${narrations[i - 1]["receiverName"]}"
                  : "L:${narrations[i - 1]["L"]} , Wt:${narrations[i - 1]["Wt"]} , Mno:${narrations[i - 1]["Mno"]} , Rate:${narrations[i - 1]["Rate"]}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: "sans",
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              transaction.transactionType.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: "sans",
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              transaction.amount.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "sans",
                  color: transaction.transactionType == "CREDIT"
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: transaction.paymentMode != ""
                ? IconButton(
                    onPressed: () async {
                      await _deletionOfTransaction(context, transaction);
                    },
                    icon: const Icon(Icons.delete))
                : const Text(
                    "NA",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "sans",
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
          ),
        ]));
    i++;
  }
//middle rows
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
    child: Table(
      columnWidths: const {
        0: FractionColumnWidth(0.05),
        4: FractionColumnWidth(0.3),
      },
      border: const TableBorder(
        // Horizontal borders
        verticalInside: BorderSide(color: Colors.black, width: 1),
      ),
      children: tableRows,
    ),
  );
}

Future<List<Map>> _getNarrations(
    List<TransactionModel> transactionsList) async {
  List<Map> narrations = [];

  for (int j = 0; j < transactionsList.length; j++) {
    if (transactionsList[j].paymentMode != "") {
      narrations.insert(j, {
        "paymentMode": transactionsList[j].paymentMode,
        "receiverName": transactionsList[j].receiverName,
      });
    } else {
      BillModel? bill =
          await GetBillFromServer().getbill(transactionsList[j].billno);
      if (bill!.isMultikissan) {
        int totalLungar = 0;
        for (var element in bill.multiKissanList!) {
          totalLungar += int.parse(element["lungar"]);
        }
        bill.multiKissanList![0]["lungar"];
        narrations.insert(j, {
          "L": totalLungar,
          "Wt": bill.nettweight,
          "Mno": bill.motorno,
          "Rate": ""
        });
      } else {
        narrations.insert(j, {
          "L": bill.lungar,
          "Wt": bill.nettweight,
          "Mno": bill.motorno,
          "Rate": bill.bhav
        });
      }
    }
  }

  return narrations;
}

Future<List<TransactionModel>> _getDateSortedTransactions(
    List<TransactionModel> transactions, DateTime from, DateTime to) async {
  List<DateTime> datesToSearched = [from];
  List<TransactionModel> foundList = [];
  int datesCount = -(from.difference(to).inDays);

  //fetching of dates
  if (from != to) {
    for (int i = 0; i < datesCount; i++) {
      datesToSearched.add(from.add(Duration(days: i + 1)));
    }
  }

  //fetching of dates

  //sorting of data
  for (int i = 0; i < transactions.length - 1; i++) {
    for (int j = 0; j < (transactions.length - 1) - i; j++) {
      DateFormat dateFormat = DateFormat("dd-MM-yyyy");
      DateTime firstDate = dateFormat.parse(transactions[j].date);
      DateTime nextDate = dateFormat.parse(transactions[j + 1].date);

      if (nextDate.isBefore(firstDate)) {
        //swaping
        TransactionModel temp = transactions[j];
        transactions[j] = transactions[j + 1];
        transactions[j + 1] = temp;
      }
    }
  }
  //sorting of data

  //search of dates

  for (int i = 0; i < datesToSearched.length; i++) {
    DateFormat dateFormat = DateFormat("dd-MM-yyyy");
    DateTime keyDate = DateTime(datesToSearched[i].year,
        datesToSearched[i].month, datesToSearched[i].day);

    for (TransactionModel transaction in transactions) {
      if (keyDate == dateFormat.parse(transaction.date)) {
        foundList.add(transaction);
      }
    }
  }

  //search of dates

  return foundList;
}

Widget _foatingButton(context, height, width) {
  List<int> billNumbers = [0];
  for (TransactionModel transaction in transactions) {
    if (transaction.paymentMode == "") {
      billNumbers.add(transaction.billno);
    }
  }

  return SizedBox(
    width: 150,
    child: FloatingActionButton(
      onPressed: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return MakePayment(
                billNumbers: billNumbers,
                user: user,
              );
            });
      },
      backgroundColor: Colors.blue.shade700,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Payment",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Icon(
            Icons.paypal_outlined,
            color: Colors.white,
          )
        ],
      ),
    ),
  );
}

Future _deletionOfTransaction(
    BuildContext context, TransactionModel transaction) async {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
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
                'Confirm Deletion',
                style: TextStyle(
                  fontFamily: "sans",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Are you sure you want to delete this transaction?',
                style: TextStyle(fontFamily: "sans"),
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
                style: TextStyle(fontFamily: "sans", color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                AddDeleteTransactionOnserver()
                    .deleteTransactionOnServer(transaction, user.role, context);
              },
              child: const Text(
                'Confirm',
                style: TextStyle(fontFamily: "sans", color: Colors.red),
              ),
            ),
          ],
        );
      });
}
