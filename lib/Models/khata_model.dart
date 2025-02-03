import 'package:cloud_firestore/cloud_firestore.dart';

class KhataModel {
  int khataId;
  double total;
  double received;
  double due;
  int userId;
  KhataModel({
    required this.khataId,
    required this.received,
    required this.total,
    required this.due,
    required this.userId,
  });

  factory KhataModel.fromJson(QuerySnapshot<Map<String, dynamic>> khata) {
    return KhataModel(
      due: khata.docs[0]["due"],
      khataId: khata.docs[0]["khataId"],
      received: khata.docs[0]["received"],
      total: khata.docs[0]["total"],
      userId: khata.docs[0]["userId"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "due": due,
      "khataId": khataId,
      "received": received,
      "total": total,
      "userId": userId,
    };
  }
}
