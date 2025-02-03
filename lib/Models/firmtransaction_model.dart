import 'package:cloud_firestore/cloud_firestore.dart';

class FirmtransactionModel {
  String transactionType;
  String khataId;
  double amount;
  int invoiceno;
  Timestamp? time;

  FirmtransactionModel({
    required this.transactionType,
    required this.khataId,
    required this.invoiceno,
    this.time,
    required this.amount,
  });

  Map<String, dynamic> convertTomap() {
    return {
      "transactionType": transactionType,
      "amount": amount,
      "invoiceno": invoiceno,
      "khataId": khataId,
      "time": time ?? Timestamp.now(),
    };
  }
}
