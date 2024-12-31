import 'package:flutter/material.dart';
import 'package:kelawin/service/BillService/bill_khata_amount_adding.dart';
import 'package:kelawin/utils/apputils.dart';

class BillandKhataAddingViewmodel {
  Future billAndKhataAmountupdate(
      Map<String, dynamic> bill,
      int vyapariId,
      double vyapariAmount,
      int kissanId,
      double kissanAmount,
      BuildContext context) async {
    try {
      Apputils().loader(context);
      await BillandKhataAmountAdding().addBillandVyapariKhataAmountupdate(
        bill,
        vyapariId,
        vyapariAmount,
        kissanId,
        kissanAmount,
      );
      Apputils().transactionSuccess(context, 4, "Transaction Successful");
    } catch (e) {
      Apputils().transactionUnsuccess(
          context, "Oops! Something went wrong transaction fail!");
    }
  }

  //multikissan
  Future multiKissanbillAndKhataAmountupdate(Map<String, dynamic> bill,
      List<Map<String, dynamic>> multikissanList, BuildContext context) async {
    try {
      Apputils().loader(context);
      await BillandKhataAmountAdding().addMultiKissanbillAndKhataAmountupdate(
        bill,
        multikissanList,
      );
      Apputils().transactionSuccess(context, 4, "Transaction Successful");
    } catch (e) {
      Apputils().transactionUnsuccess(
          context, "Oops! Something went wrong transaction fail!");
    }
  }
}
