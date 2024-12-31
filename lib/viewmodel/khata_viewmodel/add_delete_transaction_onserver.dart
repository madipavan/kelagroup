import 'package:flutter/material.dart';
import 'package:kelawin/Models/transaction_model.dart';
import 'package:kelawin/utils/apputils.dart';

import '../../service/KhataService/add_delete_transaction_service.dart';

class AddDeleteTransactionOnserver {
  Future addTransactionOnServer(
      TransactionModel transaction, String role, BuildContext context) async {
    try {
      Apputils().loader(context);
      Map<String, dynamic> convertedTransaction = transaction.convertTomap();
      await AddDeleteTransactionService()
          .addTransaction(convertedTransaction, role);
      Apputils().transactionSuccess(context, 2, "Transaction Successfull!");
    } catch (e) {
      Apputils().transactionUnsuccess(context, "Transaction Failed!");
      print(e.toString());
    }
  }

  Future deleteTransactionOnServer(
      TransactionModel transaction, String role, BuildContext context) async {
    try {
      Apputils().loader(context);

      await AddDeleteTransactionService().deleteTransaction(transaction, role);
      Apputils().transactionSuccess(context, 2, "Transaction Successfull!");
    } catch (e) {
      Apputils().transactionUnsuccess(context, "Transaction Failed!");
      print(e.toString());
    }
  }
}
