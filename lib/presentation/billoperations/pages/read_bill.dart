import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kelawin/Models/billmodel.dart';
import 'package:kelawin/Models/multikissan_model.dart';
import 'package:kelawin/presentation/billoperations/pages/CreateBill.dart';
import 'package:kelawin/utils/apputils.dart';

import '../../../service/printing_invoices/Printinvoice.dart';
import '../../../viewmodel/bill_viewmodel/get_bill_from_server.dart';
import '../widget/chooseinvoice_color.dart';

class ReadBill extends StatefulWidget {
  const ReadBill({super.key});

  @override
  State<ReadBill> createState() => _ReadBillState();
}

List<Map<String, dynamic>> filters = [
  {
    "filter": "10 Days",
    "value": DateTime.now().subtract(const Duration(days: 10))
  },
  {
    "filter": "15 Days",
    "value": DateTime.now().subtract(const Duration(days: 15))
  },
  {
    "filter": "30 Days",
    "value": DateTime.now().subtract(const Duration(days: 30))
  },
  {
    "filter": "90 Days",
    "value": DateTime.now().subtract(const Duration(days: 90))
  },
  {"filter": "1 year", "value": DateTime.now()}
];
Map? selectedFilter;
String _searcCatgory = "BillNo";

class _ReadBillState extends State<ReadBill> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  bool? _isLoading;
  late List<BillModel> allBills;
  late List<BillModel> foundList;
  late List<BillModel> tempfoundList;

  @override
  void initState() {
    _getBills();
    super.initState();
  }

  Future _getBills() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    allBills = await GetBillFromServer().getAllbills();

    if (mounted) {
      setState(() {
        _isLoading = false;
        foundList = allBills;
        tempfoundList = foundList;
        _isLoading = _isLoading;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: _isLoading!
          ? const Center(
              child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              color: Colors.blue,
            ))
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 300,
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
                              const Text("Bills Reports",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                              const Spacer(),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 18),
                                      backgroundColor: const Color(0xff0073dd),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  onPressed: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CreateBill(
                                                  toUpdate: false,
                                                )));
                                    await _getBills();
                                  },
                                  child: const Text(
                                    "Create Bill",
                                    style: TextStyle(color: Colors.white),
                                  )),
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
                            children: filters.map((filter) {
                              bool isSelected = selectedFilter == null
                                  ? false
                                  : selectedFilter!["filter"] ==
                                      filter["filter"];
                              return Row(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedFilter = filter;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.blue
                                              : Colors.white,
                                          border: Border.all(
                                            color: isSelected
                                                ? Colors.blueAccent
                                                : Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          filter["filter"].toString(),
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 16,
                                            fontFamily: "sans",
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  selectedFilter = null;
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
                                      border: Border.all(
                                          width: 1, color: Colors.grey)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Icon(
                                        Icons.calendar_month,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        DateFormat('dd-MM-yyyy')
                                            .format(fromDate),
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
                                  selectedFilter = null;
                                  toDate = await Apputils()
                                      .showCalender(context, toDate);

                                  setState(() {
                                    toDate = toDate;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1, color: Colors.grey)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
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
                          Row(
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 20),
                                      backgroundColor: const Color(0xff0073dd),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  onPressed: () async {
                                    if (selectedFilter == null) {
                                      foundList = await _getReport(
                                          fromDate, toDate, allBills);
                                    } else {
                                      selectedFilter!["filter"] == "1 year"
                                          ? foundList = allBills
                                          : foundList = await _getReport(
                                              selectedFilter!["value"],
                                              DateTime.now(),
                                              allBills);
                                    }
                                    setState(() {
                                      //filtered list when getReprt button is clicked
                                      tempfoundList = foundList;
                                    });
                                  },
                                  child: const Text(
                                    "Get Report",
                                    style: TextStyle(color: Colors.white),
                                  )),
                              const Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(5)),
                                width: 80,
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
                                  value: _searcCatgory,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _searcCatgory = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    'BillNo',
                                    'Vyapari',
                                    'Kissan',
                                    'Kelagroup',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
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
                                  child: TextFormField(
                                    onChanged: (value) async {
                                      value = value.trim();

                                      //filtered list when getReprt button is clicked
                                      foundList = tempfoundList;

                                      foundList = await _searching(
                                          value, _searcCatgory, tempfoundList);

                                      setState(() {});
                                    },
                                    cursorColor: Colors.grey,
                                    decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.search),
                                        label: const Text(
                                          "Search Bill",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: Colors.blue.shade700,
                                              width: 1),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: Colors.grey, width: 1),
                                        )),
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: Table(
                        columnWidths: const {
                          0: FractionColumnWidth(0.05),
                          7: FractionColumnWidth(0.06),
                          8: FractionColumnWidth(0.06),
                          9: FractionColumnWidth(0.06),
                        },
                        border: TableBorder(
                          // Horizontal borders
                          verticalInside:
                              BorderSide(color: Colors.grey.shade300, width: 1),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                    'Bill No.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'Vyapari Name',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'Kissan Name',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'NetWt',
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
                                    'Jantri',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'Invoice',
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
                          for (int i = 0; i < foundList.length; i++)
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
                                      foundList[i].date,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: "sans",
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      foundList[i].invoiceno.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: "sans",
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      foundList[i].selectedvyapari,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: "sans",
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  foundList[i].isMultikissan
                                      ? Column(
                                          children: [
                                            for (MultikissanModel kissan
                                                in foundList[i]
                                                    .multiKissanList!)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                child: Text(
                                                  kissan.name,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: kissan.iskelagroup
                                                          ? Colors.green
                                                          : Colors.black,
                                                      fontFamily: "sans",
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                          ],
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            foundList[i].selectedkissan,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontFamily: "sans",
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      foundList[i].nettweight.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: "sans",
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      foundList[i].grandtotal.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: "sans",
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0, vertical: 0),
                                            backgroundColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5))),
                                        onPressed: () async {
                                          PrintDocuments().printJantri(
                                              foundList[i].invoiceno, context);
                                        },
                                        child: const Text(
                                          "JANTRI",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0, vertical: 0),
                                            backgroundColor:
                                                Colors.blue.shade700,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5))),
                                        onPressed: () async {
                                          setState(() {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) =>
                                                    ChooseInvoiceColor(
                                                      invoiceno: foundList[i]
                                                          .invoiceno,
                                                    ));
                                          });
                                        },
                                        child: const Text(
                                          "INVOICE",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0, vertical: 0),
                                            backgroundColor:
                                                Colors.blue.shade900,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5))),
                                        onPressed: () async {
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreateBill(
                                                        toUpdate: true,
                                                        bill: foundList[i],
                                                      )));
                                          await _getBills();
                                        },
                                        child: const Text(
                                          "EDIT",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ),
                                ])
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

