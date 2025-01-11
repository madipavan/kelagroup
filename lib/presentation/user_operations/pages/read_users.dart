import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kelawin/Models/user_model.dart';

class ReadUsers extends StatefulWidget {
  const ReadUsers({super.key});

  @override
  State<ReadUsers> createState() => _ReadUsersState();
}

class _ReadUsersState extends State<ReadUsers> {
  bool _isLoading = true;
  late List<UserModel> allUsers;
  late List<UserModel> foundList;
  Map? selectedFilter;
  List<Map<String, dynamic>> filters = [
    {
      "filter": "Vyapari",
      "value": "vyapari",
    },
    {"filter": "Kissan", "value": "kissan"},
    {"filter": "KelaGroup", "value": "kelagroup"},
  ];
  @override
  void initState() {
    _getBills();
    super.initState();
  }

  Future _getBills() async {
    allUsers = [];

    _isLoading = false;
    if (mounted) {
      setState(() {
        foundList = allUsers;

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
                              const Text("Users Details",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                              const Spacer(),
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
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 20),
                                      backgroundColor: const Color(0xff0073dd),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  onPressed: () async {},
                                  child: const Text(
                                    "Get Users",
                                    style: TextStyle(color: Colors.white),
                                  )),
                              const Spacer(),
                              Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    onChanged: (value) async {},
                                    cursorColor: Colors.grey,
                                    decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.search),
                                        label: const Text(
                                          "Search Users",
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
                                    'UserId',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'Name',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'Address',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'City',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'State',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'Phone',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'Email',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'Company',
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
                                      foundList[i].name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: "sans",
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      foundList[i].name.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: "sans",
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      foundList[i].name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: "sans",
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      foundList[i].name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: "sans",
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      foundList[i].name.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: "sans",
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      foundList[i].name.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: "sans",
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      foundList[i].name.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: "sans",
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      foundList[i].name.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: "sans",
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      foundList[i].name.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: "sans",
                                          fontWeight: FontWeight.w600),
                                    ),
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
