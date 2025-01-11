import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kelawin/Models/billmodel.dart';
import 'package:kelawin/utils/apputils.dart';

import '../../../Models/multikissan_model.dart';
import '../../../service/printing_invoices/Printinvoice.dart';
import '../../../viewmodel/bill_viewmodel/get_bill_from_server.dart';

class MandiReport extends StatefulWidget {
  const MandiReport({super.key});

  @override
  State<MandiReport> createState() => _MandiReportState();
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
List<BillModel> allBills = [];
List<BillModel> foundList = [];

class _MandiReportState extends State<MandiReport> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  bool _isLoading = true;
  bool _isTableLoading = true;
  @override
  void initState() {
    _getBills();
    selectedFilter = null;
    super.initState();
  }

  Future _getBills() async {
    allBills = await GetBillFromServer().getAllbills();
    foundList = allBills;
    allBills = await _sortingOfBills(allBills);

    _isLoading = false;
    setState(() {
      _isLoading = _isLoading;
      _isTableLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: _isLoading
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
                              const Text("Mandi Reports",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      foundList =
                                          await _getReport(fromDate, toDate);
                                    } else {
                                      selectedFilter!["filter"] == "1 year"
                                          ? foundList = allBills
                                          : foundList = await _getReport(
                                              selectedFilter!["value"],
                                              DateTime.now());
                                    }
                                    setState(() {
                                      _isTableLoading = false;
                                    });
                                  },
                                  child: const Text(
                                    "Get Report",
                                    style: TextStyle(color: Colors.white),
                                  )),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      backgroundColor: const Color(0xffff9800),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  onPressed: () async {
                                    await PrintDocuments()
                                        .printMandiReports(foundList);
                                  },
                                  child: const Text(
                                    "Print Reports",
                                    style: TextStyle(color: Colors.white),
                                  )),
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
                        child: _isTableLoading
                            ? const Column(
                                children: [
                                  Center(
                                      child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    color: Colors.blue,
                                  )),
                                  Text("Loading...")
                                ],
                              )
                            : _mandiReportTable(foundList)),
                  ),
                ],
              ),
            ),
    );
  }
}

