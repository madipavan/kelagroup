import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  int transactionId;
  String transactionType;
  String date;
  String khataId;
  String userId;
  String? paymentMode;
  String? receiverName;
  double amount;
  int billno;
  TransactionModel(
      {required this.transactionId,
      required this.transactionType,
      required this.date,
      required this.khataId,
      required this.amount,
      required this.billno,
      this.paymentMode,
      this.receiverName,
      required this.userId});

  Map<String, dynamic> convertTomap() {
    Map<String, dynamic> transaction = {
      "transaction_id": transactionId,
      "date": date,
      "transaction_type": transactionType,
      "amount": amount,
      "billno": billno,
      "khata_id": khataId,
      "user_id": userId,
      "paymentMode": paymentMode ?? "",
      "receiverName": receiverName ?? "",
    };
    return transaction;
  }

  factory TransactionModel.fromJson(
      QueryDocumentSnapshot<Map<String, dynamic>> transaction) {
    return TransactionModel(
        transactionId: transaction["transaction_id"],
        transactionType: transaction["transaction_type"],
        date: transaction["date"],
        khataId: transaction["khata_id"],
        amount: transaction["amount"],
        billno: transaction["billno"],
        paymentMode: transaction.data().containsKey("paymentMode")
            ? transaction["paymentMode"]
            : "",
        receiverName: transaction.data().containsKey("receiverName")
            ? transaction["receiverName"]
            : "",
        userId: transaction["user_id"]);
  }
}