Future<List<BillModel>> _getReport(
    DateTime fromDate, DateTime toDate, List<BillModel> allBills) async {
  List<DateTime> datesToSearched = [fromDate];
  List<BillModel> sortedBillList = await _sortingOfBills(allBills);
  List<BillModel> foundList = [];
  int datesCount = -(fromDate.difference(toDate).inDays);

  //fetching of dates
  if (fromDate != toDate) {
    for (int i = 0; i < datesCount; i++) {
      datesToSearched.add(fromDate.add(Duration(days: i + 1)));
    }
  }

  //search of dates

  for (int i = 0; i < datesToSearched.length; i++) {
    DateFormat dateFormat = DateFormat("dd-MM-yyyy");
    DateTime keyDate = DateTime(datesToSearched[i].year,
        datesToSearched[i].month, datesToSearched[i].day);

    for (BillModel bill in sortedBillList) {
      if (keyDate.isAtSameMomentAs(dateFormat.parse(bill.date))) {
        foundList.add(bill);
      }
    }
  }

  //search of dates
  return foundList;
}

Future<List<BillModel>> _sortingOfBills(List<BillModel> allBills) async {
  for (int i = 0; i < allBills.length - 1; i++) {
    for (int j = 0; j < allBills.length - 1 - i; j++) {
      DateFormat dateFormat = DateFormat("dd-MM-yyyy");
      DateTime firstDate = dateFormat.parse(allBills[j].date);
      DateTime nextDate = dateFormat.parse(allBills[j + 1].date);

      if (nextDate.isBefore(firstDate)) {
        //swaping
        BillModel temp = allBills[j];
        allBills[j] = allBills[j + 1];
        allBills[j + 1] = temp;
      }
    }
  }
  return allBills;
}

Future<List<BillModel>> _searching(
    val, String searchcatogary, List<BillModel> foundList) async {
  if (val.toString().isEmpty) {
    return foundList;
  } else {
    if (searchcatogary == "BillNo") {
      foundList = foundList
          .where((element) =>
              element.invoiceno.toString().toLowerCase().contains(val))
          .toList();
    }
    if (searchcatogary == "Kissan") {
      List<BillModel> tempList = foundList
          .where((element) => element.isMultikissan
              ? element.multiKissanList!.any(
                  (test) => test.name.toString().toLowerCase().contains(val))
              : false)
          .toList();

      foundList = foundList
              .where((element) =>
                  element.selectedkissan.toString().toLowerCase().contains(val))
              .toList() +
          tempList;
    }
    if (searchcatogary == "Vyapari") {
      foundList = foundList
          .where((element) =>
              element.selectedvyapari.toString().toLowerCase().contains(val))
          .toList();
    }
    if (searchcatogary == "Kelagroup") {
      foundList = foundList
          .where((element) => element.isMultikissan
              ? element.multiKissanList.toString().toLowerCase().contains(val)
              : false)
          .toList();
    }

    return foundList;
  }
}
