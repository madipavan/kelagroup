import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:kelawin/Models/transaction_model.dart';
import 'package:kelawin/Models/user_model.dart';
import 'package:kelawin/presentation/khatabook/page/Khatabook.dart';
import 'package:kelawin/presentation/khatabook/widget/customtext_field.dart';

import '../../../viewmodel/khata_viewmodel/add_delete_transaction_onserver.dart';

class MakePayment extends StatefulWidget {
  final UserModel user;
  final List<int> billNumbers;
  const MakePayment({super.key, required this.user, required this.billNumbers});

  @override
  State<MakePayment> createState() => _MakePaymentState();
}

final _formkey = GlobalKey<FormState>();
String paymentMode = "BANK";
String paymentType = "CREDIT";
int selectedBill = 0;
DateTime transactionRecievedDate = DateTime.now();

List<int> _billNumbers = [];

TextEditingController userName = TextEditingController();
TextEditingController userId = TextEditingController();
TextEditingController receiverName = TextEditingController();
TextEditingController amount = TextEditingController();

class _MakePaymentState extends State<MakePayment> {
  @override
  void initState() {
    userName.text = user.name;
    userId.text = user.userId.toString();

    _billNumbers = _sortTheBillnumbers(widget.billNumbers);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            color: Colors.grey,
            size: 30,
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            'Payment',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      content: Row(
        children: [
          SizedBox(
            width: 500,
            height: 450,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: CustomtextField(
                              controller: userName,
                              readOnly: true,
                              isAmount: false,
                              prefix: const Icon(Icons.person_2_outlined),
                              label: "User Name",
                            )),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            flex: 1,
                            child: CustomtextField(
                              controller: userId,
                              readOnly: true,
                              isAmount: false,
                              label: "UserId",
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: CustomtextField(
                              onChanged: (value) {
                                setState(() {
                                  receiverName.text = receiverName.text;
                                });
                              },
                              controller: receiverName,
                              readOnly: false,
                              isAmount: false,
                              prefix: const Icon(Icons.person_2_outlined),
                              label: "Receiver Name",
                            )),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: DropdownButton(
                              padding: const EdgeInsets.only(left: 5),
                              iconSize: 15,
                              underline: const Text(""),
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(5),
                              dropdownColor: Colors.white,
                              style: const TextStyle(
                                  fontFamily: "sans",
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                              value: paymentMode,
                              onChanged: (String? newValue) {
                                setState(() {
                                  paymentMode = newValue!;
                                });
                              },
                              items: <String>[
                                'BANK',
                                'CHEQUE',
                                'CASH',
                                'UPI'
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
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(Width * 0.003),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              border: Border.all(width: 1, color: Colors.grey)),
                          height: Height * 0.05,
                          width: Width * 0.075,
                          child: InkWell(
                            onTap: () async {
                              var fromdate =
                                  await _selectTransactionRecievedDate(
                                      context, transactionRecievedDate);

                              setState(() {
                                transactionRecievedDate = fromdate;
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
                                  DateFormat('dd-MM-yyyy')
                                      .format(transactionRecievedDate),
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
                        const SizedBox(
                          width: 40,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: DropdownButton(
                              padding: const EdgeInsets.only(left: 5),
                              iconSize: 15,
                              underline: const Text(""),
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(5),
                              dropdownColor: Colors.white,
                              style: const TextStyle(
                                  fontFamily: "sans",
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                              value: selectedBill,
                              onChanged: (int? newValue) {
                                setState(() {
                                  selectedBill = newValue!;
                                });
                              },
                              items: _billNumbers
                                  .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(value.toString()),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: DropdownButton(
                              padding: const EdgeInsets.only(left: 5),
                              iconSize: 15,
                              underline: const Text(""),
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(5),
                              dropdownColor: Colors.white,
                              style: const TextStyle(
                                  fontFamily: "sans",
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                              value: paymentType,
                              onChanged: (String? newValue) {
                                setState(() {
                                  paymentType = newValue!;
                                });
                              },
                              items: <String>[
                                'CREDIT',
                                'DEBIT'
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
                    CustomtextField(
                      onChanged: (value) {
                        setState(() {
                          amount.text = amount.text;
                        });
                      },
                      controller: amount,
                      readOnly: false,
                      isAmount: true,
                      prefix: const Icon(Icons.currency_rupee),
                      label: "Amount",
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          onPressed: () async {
                            TransactionModel transaction = TransactionModel(
                                transactionId: 0,
                                transactionType: paymentType,
                                date: DateFormat('dd-MM-yyyy')
                                    .format(transactionRecievedDate)
                                    .toString(),
                                khataId: "",
                                amount: double.parse(amount.text),
                                billno: selectedBill,
                                paymentMode: paymentMode,
                                receiverName: receiverName.text,
                                userId: user.userId.toString());
                            if (await InternetConnectionChecker()
                                .hasConnection) {
                              if (_formkey.currentState!.validate()) {
                                AddDeleteTransactionOnserver()
                                    .addTransactionOnServer(
                                        transaction, user.role, context);
                              }
                            }
                          },
                          child: const Text(
                            "Pay Now",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Colors.grey.shade300,
            width: 300,
            height: 400,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                children: [
                  Text(
                    "TRANSACTION",
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                  Divider(
                    color: Colors.grey.shade500,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "USER ROLE",
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                      Text(
                        user.role,
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "USER NAME",
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                      Text(
                        user.name,
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "USER ID",
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                      Text(
                        user.userId.toString(),
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "RECEIVER",
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                      Text(
                        receiverName.text,
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "PAYMENT MODE",
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                      Text(
                        paymentMode,
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "DATE",
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                      Text(
                        DateFormat('dd-MM-yyyy')
                            .format(transactionRecievedDate)
                            .toString(),
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "BILL NO",
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                      Text(
                        selectedBill.toString(),
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "PAYMENT TYPE",
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                      Text(
                        paymentType,
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Divider(
                    color: Colors.grey.shade500,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "AMOUNT",
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                      Text(
                        amount.text,
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'CANCEL',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}

Future _selectTransactionRecievedDate(
    BuildContext context, DateTime transactionRecievedDate) async {
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: transactionRecievedDate,
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
  if (picked != null && picked != transactionRecievedDate) {
    transactionRecievedDate = picked;

    return transactionRecievedDate;
  } else {
    return transactionRecievedDate;
  }
}

List<int> _sortTheBillnumbers(List<int> billNumbers) {
  //sorting
  for (int i = 0; i < billNumbers.length - 1; i++) {
    for (int j = 0; j < (billNumbers.length - 1) - i; j++) {
      if (billNumbers[j + 1] < billNumbers[j]) {
        int tempNumber = billNumbers[j + 1];
        billNumbers[j + 1] = billNumbers[j];
        billNumbers[j] = tempNumber;
      }
    }
  }
  //sorting

  return billNumbers;
}
