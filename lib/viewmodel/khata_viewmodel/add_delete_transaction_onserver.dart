import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kelawin/Models/transaction_model.dart';
import 'package:kelawin/utils/apputils.dart';

import '../../service/KhataService/add_delete_transaction_service.dart';

class AddDeleteTransactionOnserver {
  StreamSubscription? _subscription;
  Future addTransactionOnServer(
      TransactionModel transaction, String role, BuildContext context) async {
    try {
      Apputils().loader(context);
      cancelListeners();
      int newTransactionId =
          await AddDeleteTransactionService().generateUniqueTransactionId(role);
      newTransactionId != 0
          ? transaction.transactionId = newTransactionId
          : throw Exception("TransactionId is 0");
      Map<String, dynamic> convertedTransaction = transaction.convertTomap();
      await AddDeleteTransactionService()
          .addTransaction(convertedTransaction, role);
      context.mounted
          ? Apputils()
              .transactionSuccess(context, 2, "Transaction Successfull!")
          : null;
    } catch (e) {
      context.mounted
          ? Apputils().transactionUnsuccess(context, "Transaction Failed!")
          : null;
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

  void cancelListeners() {
    _subscription?.cancel();
    _subscription = null; // Prevents accidental re-use
  }
}
