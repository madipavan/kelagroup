import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:form_validator/form_validator.dart';
import 'package:intl/intl.dart';
import 'package:kelawin/Models/billmodel.dart';
import 'package:kelawin/Models/user_model.dart';
import 'package:kelawin/presentation/khatabook/widget/custom_khata_details.dart';

import '../../../Models/khata_model.dart';
import '../../../Models/multikissan_model.dart';
import '../../../Models/transaction_model.dart';
import '../../../service/printing_invoices/Printinvoice.dart';
import '../../../utils/apputils.dart';
import '../../../viewmodel/bill_viewmodel/get_bill_from_server.dart';
import '../../../viewmodel/khata_viewmodel/add_delete_transaction_onserver.dart';
import '../../../viewmodel/khata_viewmodel/getkhata_transaction_viewmodel.dart';
import '../widget/make_payment.dart';

class ReadKhata extends StatefulWidget {
  const ReadKhata({super.key});

  @override
  State<ReadKhata> createState() => _ReadKhataState();
}

class _ReadKhataState extends State<ReadKhata> {
  Key _typeAheadKey = UniqueKey();
  KhataModel khata = KhataModel(khataId: "", received: 0, total: 0, due: 0);
  TextEditingController selectedvyapari = TextEditingController();
  List<Map> narrations = [];
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
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  bool _isLoading = false;
  String _selectedRole = "vyapari";

  List<TransactionModel> transactions = [];
  List<TransactionModel> allTransactionList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Khata Transactions",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        _foatingButton(context, transactions, user),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                DateFormat('dd-MM-yyyy')
                                    .format(DateTime.now())
                                    .toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: "sans",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        CustomKhataDetails(
                            amount: khata.total.toString(),
                            icon: Icons.watch_later_outlined,
                            color: const Color(0xff2196f3),
                            label: "Total amount"),
                        const SizedBox(
                          width: 20,
                        ),
                        CustomKhataDetails(
                            amount: khata.due.toString(),
                            icon: Icons.assignment_late_outlined,
                            color: const Color(0xffe57373),
                            label: "Due amount"),
                        const SizedBox(
                          width: 20,
                        ),
                        CustomKhataDetails(
                            amount: khata.received.toString(),
                            icon: Icons.credit_score_outlined,
                            color: const Color(0xff639975),
                            label: "Recieved amount"),
                        const SizedBox(
                          width: 20,
                        ),
                        CustomKhataDetails(
                            amount:
                                ((fromDate.difference(toDate).inDays + 1).abs())
                                    .toString()
                                    .padLeft(2, '0'),
                            icon: Icons.timelapse_outlined,
                            color: const Color(0xff424242),
                            label: "Range of days"),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            fromDate = await Apputils()
                                .showCalender(context, fromDate);

