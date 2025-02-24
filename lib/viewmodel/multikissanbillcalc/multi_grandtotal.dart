import 'dart:core';

import 'package:flutter/material.dart';
import 'package:kelawin/Models/billmodel.dart';
import 'package:kelawin/Models/multikissan_model.dart';
import 'package:provider/provider.dart';

import '../../presentation/multikissanbill/provider/multi_kissan_pro.dart';

class MultiGrandtotal extends ChangeNotifier {
  double kissanAmount = 0;
  double nettWett = 0;
  int totalLungar = 0;

  double multiGross = 0;
  double multiTare = 0;
  double multiAreaWt = 0;
  double multiWtDiff = 0;

  double grandTotal = 0;

  double subTotal = 0;
  double mtax = 0;
  double hammali = 0;
  double commission = 0;

  int ot = 40;
  double tcs = 0;
  double tds = 0;

  int hammalipercent = 20;
  int commissionpercent = 15;
  int mtaxpercent = 1;
  int tcspercent = 0;
  int tdspercent = 0;

  TextEditingController hammaliControllerPercent =
      TextEditingController(text: "15");

  TextEditingController commissionControllerPercent =
      TextEditingController(text: "20");

  List<MultikissanModel> resettleMentKissanList = [];

  void calc(double currentGross, double currentTare) {
    kissanAmount = 0;
    nettWett = 0;
    double currentAreaWt = 0;
    grandTotal = 0;

    subTotal = 0;
    mtax = 0;
    hammali = 0;
    commission = 0;

    tcs = 0;
    List<Map> kissan = MultiKissanPro.multikissanCalclist;
    totalLungar = 0;
    for (var element in kissan) {
      kissanAmount = kissanAmount + element["amount"];
      nettWett = nettWett + element["netwt"];
      totalLungar = totalLungar +
          ((element["lungar"].text.toString().isEmpty)
                  ? 0
                  : double.parse(element["lungar"].text))
              .toInt();
      currentAreaWt =
          currentAreaWt + double.parse(element["weight"].text.toString());
    }

    //to convert it in 2 decimal roudoff value
    nettWett = double.parse(
        ((nettWett * 1000).roundToDouble() / 1000).toStringAsFixed(2));
    hammali = ((nettWett * (hammalipercent / 100)) * 100).round().toDouble();
    commission =
        ((nettWett * (commissionpercent / 100)) * 100).round().toDouble();
    mtax = (kissanAmount * (mtaxpercent / 100)).round().toDouble();
    subTotal = (kissanAmount + hammali + commission + mtax).round().toDouble();
    grandTotal = subTotal + ot + tcs;
    //for wtDiff
    multiGross = currentGross;
    multiTare = currentTare;

    multiAreaWt = multiGross - multiTare;

    //to convert it in 2 decimal roudoff value
    multiAreaWt = double.parse(
        ((multiAreaWt * 1000).roundToDouble() / 1000).toStringAsFixed(2));

    multiWtDiff = ((multiAreaWt / 100) - currentAreaWt);
    //to convert it in 2 decimal roudoff value
    multiWtDiff = double.parse(
        ((multiWtDiff * 1000).roundToDouble() / 1000).toStringAsFixed(2));
    currentAreaWt = 0;
    //settling wt diff
    double perLungar = multiWtDiff / totalLungar;

    resettleMentKissanList = [];
    for (var element in kissan) {
      MultikissanModel currentKissan = MultikissanModel.forTextFields(element);
      double perLungarDiffWtinQ = currentKissan.lungar * perLungar;

      if (currentKissan.iskelagroup) {
        //for finding Kelagroup old amount without commission,mtax,hammali
        double amountWithoutTaxes = currentKissan.netwt * currentKissan.bhav;
        double amountOfTaxes = currentKissan.amount - amountWithoutTaxes;

        //for finding Kelagroup new amount
        currentKissan.netwt = currentKissan.netwt + (perLungarDiffWtinQ);
        currentKissan.amount =
            ((currentKissan.netwt * currentKissan.bhav) + amountOfTaxes)
                .round()
                .toDouble();

        //to convert it in 2 decimal roudoff value
        currentKissan.netwt = double.parse(
            ((currentKissan.netwt * 1000).roundToDouble() / 1000)
                .toStringAsFixed(2));
      } else {
        currentKissan.netwt = currentKissan.netwt + (perLungarDiffWtinQ);
        currentKissan.amount =
            (currentKissan.netwt * currentKissan.bhav).round().toDouble();

        //to convert it in 2 decimal roudoff value
        currentKissan.netwt = double.parse(
            ((currentKissan.netwt * 1000).roundToDouble() / 1000)
                .toStringAsFixed(2));
      }

      resettleMentKissanList.add(currentKissan);
    }
    //settling wt diff

    //settling grandtotal
    //firse zero kiya
    kissanAmount = 0;
    nettWett = 0;
    for (MultikissanModel kissan in resettleMentKissanList) {
      kissanAmount = kissanAmount + kissan.amount;
      nettWett = nettWett + kissan.netwt;
    }

    //to convert it in 2 decimal roudoff value
    nettWett = double.parse(
        ((nettWett * 1000).roundToDouble() / 1000).toStringAsFixed(2));
    hammali = ((nettWett * (hammalipercent / 100)) * 100).round().toDouble();
    commission =
        ((nettWett * (commissionpercent / 100)) * 100).round().toDouble();
    mtax = (kissanAmount * (mtaxpercent / 100)).round().toDouble();
    subTotal = (kissanAmount + hammali + commission + mtax).round().toDouble();
    grandTotal = subTotal + ot + tcs;
    //settling grandtotal

    notifyListeners();
  }

