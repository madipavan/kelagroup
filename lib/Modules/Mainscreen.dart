import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kelawin/Modules/Addaccount.dart';
import 'package:kelawin/Modules/CreateBill.dart';
import 'package:kelawin/Modules/Editaccount.dart';
import 'package:kelawin/Modules/Homepage.dart';
import 'package:kelawin/Modules/Updatebill.dart';
import 'package:kelawin/presentation/khatabook/page/Khatabook.dart';
import 'package:kelawin/presentation/mandi%20report/pages/mandi_report.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

DateTime now = DateTime.now();
var date = DateFormat('dd-MM-yyyy').format(now);
var time = DateFormat('jms').format(now);

class _MainscreenState extends State<Mainscreen> {
  int _selectedindex = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updatetime();
  }

  void _updatetime() {
    setState(() {
      now = DateTime.now();
      date = DateFormat('dd-MM-yyyy').format(now);
      time = DateFormat('jms').format(now);
    });

    Future.delayed(const Duration(seconds: 1), _updatetime);
  }

  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 222, 222, 248),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Height * 0.05),
        child: AppBar(
          surfaceTintColor: const Color(0xfffcfcfc),
          scrolledUnderElevation: 10,
          shadowColor: Colors.black,
          elevation: 10,
          backgroundColor: const Color(0xfffcfcfc),
          leadingWidth: Width * 0.05,
          leading: Container(
            height: Height * 0.1,
            width: Width * 0.06,
            color: Colors.black87,
            child: const Center(child: Text("Logo")),
          ),
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: Width * 0.02,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    height: Height * 0.04,
                    width: Width * 0.2,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_month),
                                SizedBox(width: Width * 0.01),
                                Text(
                                  date,
                                  style: const TextStyle(
                                      fontFamily: "sans",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            "|",
                            style: TextStyle(
                                fontFamily: "sans",
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.access_time),
                                SizedBox(width: Width * 0.01),
                                Text(
                                  time.toString(),
                                  style: const TextStyle(
                                      fontFamily: "sans",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(Width * 0.001),
                    height: Height * 0.05,
                    width: Width * 0.4,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      children: [
                        SizedBox(
                          width: Width * 0.3,
                          child: TextField(
                            enabled: false,
                            cursorColor: Colors.black,
                            cursorOpacityAnimates: true,
                            mouseCursor: WidgetStateMouseCursor.textable,
                            style: const TextStyle(
                                fontFamily: "sans",
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(5),
                                hintText: "Search Bill...",
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: const BorderSide(
                                        color: Color(0xff191a1f))),
                                prefixIcon: const Icon(Icons.search_sharp),
                                prefixIconColor: const Color(0xff191a1f),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                )),
                          ),
                        ),
                        SizedBox(
                          width: Width * 0.01,
                        ),
                        SizedBox(
                          height: Height * 0.05,
                          width: Width * 0.08,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlue),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CreateBill()));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.add_task_outlined,
                                    color: Colors.white,
                                    size: Width * 0.01,
                                  ),
                                  SizedBox(
                                    width: Width * 0.004,
                                  ),
                                  Text(
                                    "Create Bill",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.w500,
                                        fontSize: Width * 0.005),
                                  )
                                ],
                              )),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: const Color(0xfffcfcfc),
                    height: Height * 0.04,
                    width: Width * 0.2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Icon(Icons.notifications_none_rounded),
                        Container(
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Dipesh Amode",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "sans",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Row(
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(130)),
            height: Height,
            width: Width * 0.05,
            child: NavigationRail(
              indicatorColor: Colors.lightBlue,
              backgroundColor: Colors.black87,
              labelType: NavigationRailLabelType.all,
              selectedIndex: _selectedindex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedindex = index;
                  pageController.animateToPage(_selectedindex,
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeInOutCubicEmphasized);
                });
              },
              destinations: [
                NavigationRailDestination(
                    icon: const Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Home",
                      style: TextStyle(
                          fontFamily: "sans",
                          color: Colors.white,
                          fontSize: Width * 0.007),
                    )),
                NavigationRailDestination(
                    icon: const Icon(
                      Icons.person_add,
                      color: Colors.white,
                    ),
                    label: Text("Add Account",
                        style: TextStyle(
                            fontFamily: "sans",
                            color: Colors.white,
                            fontSize: Width * 0.005))),
                NavigationRailDestination(
                    icon: const Icon(
                      Icons.addchart_rounded,
                      color: Colors.white,
                    ),
                    label: Text("Bills",
                        style: TextStyle(
                            fontFamily: "sans",
                            color: Colors.white,
                            fontSize: Width * 0.007))),
                NavigationRailDestination(
                    icon: const Icon(
                      Icons.person_pin,
                      color: Colors.white,
                    ),
                    label: Text("Users",
                        style: TextStyle(
                            fontFamily: "sans",
                            color: Colors.white,
                            fontSize: Width * 0.007))),
                NavigationRailDestination(
                    icon: const Icon(
                      Icons.menu_book,
                      color: Colors.white,
                    ),
                    label: Text("KhataBook",
                        style: TextStyle(
                            fontFamily: "sans",
                            color: Colors.white,
                            fontSize: Width * 0.007))),
                NavigationRailDestination(
                    icon: const Icon(
                      Icons.library_books,
                      color: Colors.white,
                    ),
                    label: Text("M Report",
                        style: TextStyle(
                            fontFamily: "sans",
                            color: Colors.white,
                            fontSize: Width * 0.007))),
              ],
            ),
          ),
          Expanded(
              child: PageView(
            onPageChanged: (value) {
              print(value);
              setState(() {
                _selectedindex = value;
              });
            },
            controller: pageController,
            scrollDirection: Axis.vertical,
            children: const [
              Homepage(),
              Addaccount(),
              Updatebill(),
              Editaccount(),
              Khatabook(),
              MandiReport(),
            ],
          ))
        ],
      ),
    );
  }
}
