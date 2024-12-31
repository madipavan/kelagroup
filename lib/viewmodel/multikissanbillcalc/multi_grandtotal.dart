import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presentation/multikissanbill/provider/multi_kissan_pro.dart';

class MultiGrandtotal extends ChangeNotifier {
  double kissanAmount = 0;
  double nettWett = 0;

  double grandTotal = 0;

  double subTotal = 0;
  double mtax = 0;
  double hammali = 0;
  double commission = 0;

  double ot = 40;
  double tcs = 0;

  int hammalipercent = 20;
  int commissionpercent = 15;
  int mtaxpercent = 1;
  int tcspercent = 0;

  void calc() {
    kissanAmount = 0;
    nettWett = 0;

    grandTotal = 0;

    subTotal = 0;
    mtax = 0;
    hammali = 0;
    commission = 0;

    ot = 40;
    tcs = 0;
    List<Map> kissan = MultiKissanPro.multikissanCalclist;

    for (var element in kissan) {
      kissanAmount = kissanAmount + element["kissan_amt"];
      nettWett = nettWett + element["netwt"];
    }
    //

    hammali = (kissanAmount * (hammalipercent / 100)).round().toDouble();
    commission = (kissanAmount * (commissionpercent / 100)).round().toDouble();
    mtax = (kissanAmount * (mtaxpercent / 100)).round().toDouble();
    subTotal = (kissanAmount + hammali + commission + mtax).round().toDouble();
    grandTotal = subTotal + ot + tcs;

    notifyListeners();
  }

  //forbill
  Future<Map<String, dynamic>> generateMultikissanBill(
      context,
      invoiceno,
      date,
      selectedkissan,
      kissanid,
      selectedvyapari,
      vyapariid,
      vyaparicompany,
      vyapariaddress,
      ras,
      board,
      motorno,
      bhuktanpk,
      note) async {
    return {
      "bill_no": invoiceno,
      "date": date,
      "kissan_name": selectedkissan.text,
      "kissan_id": kissanid,
      "vyapari_name": selectedvyapari.text,
      "vyapari_id": vyapariid,
      "vyapari_company": vyaparicompany,
      "vyapari_address": vyapariaddress,
      "ras": ras,
      "board": board,
      "motorno": motorno,
      "bhuktanpk": bhuktanpk,
      "nettweight":
          Provider.of<MultiGrandtotal>(context, listen: false).nettWett,
      "kissanamt":
          Provider.of<MultiGrandtotal>(context, listen: false).kissanAmount,
      "hammali": Provider.of<MultiGrandtotal>(context, listen: false).hammali,
      "hammalipercent":
          Provider.of<MultiGrandtotal>(context, listen: false).hammalipercent,
      "commission":
          Provider.of<MultiGrandtotal>(context, listen: false).commission,
      "commissionpercent": Provider.of<MultiGrandtotal>(context, listen: false)
          .commissionpercent,
      "mtax": Provider.of<MultiGrandtotal>(context, listen: false).mtax,
      "mtaxpercent":
          Provider.of<MultiGrandtotal>(context, listen: false).mtaxpercent,
      "ot": Provider.of<MultiGrandtotal>(context, listen: false).ot,
      "tcs": Provider.of<MultiGrandtotal>(context, listen: false).tcs,
      "subtotal": Provider.of<MultiGrandtotal>(context, listen: false).subTotal,
      "grandtotal":
          Provider.of<MultiGrandtotal>(context, listen: false).grandTotal,
      "ismultikissan": true,
      "adminname": "admin1",
      "note": note,
    };
  }

  Future<List<Map<String, dynamic>>> return_multikissanlist() async {
    List<Map<String, dynamic>> finalListOfMultikissan = [];
    List<Map> kissan = MultiKissanPro.multikissanCalclist;
    Map<String, dynamic> multikissanmodel = {};
    for (var element in kissan) {
      if (element["iskelagroup"]) {
        multikissanmodel = {
          "name": element["name"].text,
          "kelagroup_id": element["kissan_id"],
          "unit": element["unit"],
          "pati": element["pati"].text,
          "patiunit": element["patiunit"],
          "patiwt": element["patiwt"],
          "danda": element["danda"].text,
          "dandaunit": element["dandaunit"],
          "dandawt": element["dandawt"],
          "wastage": element["wastage"].text,
          "wastageunit": element["wastageunit"],
          "wastagewt": element["wastagewt"],
          "bhav": element["bhav"].text,
          "weight": element["weight"].text,
          "netwt": element["netwt"],
          "lungar": element["lungar"].text,
          "amount": element["kissan_amt"],
          "iskelagroup": element["iskelagroup"],
        };
      } else {
        multikissanmodel = {
          "name": element["name"].text,
          "kissan_id": element["kissan_id"],
          "unit": element["unit"],
          "pati": element["pati"].text,
          "patiunit": element["patiunit"],
          "patiwt": element["patiwt"],
          "danda": element["danda"].text,
          "dandaunit": element["dandaunit"],
          "dandawt": element["dandawt"],
          "wastage": element["wastage"].text,
          "wastageunit": element["wastageunit"],
          "wastagewt": element["wastagewt"],
          "bhav": element["bhav"].text,
          "weight": element["weight"].text,
          "netwt": element["netwt"],
          "lungar": element["lungar"].text,
          "amount": element["kissan_amt"],
          "iskelagroup": false,
        };
      }
      finalListOfMultikissan.add(multikissanmodel);
    }
    return finalListOfMultikissan;
  }
}