  //forbill
  Future<Map<String, dynamic>> generateMultikissanBill(
      context,
      invoiceno,
      date,
      TextEditingController selectedkissan,
      kissanid,
      TextEditingController selectedvyapari,
      vyapariid,
      vyaparicompany,
      vyapariaddress,
      ras,
      board,
      motorno,
      bhuktanpk,
      note) async {
    Map<String, dynamic> multiKissanBill = BillModel(
            invoiceno: invoiceno,
            date: date,
            selectedkissan: selectedkissan.text,
            kissanid: kissanid,
            selectedvyapari: selectedvyapari.text,
            vyapariid: vyapariid,
            vyaparicompany: vyaparicompany,
            vyapariaddress: vyapariaddress,
            ras: ras,
            board: board,
            motorno: motorno,
            bhuktanpk: bhuktanpk,
            gross:
                Provider.of<MultiGrandtotal>(context, listen: false).multiGross,
            tare:
                Provider.of<MultiGrandtotal>(context, listen: false).multiTare,
            wtDiff: Provider.of<MultiGrandtotal>(context, listen: false)
                .multiWtDiff,
            nettweight:
                Provider.of<MultiGrandtotal>(context, listen: false).nettWett,
            kissanamt: Provider.of<MultiGrandtotal>(context, listen: false)
                .kissanAmount,
            hammali:
                Provider.of<MultiGrandtotal>(context, listen: false).hammali,
            hammalipercent: Provider.of<MultiGrandtotal>(context, listen: false)
                .hammalipercent,
            commission:
                Provider.of<MultiGrandtotal>(context, listen: false).commission,
            commissionpercent:
                Provider.of<MultiGrandtotal>(context, listen: false)
                    .commissionpercent,
            mtax: Provider.of<MultiGrandtotal>(context, listen: false).mtax,
            mtaxpercent: Provider.of<MultiGrandtotal>(context, listen: false)
                .mtaxpercent,
            ot: Provider.of<MultiGrandtotal>(context, listen: false).ot,
            tcs: Provider.of<MultiGrandtotal>(context, listen: false).tcs,
            tcspercent:
                Provider.of<MultiGrandtotal>(context, listen: false).tcspercent,
            tds: Provider.of<MultiGrandtotal>(context, listen: false).tds,
            tdspercent:
                Provider.of<MultiGrandtotal>(context, listen: false).tdspercent,
            subtotal:
                Provider.of<MultiGrandtotal>(context, listen: false).subTotal,
            grandtotal:
                Provider.of<MultiGrandtotal>(context, listen: false).grandTotal,
            adminId: 40000,
            isMultikissan: true,
            note: note)
        .tomap();
    return multiKissanBill;
  }

  Future<List<Map<String, dynamic>>> returnMultikissanlist(context) async {
    List<Map<String, dynamic>> finalListOfMultikissan = [];

    Map<String, dynamic> multikissanmodel = {};
    for (MultikissanModel kissan
        in Provider.of<MultiGrandtotal>(context, listen: false)
            .resettleMentKissanList) {
      multikissanmodel = {
        "name": kissan.name,
        "userId": kissan.userId,
        "unit": kissan.unit,
        "pati": kissan.pati,
        "patiunit": kissan.patiunit,
        "patiwt": kissan.patiwt,
        "danda": kissan.danda,
        "dandaunit": kissan.dandaunit,
        "dandawt": kissan.dandawt,
        "wastage": kissan.wastage,
        "wastageunit": kissan.wastageunit,
        "wastagewt": kissan.wastagewt,
        "bhav": kissan.bhav,
        "weight": kissan.weight,
        "netwt": kissan.netwt,
        "lungar": kissan.lungar,
        "amount": kissan.amount,
        "kelagroupCommissionPercent":
            kissan.iskelagroup ? kissan.kelagroupCommissionPercent : 0,
        "kelagroupHammaliPercent":
            kissan.iskelagroup ? kissan.kelagroupHammaliPercent : 0,
        "kelagroupMtaxPercent":
            kissan.iskelagroup ? kissan.kelagroupMtaxPercent : 0,
        "iskelagroup": kissan.iskelagroup,
      };

      finalListOfMultikissan.add(multikissanmodel);
    }
    return finalListOfMultikissan;
  }

  void resetScreen(BuildContext context) {
    final multiGrandtotalpro =
        Provider.of<MultiGrandtotal>(context, listen: false);
    multiGrandtotalpro.kissanAmount = 0;
    multiGrandtotalpro.nettWett = 0;
    multiGrandtotalpro.subTotal = 0;
    multiGrandtotalpro.mtax = 0;
    multiGrandtotalpro.hammali = 0;
    multiGrandtotalpro.commission = 0;
    multiGrandtotalpro.ot = 40;
    multiGrandtotalpro.tcs = 0;
    multiGrandtotalpro.tds = 0;

    multiGrandtotalpro.hammalipercent = 20;
    multiGrandtotalpro.commissionpercent = 15;
    multiGrandtotalpro.mtaxpercent = 1;
    multiGrandtotalpro.tcspercent = 0;
    multiGrandtotalpro.tdspercent = 0;

    multiGrandtotalpro.hammaliControllerPercent.text = "20";
    multiGrandtotalpro.commissionControllerPercent.text = "15";
    multiGrandtotalpro.grandTotal = 0;
    multiGrandtotalpro.resettleMentKissanList.clear();
    notifyListeners();
  }
}