Future<List<BillModel>> _getReport(DateTime fromDate, DateTime toDate) async {
  List<DateTime> datesToSearched = [fromDate];
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

    for (BillModel bill in allBills) {
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

Widget _mandiReportTable(List<BillModel> allBills) {
  List<TableRow> tableRows = [
    const TableRow(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(color: Colors.grey, width: 1),
                bottom: BorderSide(color: Colors.grey, width: 1)),
            color: Color.fromARGB(38, 73, 112, 175)),
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'S No.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Board No/Anuban',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Bhuktan Pk',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Date',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Kissan Name',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Net Wt',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Rate',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Amount',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Mandi Tax',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ])
  ];
  double dayTotalNetWt = 0;
  double dayTotalKissanAmount = 0;
  double dayTotalMandiTax = 0;
  double grandTotalNetWt = 0;
  double grandTotalKissanAmount = 0;
  double grandTotalMandiTax = 0;

  //adding rows
  for (int i = 0; i < allBills.length; i++) {
    dayTotalNetWt += allBills[i].nettweight;
    dayTotalKissanAmount += (allBills[i].kissanamt).round();
    dayTotalMandiTax += allBills[i].mtax;

    grandTotalNetWt += allBills[i].nettweight;
    grandTotalKissanAmount += (allBills[i].kissanamt).round();
    grandTotalMandiTax += allBills[i].mtax;
    tableRows.add(TableRow(
        decoration: const BoxDecoration(
            border: Border(
          bottom: BorderSide(width: 1, color: Colors.black),
        )),
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              (i + 1).toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: "sans", fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              allBills[i].board,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              allBills[i].bhuktanpk,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
            child: Text(
              allBills[i].date,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          //kissan name
          allBills[i].isMultikissan
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  for (MultikissanModel kissan in allBills[i].multiKissanList!)
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 5, right: 5, left: 5),
                      child: Text(
                        kissan.name,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: kissan.iskelagroup ? Colors.green : null),
                      ),
                    ),
                  Divider(
                    color: Colors.grey.shade700,
                    height: 1,
                    thickness: .5,
                  ),
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Text(
                            "JANTRI TOTAL",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]),
                  Divider(
                    color: Colors.grey.shade700,
                    height: 1,
                    thickness: .5,
                  ),
                  DateFormat("dd-MM-yyyy")
                          .parse(allBills[i == allBills.length - 1 ? i : i + 1]
                              .date)
                          .isAfter(
                              DateFormat("dd-MM-yyyy").parse(allBills[i].date))
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Padding(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Text(
                                  "DAY TOTAL",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )
                            ])
                      : const SizedBox(height: 0)
                ])
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, right: 0, left: 5),
                    child: Text(
                      allBills[i].selectedkissan,
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade700,
                    height: 1,
                    thickness: .5,
                  ),
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Text(
                            "JANTRI TOTAL",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]),
                  Divider(
                    color: Colors.grey.shade700,
                    height: 1,
                    thickness: .5,
                  ),
                  DateFormat("dd-MM-yyyy")
                          .parse(allBills[i == allBills.length - 1 ? i : i + 1]
                              .date)
                          .isAfter(
                              DateFormat("dd-MM-yyyy").parse(allBills[i].date))
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Padding(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Text(
                                  "DAY TOTAL",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )
                            ])
                      : const SizedBox(height: 0)
                ]),
          //kissan name
          //nett wt
          allBills[i].isMultikissan
              ? Column(
                  children: [
                    for (MultikissanModel kissan
                        in allBills[i].multiKissanList!)
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, right: 5, left: 5),
                        child: Text(
                          kissan.netwt.toStringAsFixed(2),
                          textAlign: TextAlign.start,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    Divider(
                      color: Colors.grey.shade700,
                      height: 1,
                      thickness: .5,
                    ),
                    //total netwt Jantri
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 5, right: 5, left: 5),
                      child: Text(
                        allBills[i].nettweight.toStringAsFixed(2),
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(
                      color: Colors.grey.shade700,
                      height: 1,
                      thickness: .5,
                    ),
                    DateFormat("dd-MM-yyyy")
                            .parse(
                                allBills[i == allBills.length - 1 ? i : i + 1]
                                    .date)
                            .isAfter(DateFormat("dd-MM-yyyy")
                                .parse(allBills[i].date))
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: Text(
                                    dayTotalNetWt.toStringAsFixed(2),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ])
                        : const SizedBox(height: 0)
                  ],
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 5, right: 5, left: 5),
                      child: Text(
                        allBills[i].nettweight.toStringAsFixed(2),
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Divider(
                      color: Colors.grey.shade700,
                      height: 1,
                      thickness: .5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 5, right: 5, left: 5),
                      child: Text(
                        allBills[i].nettweight.toStringAsFixed(2),
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(
                      color: Colors.grey.shade700,
                      height: 1,
                      thickness: .5,
                    ),
                    DateFormat("dd-MM-yyyy")
                            .parse(
                                allBills[i == allBills.length - 1 ? i : i + 1]
                                    .date)
                            .isAfter(DateFormat("dd-MM-yyyy")
                                .parse(allBills[i].date))
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: Text(
                                    dayTotalNetWt.toStringAsFixed(2),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ])
                        : const SizedBox(height: 0)
                  ],
                ),
          allBills[i].isMultikissan
              ? Column(children: [
                  for (MultikissanModel kissan in allBills[i].multiKissanList!)
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 5, right: 5, left: 5),
                      child: Text(
                        kissan.bhav.toStringAsFixed(2),
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  Divider(
                    color: Colors.grey.shade700,
                    height: 1,
                    thickness: .5,
                  ),
                ])
              : Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, right: 5, left: 5),
                    child: Text(
                      allBills[i].bhav!.toStringAsFixed(2),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade700,
                    height: 1,
                    thickness: .5,
                  ),
                ]),
          allBills[i].isMultikissan
              ? Column(children: [
                  for (MultikissanModel kissan in allBills[i].multiKissanList!)
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 5, right: 5, left: 5),
                      child: Text(
                        kissan.amount.toStringAsFixed(2),
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  Divider(
                    color: Colors.grey.shade700,
                    height: 1,
                    thickness: .5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, right: 5, left: 5),
                    child: Text(
                      allBills[i].kissanamt.toStringAsFixed(2),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade700,
                    height: 1,
                    thickness: .5,
                  ),
                  DateFormat("dd-MM-yyyy")
                          .parse(allBills[i == allBills.length - 1 ? i : i + 1]
                              .date)
                          .isAfter(
                              DateFormat("dd-MM-yyyy").parse(allBills[i].date))
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Text(
                                  NumberFormat('#,##0.00')
                                      .format(dayTotalKissanAmount),
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ])
                      : const SizedBox(height: 0)
                ])
              : Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, right: 5, left: 5),
                    child: Text(
                      allBills[i].kissanamt.toStringAsFixed(2),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade700,
                    height: 1,
                    thickness: .5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, right: 5, left: 5),
                    child: Text(
                      allBills[i].kissanamt.toStringAsFixed(2),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade700,
                    height: 1,
                    thickness: .5,
                  ),
                  DateFormat("dd-MM-yyyy")
                          .parse(allBills[i == allBills.length - 1 ? i : i + 1]
                              .date)
                          .isAfter(
                              DateFormat("dd-MM-yyyy").parse(allBills[i].date))
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Text(
                                  NumberFormat('#,##0.00')
                                      .format(dayTotalKissanAmount),
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ])
                      : const SizedBox(height: 0)
                ]),
          allBills[i].isMultikissan
              ? Column(children: [
                  for (MultikissanModel kissan in allBills[i].multiKissanList!)
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 5, right: 5, left: 5),
                      child: Text(
                        NumberFormat('#,##0.00')
                            .format((kissan.amount * 0.01).round()),
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  Divider(
                    color: Colors.grey.shade700,
                    height: 1,
                    thickness: .5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, right: 5, left: 5),
                    child: Text(
                      NumberFormat('#,##0.00').format(allBills[i].mtax),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade700,
                    height: 1,
                    thickness: .5,
                  ),
                  DateFormat("dd-MM-yyyy")
                          .parse(allBills[i == allBills.length - 1 ? i : i + 1]
                              .date)
                          .isAfter(
                              DateFormat("dd-MM-yyyy").parse(allBills[i].date))
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Text(
                                  NumberFormat('#,##0.00')
                                      .format(dayTotalMandiTax),
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ])
                      : const SizedBox(height: 0)
                ])
              : Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, right: 5, left: 5),
                    child: Text(
                      NumberFormat('#,##0.00').format(allBills[i].mtax),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade700,
                    height: 1,
                    thickness: .5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, right: 5, left: 5),
                    child: Text(
                      NumberFormat('#,##0.00').format(allBills[i].mtax),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade700,
                    height: 1,
                    thickness: .5,
                  ),
                  DateFormat("dd-MM-yyyy")
                          .parse(allBills[i == allBills.length - 1 ? i : i + 1]
                              .date)
                          .isAfter(
                              DateFormat("dd-MM-yyyy").parse(allBills[i].date))
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Text(
                                  NumberFormat('#,##0.00')
                                      .format(dayTotalMandiTax),
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ])
                      : const SizedBox(height: 0)
                ]),
        ]));

    //making it zero for next dates
    DateFormat("dd-MM-yyyy")
            .parse(allBills[i == allBills.length - 1 ? i : i + 1].date)
            .isAfter(DateFormat("dd-MM-yyyy").parse(allBills[i].date))
        ? {
            dayTotalNetWt = 0,
            dayTotalKissanAmount = 0,
            dayTotalMandiTax = 0,
          }
        : null;
    //making it zero for next dates
  }

  //adding rows
  //last rows
  tableRows.insert(
      tableRows.length,
      TableRow(
          decoration: const BoxDecoration(
              border: Border(
            bottom: BorderSide(width: 1, color: Colors.black),
            top: BorderSide(width: 1, color: Colors.black),
          )),
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "",
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontFamily: "sans", fontWeight: FontWeight.w500),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: Text(
                '',
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
              child: Text(
                '',
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
              child: Text(
                '',
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Column(children: [
              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
                child: Text(
                  'DAY TOTAL',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Divider(height: 1, thickness: 1),
              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
                child: Text(
                  'GRAND TOTAL',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            Column(children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
                child: Text(
                  dayTotalNetWt.toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 1, thickness: 1),
              Padding(
                padding:
                    const EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
                child: Text(
                  grandTotalNetWt.toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            const Column(children: [
              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
                child: Text(
                  "",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
                child: Text(
                  "",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            Column(children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
                child: Text(
                  NumberFormat('#,##0.00').format(dayTotalKissanAmount),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 1, thickness: 1),
              Padding(
                padding:
                    const EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
                child: Text(
                  NumberFormat('#,##0.00').format(grandTotalKissanAmount),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            Column(children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
                child: Text(
                  NumberFormat('#,##0.00').format(dayTotalMandiTax),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 1, thickness: 1),
              Padding(
                padding:
                    const EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
                child: Text(
                  NumberFormat('#,##0.00').format(grandTotalMandiTax),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ]),
          ]));
  //last rows

  return Table(
    columnWidths: const {
      0: FractionColumnWidth(0.05),
    },
    border: TableBorder(
      // Horizontal borders
      verticalInside: BorderSide(color: Colors.grey.shade300, width: 1),
    ),
    children: tableRows,
  );
}
