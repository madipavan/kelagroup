import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kelawin/service/BillService/bill_khata_amount_adding.dart';
import 'package:kelawin/utils/apputils.dart';

class BillandKhataAddingViewmodel {
  Future billAndKhataAmountupdate(
      Map<String, dynamic> bill, BuildContext context) async {
    try {
      Apputils().loader(context);

      int newInvoiceId =
          await BillandKhataAmountAdding().generateUniqueinvoiceId();
      newInvoiceId != 0
          ? bill["invoiceno"] = newInvoiceId
          : throw Exception("newInvoiceId is 0");
      await BillandKhataAmountAdding().addBillandVyapariKhataAmountupdate(bill);
      context.mounted
          ? Apputils().transactionSuccess(context, 4, "Transaction Successful")
          : null;
    } catch (e) {
      context.mounted
          ? Apputils().transactionUnsuccess(
              context, "Oops! Something went wrong transaction fail!")
          : null;
    }
  }

  //multikissan
  Future multiKissanbillAndKhataAmountupdate(Map<String, dynamic> bill,
      List<Map<String, dynamic>> multikissanList, BuildContext context) async {
    int newInvoiceId = 0;
    try {
      multikissanList.isEmpty
          ? Apputils().transactionUnsuccess(
              context, "Oops! List is Empty transaction fail!")
          : {
              Apputils().loader(context),
              newInvoiceId =
                  await BillandKhataAmountAdding().generateUniqueinvoiceId(),
              newInvoiceId != 0
                  ? bill["invoiceno"] = newInvoiceId
                  : throw Exception("newInvoiceId is 0"),
              await BillandKhataAmountAdding()
                  .addMultiKissanbillAndKhataAmountupdate(
                bill,
                multikissanList,
              ),
              context.mounted
                  ? Apputils()
                      .transactionSuccess(context, 4, "Transaction Successful")
                  : null,
            };
    } catch (e) {
      Apputils().transactionUnsuccess(
          context, "Oops! Something went wrong transaction fail!");
    }
  }

  //edit
  Future billAndKhataAmountEdit(
      Map<String, dynamic> bill, BuildContext context) async {
    try {
      print(bill);
      Apputils().loader(context);
      await BillandKhataAmountAdding().editBillandVyapariKhataAmount(bill);
      context.mounted
          ? Apputils().transactionSuccess(context, 4, "Transaction Successful")
          : null;
    } catch (e) {
      context.mounted
          ? Apputils().transactionUnsuccess(
              context, "Oops! Something went wrong transaction fail!")
          : null;
    }
  }

  //edit
  Future multiKissanbillAndKhataAmountEdit(Map<String, dynamic> bill,
      List<Map<String, dynamic>> multikissanList, BuildContext context) async {
    try {
      Apputils().loader(context);
      await BillandKhataAmountAdding()
          .addMultiKissanbillAndKhataAmountupdate(bill, multikissanList);
      context.mounted
          ? Apputils().transactionSuccess(context, 4, "Transaction Successful")
          : null;
    } catch (e) {
      context.mounted
          ? Apputils().transactionUnsuccess(
              context, "Oops! Something went wrong transaction fail!")
          : null;
    }
  }
}
