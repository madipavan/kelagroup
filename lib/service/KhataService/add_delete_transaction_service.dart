import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelawin/Models/transaction_model.dart';

class AddDeleteTransactionService {
  final firebase = FirebaseFirestore.instance;

  Future addTransaction(Map<String, dynamic> transaction, String role) async {
    try {
      WriteBatch batch = firebase.batch();
      //getting khata
      QuerySnapshot khataDoc = await firebase
          .collection("${role}_khata")
          .where("${role}_id", isEqualTo: int.parse(transaction["user_id"]))
          .get();
      //updating values in khata
      double total = 0;
      double received = 0;
      double due = 0;
      if (transaction["transaction_type"] == "DEBIT") {
        total = khataDoc.docs[0]["Total"] + transaction["amount"];
        due = total - khataDoc.docs[0]["Recieved"];
        received = khataDoc.docs[0]["Recieved"];
      } else if (transaction["transaction_type"] == "CREDIT") {
        total = khataDoc.docs[0]["Total"];
        received = khataDoc.docs[0]["Recieved"] + transaction["amount"];
        due = total - received;
      }
      final khataRef =
          firebase.collection("${role}_khata").doc(khataDoc.docs[0].id);
      batch
          .update(khataRef, {"Total": total, "Due": due, "Recieved": received});
      //updating values in khata
      //adding transaction
      QuerySnapshot transactionData = await firebase
          .collection("${role}_transaction")
          .orderBy("transaction_id", descending: true)
          .get();
      int newtransactionId = transactionData.docs[0]["transaction_id"] + 1;
      transaction["transaction_id"] = newtransactionId;
      transaction["khata_id"] = khataDoc.docs[0]["khata_id"].toString();

      final transactionRef = firebase.collection("${role}_transaction").doc();
      batch.set(transactionRef, transaction);
      await batch.commit();
    } on FirebaseException catch (e) {
      print("adding of transaction $e");
      throw Exception(e.toString());
    } catch (e) {
      print("adding of transaction $e");
      throw Exception(e.toString());
    }
  }

  //deletion of transaction
  Future deleteTransaction(TransactionModel transaction, String role) async {
    try {
      WriteBatch batch = firebase.batch();

      //getting khata
      QuerySnapshot khataDoc = await firebase
          .collection("${role}_khata")
          .where("khata_id", isEqualTo: int.parse(transaction.khataId))
          .get();
      //updating values in khata
      double total = 0;
      double received = 0;
      double due = 0;
      if (transaction.transactionType == "DEBIT") {
        total = khataDoc.docs[0]["Total"] - transaction.amount;
        due = total - khataDoc.docs[0]["Recieved"];
        received = khataDoc.docs[0]["Recieved"];
      } else if (transaction.transactionType == "CREDIT") {
        total = khataDoc.docs[0]["Total"] - transaction.amount;
        received = khataDoc.docs[0]["Recieved"] - transaction.amount;
        due = total - received;
      }
      final khataRef =
          firebase.collection("${role}_khata").doc(khataDoc.docs[0].id);
      batch
          .update(khataRef, {"Total": total, "Due": due, "Recieved": received});
      //updating values in khata
      //deleting transaction
      QuerySnapshot transactionId = await firebase
          .collection("${role}_transaction")
          .where("transaction_id", isEqualTo: transaction.transactionId)
          .get();
      final transactionRef = firebase
          .collection("${role}_transaction")
          .doc(transactionId.docs[0].id);
      batch.delete(transactionRef);
      await batch.commit();
      //deleting transaction
    } on FirebaseException catch (e) {
      print("deletion of transaction $e");
      throw Exception(e.toString());
    } catch (e) {
      print("deletion of transaction $e");
      throw Exception(e.toString());
    }
  }
}
