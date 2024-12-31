import 'package:cloud_firestore/cloud_firestore.dart';

class KhataModel {
  String khataId;
  double total;
  double received;
  double due;

  KhataModel(
      {required this.khataId,
      required this.received,
      required this.total,
      required this.due});

  factory KhataModel.fromJson(QuerySnapshot<Map<String, dynamic>> khata) {
    return KhataModel(
      due: double.parse(khata.docs[0]["Due"].toString()),
      khataId: khata.docs[0]["khata_id"].toString(),
      received: double.parse(khata.docs[0]["Recieved"].toString()),
      total: double.parse(khata.docs[0]["Total"].toString()),
    );
  }
}
