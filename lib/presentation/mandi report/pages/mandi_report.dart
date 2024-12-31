import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kelawin/Models/billmodel.dart';
import 'package:kelawin/service/printing_invoices/Printinvoice.dart';

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

class _MandiReportState extends State<MandiReport> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  @override
  void initState() {
    _getBills();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Mandi Reports",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                        Text("dateeeeeee"),
                      ],
                    ),
                    Row(
                      children: filters.map((filter) {
                        bool isSelected = selectedFilter == null
                            ? false
                            : selectedFilter!["filter"] == filter["filter"];
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
                                    color:
                                        isSelected ? Colors.blue : Colors.white,
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.blueAccent
                                          : Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
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
                            fromDate = await _selectDate(context, fromDate);

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
                            selectedFilter = null;
                            toDate = await _selectDate(context, toDate);

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
                    Row(
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20),
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            onPressed: () async {
                              List<BillModel> foundList = [];
                              if (selectedFilter == null) {
                                foundList = await _getReport(fromDate, toDate);
                              } else {
                                foundList = await _getReport(
                                    selectedFilter!["value"], DateTime.now());
                              }

                              await PrintDocuments()
                                  .printMandiReports(foundList);
                            },
                            child: const Text(
                              "Get Report",
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    ),
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

Future _selectDate(BuildContext context, DateTime initialDate) async {
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
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
  if (picked != null && picked != DateTime.now()) {
    return picked;
  } else {
    return DateTime.now();
  }
}

Future _getBills() async {
  allBills = await GetBillFromServer().getAllbills();
  allBills = await _sortingOfBills(allBills);
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