                            setState(() {
                              fromDate = fromDate;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Icon(
                                  Icons.calendar_month,
                                  color: Colors.grey,
                                ),
                                Text(
                                  DateFormat('dd-MM-yyyy').format(fromDate),
                                  style: const TextStyle(
                                    fontFamily: "sans",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            toDate = await Apputils()
                                .showCalender(context, fromDate);

                            setState(() {
                              toDate = toDate;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Icon(
                                  Icons.calendar_month,
                                  color: Colors.grey,
                                ),
                                Text(
                                  DateFormat('dd-MM-yyyy').format(toDate),
                                  style: const TextStyle(
                                    fontFamily: "sans",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20),
                                backgroundColor: const Color(0xff0073dd),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            onPressed: () async {
                              setState(() {
                                //filtered list when getReprt button is clicked
                                _isLoading = true;
                              });
                              transactions = allTransactionList;
                              transactions = await _getDateSortedTransactions(
                                  transactions, fromDate, toDate);
                              setState(() {
                                //filtered list when getReprt button is clicked
                                _isLoading = false;
                              });
                            },
                            child: const Text(
                              "Get Transactions",
                              style: TextStyle(color: Colors.white),
                            )),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          width: 100,
                          child: DropdownButton(
                            padding: const EdgeInsets.only(left: 5),
                            borderRadius: BorderRadius.circular(5),
                            underline: const Text(""),
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            style: const TextStyle(
                                fontFamily: "sans",
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                            value: _selectedRole,
                            onChanged: (String? newValue) {
                              setState(() {
                                _typeAheadKey = UniqueKey();
                                _selectedRole = newValue!;
                              });
                            },
                            items: <String>[
                              'vyapari',
                              'kissan',
                              'kelagroup',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 1,
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
                                focusNode: focusNode,
                                cursorColor: Colors.grey,
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.search),
                                    label: const Text(
                                      "Search User",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: Colors.blue.shade700,
                                          width: 1),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 1),
                                    )),
                              );
                            },
                            suggestionsCallback: (search) async {
                              return await _getdata(search, _selectedRole);
                            },
                            onSelected: (UserModel val) async {
                              setState(() {
                                _isLoading = true;
                              });
                              selectedvyapari.text = val.name;

                              KhataModel? getkhata =
                                  await GetkhataAndTransactionViewmodel()
                                      .getKhataFromServer(
                                          val.userId, _selectedRole);
                              setState(() {
                                //current user
                                user = val;
                                //current user

                                khata = getkhata!;
                              });

                              transactions =
                                  await GetkhataAndTransactionViewmodel()
                                      .getTransactionFromServer(
                                          user.userId, user.role);
                              narrations = await _getNarrations(transactions);
                              allTransactionList = transactions;

                              setState(() {
                                transactions = transactions;

                                narrations = narrations;

                                _isLoading = false;
                                allTransactionList = transactions;
                              });
                            },
                            itemBuilder: (context, UserModel suggestion) {
                              final random = Random();
                              final color = Color.fromARGB(
                                320,
                                random.nextInt(150),
                                random.nextInt(243),
                                random.nextInt(1),
                              );
                              // Add null check to ensure itemData is not null
                              return ListTile(
                                tileColor: Colors.white,
                                trailing: Text(suggestion.userId.toString(),
                                    style: const TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    suggestion.role == "kissan"
                                        ? suggestion.city
                                        : suggestion.company,
                                    style: const TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold)),
                                leading: CircleAvatar(
                                  backgroundColor: color,
                                  child: Text(
                                    suggestion.name.toString().toUpperCase()[0],
                                    style: const TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(suggestion.name,
                                    style: const TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight
                                            .bold)), // Adjust the field name as per your data structure
                                // Add other widget properties as needed
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                backgroundColor: const Color(0xffff9800),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            onPressed: () async {
                              PrintDocuments().printTransactions(
                                  transactions, user, khata, context);
                            },
                            child: const Text(
                              "Print Transactions",
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: _isLoading
                    ? const Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                                child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              color: Colors.blue,
                            )),
                          ),
                          Text("Loading....")
                        ],
                      )
                    : transactions.isEmpty
                        ? const Center(
                            child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "No Data!",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ))
                        : Table(
                            columnWidths: const {
                              0: FractionColumnWidth(0.05),
                              5: FractionColumnWidth(0.1),
                              7: FractionColumnWidth(0.06),
                              8: FractionColumnWidth(0.06),
                              9: FractionColumnWidth(0.06),
                            },
                            border: TableBorder(
                              // Horizontal borders
                              verticalInside: BorderSide(
                                  color: Colors.grey.shade300, width: 1),
                            ),
                            children: [
                              const TableRow(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: Colors.grey, width: 1),
                                          bottom: BorderSide(
                                              color: Colors.grey, width: 1)),
                                      color: Color.fromARGB(38, 73, 112, 175)),
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        'S No.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        'Transaction Id',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "sans",
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        'Date',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "sans",
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        'Bill No',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "sans",
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        'Narrattion',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "sans",
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        'Transaction Type',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "sans",
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        'Amount',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "sans",
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        'Action',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "sans",
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ]),
                              for (int i = 0; i < transactions.length; i++)
                                TableRow(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey, width: 1)),
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          (i + 1).toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          transactions[i]
                                              .transactionId
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          transactions[i].date.toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          transactions[i].billno == 0
                                              ? "NA"
                                              : transactions[i]
                                                  .billno
                                                  .toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          transactions[i].paymentMode != ""
                                              ? "${narrations[i]["paymentMode"]} - ${narrations[i]["receiverName"]}"
                                              : "L:${narrations[i]["L"]} , Wt:${narrations[i]["Wt"]} , Mno:${narrations[i]["Mno"]} , Rate:${narrations[i]["Rate"]}",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: transactions[i]
                                                        .transactionType ==
                                                    "CREDIT"
                                                ? const Color(0xffbef1d0)
                                                : const Color(0xffffcdd2),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Text(
                                              transactions[i]
                                                  .transactionType
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: transactions[i]
                                                              .transactionType ==
                                                          "CREDIT"
                                                      ? const Color(0xff639975)
                                                      : const Color(0xffe57373),
                                                  fontFamily: "sans",
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          transactions[i].amount.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: transactions[i]
                                                          .transactionType ==
                                                      "CREDIT"
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: transactions[i].paymentMode != ""
                                            ? IconButton(
                                                onPressed: () async {
                                                  await _deletionOfTransaction(
                                                      context,
                                                      transactions[i],
                                                      user);
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
                                    ]),
                            ],
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _foatingButton(
    context, List<TransactionModel> transactions, UserModel user) {
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
      backgroundColor: const Color(0xff0073dd),
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

Future<List<UserModel>> _getdata(search, role) async {
  try {
    QuerySnapshot<Map<String, dynamic>> data =
        await FirebaseFirestore.instance.collection("$role").get();

    List<UserModel> users = [];

    for (var element in data.docs) {
      users.add(UserModel.fromJson(element.data()));
    }

    List<UserModel> foundList = users
        .where((element) => element.name
            .toString()
            .toLowerCase()
            .contains(search.toString().toLowerCase()))
        .toList();

    return foundList;
  } catch (e) {
    // Handle errors
    print("Error fetching data: $e");
    return [];
  }
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
        double totalLungar = 0;
        for (MultikissanModel element in bill.multiKissanList!) {
          totalLungar += element.lungar;
        }

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

Future _deletionOfTransaction(
    BuildContext context, TransactionModel transaction, UserModel user) async {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
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
