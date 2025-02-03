import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  int transactionId;
  String transactionType;
  String date;
  int khataId;
  int userId;
  String? paymentMode;
  String? receiverName;
  double amount;
  int invoiceno;
  Timestamp? time;
  TransactionModel(
      {required this.transactionId,
      required this.transactionType,
      required this.date,
      required this.khataId,
      required this.amount,
      required this.invoiceno,
      this.time,
      this.paymentMode,
      this.receiverName,
      required this.userId});

  Map<String, dynamic> convertTomap() {
    return {
      "transactionId": transactionId,
      "date": date,
      "transactionType": transactionType,
      "amount": amount,
      "invoiceno": invoiceno,
      "khataId": khataId,
      "userId": userId,
      "paymentMode": paymentMode ?? "",
      "receiverName": receiverName ?? "",
      "time": time ?? Timestamp.now(),
    };
  }

  factory TransactionModel.fromJson(
      QueryDocumentSnapshot<Map<String, dynamic>> transaction) {
    return TransactionModel(
        transactionId: transaction["transactionId"],
        transactionType: transaction["transactionType"],
        date: transaction["date"],
        khataId: transaction["khataId"],
        amount: transaction["amount"],
        invoiceno: transaction["invoiceno"],
        paymentMode: transaction.data().containsKey("paymentMode")
            ? transaction["paymentMode"]
            : "",
        receiverName: transaction.data().containsKey("receiverName")
            ? transaction["receiverName"]
            : "",
        time: transaction["time"],
        userId: transaction["userId"]);
  }
}
