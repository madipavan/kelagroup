import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodel/multikissanbillcalc/multi_grandtotal.dart';
import '../../user_operations/widgets/user_textfield.dart';

class GrandtotalMultikissan extends StatefulWidget {
  const GrandtotalMultikissan({super.key});

  @override
  State<GrandtotalMultikissan> createState() => _GrandtotalMultikissanState();
}

class _GrandtotalMultikissanState extends State<GrandtotalMultikissan> {
  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;
    return Consumer<MultiGrandtotal>(
      builder: (context, value, child) => Container(
        // margin: EdgeInsets.only(top: Width * 0.02),
        height: Height * 0.4,
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
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Nett Weight",
                        style: TextStyle(
                            fontFamily: "sans",
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff2278fd),
                            fontSize: Width * 0.01),
                      ),
                      Text(
                        "${value.nettWett} Q",
                        style: TextStyle(
                            fontFamily: "sans",
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: Width * 0.01),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Kissan Amount",
                        style: TextStyle(
                            fontFamily: "sans",
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff2278fd),
                            fontSize: Width * 0.01),
                      ),
                      Text(
                        "₹${value.kissanAmount}",
                        style: TextStyle(
                            fontFamily: "sans",
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: Width * 0.01),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: Height * 0.04,
                        width: Width * 0.08,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Hammali",
                              style: TextStyle(
                                  fontFamily: "sans",
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff2278fd),
                                  fontSize: Width * 0.01),
                            ),
                            SizedBox(
                              width: Width * 0.01,
                            ),
                            Expanded(
                              flex: 1,
                              child: UserTextfield(
                                  onChanged: (val) {
                                    value.hammalipercent = int.parse(val);
                                  },
                                  label: "%",
                                  controller: value.hammaliControllerPercent,
                                  isAmount: true),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "₹${value.hammali}",
                        style: TextStyle(
                            fontFamily: "sans",
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: Width * 0.01),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: Height * 0.04,
                        width: Width * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Commission",
                              style: TextStyle(
                                  fontFamily: "sans",
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff2278fd),
                                  fontSize: Width * 0.01),
                            ),
                            SizedBox(
                              width: Width * 0.01,
                            ),
                            Expanded(
                              flex: 1,
                              child: UserTextfield(
                                  onChanged: (val) {
                                    value.commissionpercent = int.parse(val);
                                  },
                                  label: "%",
                                  controller: value.commissionControllerPercent,
                                  isAmount: true),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "₹${value.commission}",
                        style: TextStyle(
                            fontFamily: "sans",
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: Width * 0.01),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: Height * 0.04,
                        width: Width * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "M TAX",
                              style: TextStyle(
                                  fontFamily: "sans",
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff2278fd),
                                  fontSize: Width * 0.01),
                            ),
                            SizedBox(
                              width: Width * 0.01,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 229, 241, 248),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              height: Height * 0.035,
                              width: Width * 0.03,
                              child: DropdownButton(
                                padding: EdgeInsets.all(Width * 0.0025),
                                iconSize: Width * 0.01,
                                underline: const Text(""),
                                isExpanded: true,
                                dropdownColor: Colors.white,
                                style: TextStyle(
                                    fontFamily: "sans",
                                    fontSize: Width * 0.01,
                                    color: Colors.black87),
                                value: value.mtaxpercent,
                                onChanged: (int? newValue) {
                                  setState(() {
                                    value.mtaxpercent = newValue!;
                                  });
                                },
                                items: <int>[
                                  1,
                                  2,
                                  3,
                                  4,
                                  5,
                                ].map<DropdownMenuItem<int>>((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(value.toString()),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "₹${value.mtax}",
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sub Total - ",
                        style: TextStyle(
                            fontFamily: "sans",
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff2278fd),
                            fontSize: Width * 0.01),
                      ),
                      Text(
                        "₹${value.subTotal}",
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
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sub Total",
                        style: TextStyle(
                            fontFamily: "sans",
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff2278fd),
                            fontSize: Width * 0.01),
                      ),
                      Text(
                        "₹${value.subTotal}",
                        style: TextStyle(
                            fontFamily: "sans",
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: Width * 0.01),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: Height * 0.04,
                        width: Width * 0.08,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "OT",
                              style: TextStyle(
                                  fontFamily: "sans",
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff2278fd),
                                  fontSize: Width * 0.01),
                            ),
                            SizedBox(
                              width: Width * 0.01,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 229, 241, 248),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              height: Height * 0.035,
                              width: Width * 0.03,
                              child: DropdownButton(
                                padding: EdgeInsets.all(Width * 0.0025),
                                iconSize: Width * 0.01,
                                underline: const Text(""),
                                isExpanded: true,
                                dropdownColor: Colors.white,
                                style: TextStyle(
                                    fontFamily: "sans",
                                    fontSize: Width * 0.01,
                                    color: Colors.black87),
                                value: value.ot,
                                onChanged: (int? newValue) {
                                  setState(() {
                                    value.ot = newValue!;
                                  });
                                },
                                items: <int>[40, 50, 60, 70, 80, 90]
                                    .map<DropdownMenuItem<int>>((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(value.toString()),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "₹${value.ot}",
                        style: TextStyle(
                            fontFamily: "sans",
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: Width * 0.01),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: Height * 0.04,
                        width: Width * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "TCS",
                              style: TextStyle(
                                  fontFamily: "sans",
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff2278fd),
                                  fontSize: Width * 0.01),
                            ),
                            SizedBox(
                              width: Width * 0.01,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 229, 241, 248),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              height: Height * 0.035,
                              width: Width * 0.03,
                              child: DropdownButton(
                                padding: EdgeInsets.all(Width * 0.0025),
                                iconSize: Width * 0.01,
                                underline: const Text(""),
                                isExpanded: true,
                                dropdownColor: Colors.white,
                                style: TextStyle(
                                    fontFamily: "sans",
                                    fontSize: Width * 0.01,
                                    color: Colors.black87),
                                value: value.tcspercent,
                                onChanged: (int? newValue) {
                                  setState(() {
                                    value.tcspercent = newValue!;
                                  });
                                },
                                items: <int>[
                                  0,
                                  1,
                                  2,
                                  3,
                                  4,
                                  5,
                                ].map<DropdownMenuItem<int>>((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(value.toString()),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        value.tcs.toString(),
                        style: TextStyle(
                            fontFamily: "sans",
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: Width * 0.01),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: Height * 0.04,
                        width: Width * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "TDS",
                              style: TextStyle(
                                  fontFamily: "sans",
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff2278fd),
                                  fontSize: Width * 0.01),
                            ),
                            SizedBox(
                              width: Width * 0.01,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 229, 241, 248),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              height: Height * 0.035,
                              width: Width * 0.03,
                              child: DropdownButton(
                                padding: EdgeInsets.all(Width * 0.0025),
                                iconSize: Width * 0.01,
                                underline: const Text(""),
                                isExpanded: true,
                                dropdownColor: Colors.white,
                                style: TextStyle(
                                    fontFamily: "sans",
                                    fontSize: Width * 0.01,
                                    color: Colors.black87),
                                value: value.tdspercent,
                                onChanged: (int? newValue) {
                                  setState(() {
                                    value.tdspercent = newValue!;
                                  });
                                },
                                items: <int>[
                                  0,
                                  1,
                                  2,
                                  3,
                                  4,
                                  5,
                                ].map<DropdownMenuItem<int>>((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(value.toString()),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        value.tds.toString(),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Grand Total - ",
                        style: TextStyle(
                            fontFamily: "sans",
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff2278fd),
                            fontSize: Width * 0.01),
                      ),
                      Text(
                        "₹${value.grandTotal}",
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
    );
  }
}

String note = "";
