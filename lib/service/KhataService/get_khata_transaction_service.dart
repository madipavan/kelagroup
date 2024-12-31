import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelawin/Models/khata_model.dart';
import 'package:kelawin/Models/transaction_model.dart';

class GetKhataAndTransactionService {
  final firebase = FirebaseFirestore.instance;

  Future<KhataModel?> getkhata(int userId, String role) async {
    try {
      QuerySnapshot<Map<String, dynamic>> khata = await firebase
          .collection("${role}_khata")
          .where("${role}_id", isEqualTo: userId)
          .get();

      return KhataModel.fromJson(khata);
    } on FirebaseException catch (e) {
      print(e);
      throw Exception(e.toString());
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  Future<List<TransactionModel>> getTransactions(
      int userId, String role) async {
    try {
      List<TransactionModel> transactions = [];
      QuerySnapshot<Map<String, dynamic>> transactions0 = await firebase
          .collection("${role}_transaction")
          .where("user_id", isEqualTo: userId.toString())
          .get();

      for (var element in transactions0.docs) {
        transactions.add(TransactionModel.fromJson(element));
      }

      return transactions;
    } on FirebaseException catch (e) {
      print(e);
      throw Exception(e.toString());
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }
}
