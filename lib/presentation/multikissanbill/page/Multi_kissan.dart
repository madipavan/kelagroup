import 'package:flutter/material.dart';
import 'package:kelawin/presentation/multikissanbill/provider/multi_kissan_pro.dart';
import 'package:kelawin/presentation/multikissanbill/widget/custom_dropdown.dart';
import 'package:kelawin/presentation/multikissanbill/widget/customicon_btn.dart';
import 'package:kelawin/presentation/multikissanbill/widget/kgpercent_dropdowm.dart';
import 'package:kelawin/presentation/multikissanbill/widget/text_with_feild.dart';
import 'package:kelawin/presentation/multikissanbill/widget/typeahead.dart';
import 'package:kelawin/presentation/multikissanbill/widget/weight_container.dart';
import 'package:provider/provider.dart';

import '../widget/kelagroup_textfeild.dart';

class MultiKissan extends StatefulWidget {
  final ScrollController controller;
  const MultiKissan({super.key, required this.controller});

  @override
  State<MultiKissan> createState() => _MultiKissanState();
}

class _MultiKissanState extends State<MultiKissan> {
  List<bool> pativisible = [];
  List<bool> dandavisible = [];
  List<bool> wastagevisible = [];
  List<bool> isKelagroupvisible = [];

  List<String> kelaGrouphammalipercentList = [];
  List<String> kelaGroupcommissionpercentList = [];
  List<String> kelaGroupmtaxpercentList = [];
  List<String> kelaGrouptcspercentList = [];

  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;
    return Consumer<MultiKissanPro>(
      builder: (context, value, child) => value.multikissan.isEmpty
          ? const Center(
              child: Text(
              "Add Kissan!",
              style: TextStyle(fontWeight: FontWeight.w500),
            ))
          : ListView.builder(
              controller: widget.controller,
              scrollDirection: Axis.vertical,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: value.multikissan.length,
              itemBuilder: (context, index) {
                bool pati = true;
                bool danda = false;
                bool wastage = false;
                bool isKelagroup = false;

                String kelaGrouphammalipercent = "20";
                String kelaGroupcommissionpercent = "15";
                String kelaGroupmtaxpercent = "1";
                String kelaGrouptcspercent = "0";
                //
                pativisible.add(pati);
                dandavisible.add(danda);
                wastagevisible.add(wastage);
                isKelagroupvisible.add(isKelagroup);
                //

                //
                kelaGrouphammalipercentList.add(kelaGrouphammalipercent);
                kelaGroupcommissionpercentList.add(kelaGroupcommissionpercent);
                kelaGroupmtaxpercentList.add(kelaGroupmtaxpercent);
                kelaGrouptcspercentList.add(kelaGrouptcspercent);
                //
                //resettlement becoz when we remove old one the values remains same
                if (value.multikissan[index]["unit"] == "Loose") {
                  pativisible[index] = true;
                  dandavisible[index] = false;
                  wastagevisible[index] = false;
                } else if (value.multikissan[index]["unit"] == "Carate") {
                  pativisible[index] = true;
                  dandavisible[index] = true;

                  wastagevisible[index] = false;
                } else if (value.multikissan[index]["unit"] == "Panje") {
                  pativisible[index] = true;
                  dandavisible[index] = true;
                  wastagevisible[index] = false;
                } else if (value.multikissan[index]["unit"] == "Box") {
                  pativisible[index] = true;
                  dandavisible[index] = true;
                  wastagevisible[index] = true;
                }

                //
                return SizedBox(
                  height: Height * 0.55,
                  width: Width * 0.35,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black87),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Center(
                                    child: Text(
                                      (index + 1).toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )),
                            SizedBox(
                              height: Height * 0.05,
                              width: Width * 0.15,
                              child: isKelagroupvisible[index]
                                  ? KelagroupTextfeild(
                                      index: index,
                                      typecontroller: value.multikissan[index]
                                          ["name"],
                                    )
                                  : Typeahead(
                                      index: index,
                                      typecontroller: value.multikissan[index]
                                          ["name"],
                                    ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 229, 241, 248),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              height: Height * 0.05,
                              width: Width * 0.05,
                              child: DropdownButton(
                                padding: const EdgeInsets.all(8),
                                iconSize: Width * 0.01,
                                underline: const Text(""),
                                isExpanded: true,
                                borderRadius: BorderRadius.circular(5),
                                dropdownColor: Colors.white,
                                style: TextStyle(
                                    fontFamily: "sans",
                                    fontSize: Width * 0.01,
                                    color: Colors.black87),
                                value:
                                    value.multikissan[index]["unit"].toString(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    value.multikissan[index]["unit"] =
                                        newValue!;

                                    if (value.multikissan[index]["unit"] ==
                                        "Loose") {
                                      pativisible[index] = true;
                                      dandavisible[index] = false;
                                      wastagevisible[index] = false;
                                    } else if (value.multikissan[index]
                                            ["unit"] ==
                                        "Carate") {
                                      pativisible[index] = true;
                                      dandavisible[index] = true;

                                      wastagevisible[index] = false;
                                    } else if (value.multikissan[index]
                                            ["unit"] ==
                                        "Panje") {
                                      pativisible[index] = true;
                                      dandavisible[index] = true;
                                      wastagevisible[index] = false;
                                    } else if (value.multikissan[index]
                                            ["unit"] ==
                                        "Box") {
                                      pativisible[index] = true;
                                      dandavisible[index] = true;
                                      wastagevisible[index] = true;
                                    }
                                  });
                                },
                                items: <String>[
                                  'Loose',
                                  'Carate',
                                  'Panje',
                                  'Box'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            Tooltip(
                              message: "Kelagroup",
                              child: Switch(
                                value: isKelagroupvisible[index],
                                activeColor: Colors.black,
                                activeTrackColor:
                                    const Color.fromARGB(255, 7, 153, 2),
                                onChanged: (val) {
                                  setState(() {
                                    isKelagroupvisible[index] = val;
                                    value.multikissan[index]["iskelagroup"] =
                                        isKelagroupvisible[index];
                                  });
                                },
                              ),
                            ),
                            CustomIconbtn(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                value.removeintolist(index);

                                value.scrollToEnd(widget.controller);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    "Removed user",
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontSize: Width * 0.01,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ));
                              },
                            )
                          ],
                        ),
                        Visibility(
                          visible: pativisible[index],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextwithFeild(
                                  controller: value.multikissan[index]["pati"],
                                  text: "Pati"),
                              KgpercentDropdowm(
                                  text: "PatiUnit",
                                  dropdownval: value.multikissan[index]
                                      ["patiunit"],
                                  onchanged: (String? val) {
                                    setState(() {
                                      value.multikissan[index]["patiunit"] =
                                          val;
                                    });
                                  }),
                              WeightContainer(
                                  text: "Pati Wt",
                                  val: value.multikissan[index]["patiwt"])
                            ],
                          ),
                        ),
                        Visibility(
                          visible: dandavisible[index],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextwithFeild(
                                  controller: value.multikissan[index]["danda"],
                                  text: "Danda"),
                              KgpercentDropdowm(
                                  text: "DandaUnit",
                                  dropdownval: value.multikissan[index]
                                      ["dandaunit"],
                                  onchanged: (String? val) {
                                    setState(() {
                                      value.multikissan[index]["dandaunit"] =
                                          val;
                                    });
                                  }),
                              WeightContainer(
                                  text: "Danda Wt",
                                  val: value.multikissan[index]["dandawt"])
                            ],
                          ),
                        ),
                        Visibility(
                          visible: wastagevisible[index],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextwithFeild(
                                  controller: value.multikissan[index]
                                      ["wastage"],
                                  text: "Wastage"),
                              KgpercentDropdowm(
                                text: "WastageUnit",
                                onchanged: (String? val) {
                                  setState(() {
                                    value.multikissan[index]["wastageunit"] =
                                        val;
                                  });
                                },
                                dropdownval: value.multikissan[index]
                                    ["wastageunit"],
                              ),
                              WeightContainer(
                                  text: "Wastage Wt",
                                  val: value.multikissan[index]["wastagewt"])
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextwithFeild(
                                controller: value.multikissan[index]["bhav"],
                                text: "Bhav"),
                            TextwithFeild(
                                controller: value.multikissan[index]["weight"],
                                text: "Weight(Q)"),
                            WeightContainer(
                                val: value.multikissan[index]["netwt"],
                                text: "Net Wt(Q)")
                          ],
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: Width * 0.018),
                          child: Row(
                            children: [
                              TextwithFeild(
                                  controller: value.multikissan[index]
                                      ["lungar"],
                                  text: "Lungar"),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: Width * 0.018),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${value.multikissan[index]["amount"]}₹",
                                style: TextStyle(
                                    fontSize: Width * 0.015,
                                    fontWeight: FontWeight.bold),
                              ),
                              Visibility(
                                visible: isKelagroupvisible[index],
                                child: Row(
                                  children: [
                                    Tooltip(
                                      message: "Hammali",
                                      child: CustomDropdown(
                                        val: kelaGrouphammalipercentList[index],
                                        onChanged: (val) {
                                          setState(() {
                                            kelaGrouphammalipercentList[index] =
                                                val;
                                          });
                                        },
                                        percentlist: <String>[
                                          '5',
                                          '10',
                                          '15',
                                          '20',
                                          '25',
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
                                      width: 15,
                                    ),
                                    Tooltip(
                                      message: "Commission",
                                      child: CustomDropdown(
                                        val: kelaGroupcommissionpercentList[
                                            index],
                                        onChanged: (val) {
                                          setState(() {
                                            kelaGrouphammalipercentList[index] =
                                                val;
                                          });
                                        },
                                        percentlist: <String>[
                                          '5',
                                          '10',
                                          '15',
                                          '20',
                                          '25',
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
                                      width: 15,
                                    ),
                                    Tooltip(
                                      message: "Mtax",
                                      child: CustomDropdown(
                                        val: kelaGroupmtaxpercentList[index],
                                        onChanged: (val) {
                                          setState(() {
                                            kelaGroupmtaxpercentList[index] =
                                                val;
                                          });
                                        },
                                        percentlist: <String>[
                                          '1',
                                          '2',
                                          '3',
                                          '4',
                                          '5',
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      minimumSize:
                                          Size(Width * 0.06, Height * 0.05),
                                      backgroundColor: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      if (value.multikissan[index]["unit"] ==
                                          "Loose") {
                                        value.loosecalc(index);
                                      }
                                      if (value.multikissan[index]["unit"] ==
                                          "Carate") {
                                        value.caratecalc(index);
                                      }
                                      if (value.multikissan[index]["unit"] ==
                                          "Panje") {
                                        value.caratecalc(index);
                                      }
                                      if (value.multikissan[index]["unit"] ==
                                          "Box") {
                                        value.boxcalc(index);
                                      }

                                      if (isKelagroupvisible[index]) {
                                        value.kelagroupcalc(
                                            index,
                                            kelaGrouphammalipercentList[index],
                                            kelaGroupcommissionpercentList[
                                                index],
                                            kelaGroupmtaxpercentList[index]);
                                      }
                                    });
                                  },
                                  child: const Text(
                                    "Get Wt",
                                    style: TextStyle(color: Colors.white),
                                  ))
                            ],
                          ),
                        ),
                        const Divider()
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
