import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kelawin/Modules/Addaccount.dart';
import 'package:kelawin/Modules/Homepage.dart';
import 'package:kelawin/presentation/mandi%20report/pages/mandi_report.dart';
import 'package:kelawin/presentation/user_operations/pages/read_users.dart';

import '../presentation/billoperations/pages/read_bill.dart';
import '../presentation/khatabook/page/read_khata.dart';

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
              setState(() {
                _selectedindex = value;
              });
            },
            controller: pageController,
            scrollDirection: Axis.vertical,
            children: const [
              Homepage(),
              Addaccount(),
              ReadBill(),
              ReadUsers(),
              // Editaccount(),
              // Khatabook(),
              ReadKhata(),
              MandiReport(),
            ],
          ))
        ],
      ),
    );
  }
}
