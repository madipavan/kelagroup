import 'package:kelawin/Models/khata_model.dart';
import 'package:kelawin/Models/transaction_model.dart';
import 'package:kelawin/service/KhataService/get_khata_transaction_service.dart';

class GetkhataAndTransactionViewmodel {
  Future<KhataModel?> getKhataFromServer(int userId, String role) async {
    try {
      KhataModel? khata =
          await GetKhataAndTransactionService().getkhata(userId, role);

      return khata;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<TransactionModel>> getTransactionFromServer(
      int userId, String role) async {
    try {
      List<TransactionModel> transactions =
          await GetKhataAndTransactionService().getTransactions(userId, role);

      return transactions;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
