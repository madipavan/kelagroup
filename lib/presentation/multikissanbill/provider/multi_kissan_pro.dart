import 'dart:core';

import 'package:flutter/material.dart';

class MultiKissanPro extends ChangeNotifier {
  List<Map> multikissan = [];

  static List<Map> multikissanCalclist = [];

  void addintolist() async {
    multikissan.add(await kissan());
    multikissanCalclist = multikissan;
    notifyListeners();
  }

  void removeintolist(index) async {
    multikissan.removeAt(index);
    multikissanCalclist = multikissan;
    notifyListeners();
  }

  Future<Map> kissan() async {
    TextEditingController name = TextEditingController();
    TextEditingController pati = TextEditingController();
    TextEditingController danda = TextEditingController();
    TextEditingController wastage = TextEditingController();
    TextEditingController bhav = TextEditingController();
    TextEditingController weight = TextEditingController();
    TextEditingController lungar = TextEditingController();

    pati.text = "7.5";
    danda.text = "6.0";
    wastage.text = "6.0";

    int kissanid = 0;

    String unit = "Loose";
    String patiunit = "Percent";
    String dandaunit = "Percent";
    String wastageunit = "Percent";

    double patiwt = 0;
    double dandawt = 0;
    double wastagewt = 0;

    double netwt = 0;

    double kissanamt = 0;

    return {
      "name": name,
      "kissan_id": kissanid,
      "unit": unit,
      "pati": pati,
      "patiunit": patiunit,
      "patiwt": patiwt,
      "danda": danda,
      "dandaunit": dandaunit,
      "dandawt": dandawt,
      "wastage": wastage,
      "wastageunit": wastageunit,
      "wastagewt": wastagewt,
      "bhav": bhav,
      "weight": weight,
      "netwt": netwt,
      "lungar": lungar,
      "kissan_amt": kissanamt,
      "iskelagroup": false,
    };
  }

  scrollToEnd(ScrollController scrollController) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  //calc
  loosecalc(index) {
    double mainwt = double.parse(multikissan[index]["weight"].text.toString());
    if (multikissan[index]["patiunit"] == "Percent") {
      multikissan[index]["patiwt"] =
          mainwt * (double.parse(multikissan[index]["pati"].text) / 100);
    } else {
      multikissan[index]["patiwt"] =
          double.parse(multikissan[index]["pati"].text);
    }

    multikissan[index]["netwt"] =
        ((mainwt - multikissan[index]["patiwt"]) / 100).round().toDouble();

    multikissan[index]["kissan_amt"] = (multikissan[index]["netwt"] *
            double.parse(multikissan[index]["bhav"].text.toString()))
        .round()
        .toDouble();
  }

  caratecalc(index) {
    double mainwt = double.parse(multikissan[index]["weight"].text.toString());
    //
    if (multikissan[index]["patiunit"] == "Percent") {
      multikissan[index]["patiwt"] =
          mainwt * (double.parse(multikissan[index]["pati"].text) / 100);
    } else {
      multikissan[index]["patiwt"] =
          double.parse(multikissan[index]["pati"].text);
    }
    //

    if (multikissan[index]["dandaunit"] == "Percent") {
      multikissan[index]["dandawt"] =
          mainwt * (double.parse(multikissan[index]["danda"].text) / 100);
    } else {
      multikissan[index]["dandawt"] =
          double.parse(multikissan[index]["danda"].text);
    }

    multikissan[index]["netwt"] = ((mainwt -
                multikissan[index]["patiwt"] +
                multikissan[index]["dandawt"]) /
            100)
        .round()
        .toDouble();

    multikissan[index]["kissan_amt"] = (multikissan[index]["netwt"] *
            double.parse(multikissan[index]["bhav"].text.toString()))
        .round()
        .toDouble();
  }

  boxcalc(index) {
    double mainwt = double.parse(multikissan[index]["weight"].text.toString());
    //
    if (multikissan[index]["patiunit"] == "Percent") {
      multikissan[index]["patiwt"] =
          mainwt * (double.parse(multikissan[index]["pati"].text) / 100);
    } else {
      multikissan[index]["patiwt"] =
          double.parse(multikissan[index]["pati"].text);
    }
    //

    if (multikissan[index]["dandaunit"] == "Percent") {
      multikissan[index]["dandawt"] =
          mainwt * (double.parse(multikissan[index]["danda"].text) / 100);
    } else {
      multikissan[index]["dandawt"] =
          double.parse(multikissan[index]["danda"].text);
    }
    //

    if (multikissan[index]["wastageunit"] == "Percent") {
      multikissan[index]["wastagewt"] =
          mainwt * (double.parse(multikissan[index]["wastage"].text) / 100);
    } else {
      multikissan[index]["wastagewt"] =
          double.parse(multikissan[index]["wastage"].text);
    }

    multikissan[index]["netwt"] = ((mainwt -
                multikissan[index]["patiwt"] +
                multikissan[index]["dandawt"] +
                multikissan[index]["wastagewt"]) /
            100)
        .round()
        .toDouble();

    multikissan[index]["kissan_amt"] = (multikissan[index]["netwt"] *
            double.parse(multikissan[index]["bhav"].text.toString()))
        .round()
        .toDouble();
  }

  void kelagroupcalc(index, String hammali, String commission, String mtax) {
    double ot = 40;
    multikissan[index]["kissan_amt"] = (multikissan[index]["netwt"] *
            double.parse(multikissan[index]["bhav"].text.toString()))
        .round();

    double hammali0 =
        (multikissan[index]["kissan_amt"] * (double.parse(hammali) / 100))
            .round()
            .toDouble();
    double commission0 =
        (multikissan[index]["kissan_amt"] * (double.parse(commission) / 100))
            .round()
            .toDouble();
    double mtax0 =
        (multikissan[index]["kissan_amt"] * (double.parse(mtax) / 100))
            .round()
            .toDouble();

    multikissan[index]["kissan_amt"] =
        (multikissan[index]["kissan_amt"] + hammali0 + commission0 + mtax0 + ot)
            .round()
            .toDouble();
  }

  @override
  notifyListeners();
}
