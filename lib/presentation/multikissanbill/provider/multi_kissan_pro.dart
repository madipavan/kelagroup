import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MultiKissanPro extends ChangeNotifier {
  List<Map> multikissan = [];

  static List<Map> multikissanCalclist = [];

  void addintolist(context) async {
    multikissan.add(await kissan(context));
    multikissanCalclist = multikissan;
    notifyListeners();
  }

  void removeintolist(index) async {
    multikissan.removeAt(index);
    multikissanCalclist = multikissan;
    notifyListeners();
  }

  Future<Map> kissan(context) async {
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
    bhav.text = Provider.of<MultiKissanPro>(context, listen: false)
        .multikissan[0]["bhav"]
        .text;

    int kissanid = 0;

    String unit = Provider.of<MultiKissanPro>(context, listen: false)
        .multikissan[0]["unit"];
    String patiunit = "Percent";
    String dandaunit = "Percent";
    String wastageunit = "Percent";

    double patiwt = 0;
    double dandawt = 0;
    double wastagewt = 0;

    double netwt = 0;

    double amount = 0;

    return {
      "name": name,
      "userId": kissanid,
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
      "amount": amount,
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
      //to convert it in 2 decimal roudoff value
      multikissan[index]["patiwt"] = double.parse(
          ((multikissan[index]["patiwt"] * 1000).roundToDouble() / 1000)
              .toStringAsFixed(2));
    } else {
      multikissan[index]["patiwt"] =
          double.parse(multikissan[index]["pati"].text);
    }

    multikissan[index]["netwt"] = (mainwt - multikissan[index]["patiwt"]);

    //to convert it in 2 decimal roudoff value
    multikissan[index]["netwt"] = double.parse(
        ((multikissan[index]["netwt"] * 1000).roundToDouble() / 1000)
            .toStringAsFixed(2));

    multikissan[index]["amount"] = (multikissan[index]["netwt"] *
        double.parse(multikissan[index]["bhav"].text.toString()));
    //to convert it in 2 decimal roudoff value
    multikissan[index]["amount"] = double.parse(
            ((multikissan[index]["amount"] * 1000).roundToDouble() / 1000)
                .toStringAsFixed(2))
        .round();
  }

  caratecalc(index) {
    double mainwt = double.parse(multikissan[index]["weight"].text.toString());
    //
    if (multikissan[index]["patiunit"] == "Percent") {
      multikissan[index]["patiwt"] =
          mainwt * (double.parse(multikissan[index]["pati"].text) / 100);
      //to convert it in 2 decimal roudoff value
      multikissan[index]["patiwt"] = double.parse(
          ((multikissan[index]["patiwt"] * 1000).roundToDouble() / 1000)
              .toStringAsFixed(2));
    } else {
      multikissan[index]["patiwt"] =
          double.parse(multikissan[index]["pati"].text);
    }
    //

    if (multikissan[index]["dandaunit"] == "Percent") {
      multikissan[index]["dandawt"] = (mainwt - multikissan[index]["patiwt"]) *
          (double.parse(multikissan[index]["danda"].text) / 100);
      //to convert it in 2 decimal roudoff value
      multikissan[index]["dandawt"] = double.parse(
          ((multikissan[index]["dandawt"] * 1000).roundToDouble() / 1000)
              .toStringAsFixed(2));
    } else {
      multikissan[index]["dandawt"] =
          double.parse(multikissan[index]["danda"].text);
    }

    multikissan[index]["netwt"] =
        (mainwt - multikissan[index]["patiwt"] + multikissan[index]["dandawt"]);
    //to convert it in 2 decimal roudoff value
    multikissan[index]["netwt"] = double.parse(
        ((multikissan[index]["netwt"] * 1000).roundToDouble() / 1000)
            .toStringAsFixed(2));
    multikissan[index]["amount"] = (multikissan[index]["netwt"] *
        double.parse(multikissan[index]["bhav"].text.toString()));
    //to convert it in 2 decimal roudoff value
    multikissan[index]["amount"] = double.parse(
            ((multikissan[index]["amount"] * 1000).roundToDouble() / 1000)
                .toStringAsFixed(2))
        .round();
  }

  boxcalc(index) {
    double mainwt = double.parse(multikissan[index]["weight"].text.toString());
    //
    if (multikissan[index]["patiunit"] == "Percent") {
      multikissan[index]["patiwt"] =
          mainwt * (double.parse(multikissan[index]["pati"].text) / 100);
      //to convert it in 2 decimal roudoff value
      multikissan[index]["patiwt"] = double.parse(
          ((multikissan[index]["patiwt"] * 1000).roundToDouble() / 1000)
              .toStringAsFixed(2));
    } else {
      multikissan[index]["patiwt"] =
          double.parse(multikissan[index]["pati"].text);
    }
    //

    if (multikissan[index]["dandaunit"] == "Percent") {
      multikissan[index]["dandawt"] = (mainwt - multikissan[index]["patiwt"]) *
          (double.parse(multikissan[index]["danda"].text) / 100);
      //to convert it in 2 decimal roudoff value
      multikissan[index]["dandawt"] = double.parse(
          ((multikissan[index]["dandawt"] * 1000).roundToDouble() / 1000)
              .toStringAsFixed(2));
    } else {
      multikissan[index]["dandawt"] =
          double.parse(multikissan[index]["danda"].text);
    }
    //

    if (multikissan[index]["wastageunit"] == "Percent") {
      multikissan[index]["wastagewt"] =
          mainwt * (double.parse(multikissan[index]["wastage"].text) / 100);
      //to convert it in 2 decimal roudoff value
      multikissan[index]["wastagewt"] = double.parse(
          ((multikissan[index]["wastagewt"] * 1000).roundToDouble() / 1000)
              .toStringAsFixed(2));
    } else {
      multikissan[index]["wastagewt"] =
          double.parse(multikissan[index]["wastage"].text);
    }

    multikissan[index]["netwt"] = (mainwt -
        multikissan[index]["patiwt"] +
        multikissan[index]["dandawt"] +
        multikissan[index]["wastagewt"]);
    //to convert it in 2 decimal roudoff value
    multikissan[index]["netwt"] = double.parse(
        ((multikissan[index]["netwt"] * 1000).roundToDouble() / 1000)
            .toStringAsFixed(2));

    multikissan[index]["amount"] = (multikissan[index]["netwt"] *
        double.parse(multikissan[index]["bhav"].text.toString()));
    //to convert it in 2 decimal roudoff value
    multikissan[index]["amount"] = double.parse(
            ((multikissan[index]["amount"] * 1000).roundToDouble() / 1000)
                .toStringAsFixed(2))
        .round();
  }

  void kelagroupcalc(index, String hammali, String commission, String mtax) {
    double ot = 50;
    multikissan[index]["amount"] = (multikissan[index]["netwt"] *
        double.parse(multikissan[index]["bhav"].text.toString()));

    double hammali0 =
        (multikissan[index]["netwt"] * (double.parse(hammali) / 100));
    double commission0 =
        (multikissan[index]["netwt"] * (double.parse(commission) / 100));
    double mtax0 = (multikissan[index]["amount"] * (double.parse(mtax) / 100));

    multikissan[index]["amount"] =
        (multikissan[index]["amount"] + hammali0 + commission0 + mtax0 + ot)
            .round()
            .toDouble();
  }

  @override
  notifyListeners();
}
