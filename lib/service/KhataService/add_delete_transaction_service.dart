import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelawin/Models/transaction_model.dart';

class AddDeleteTransactionService {
  final firebase = FirebaseFirestore.instance;

  Future addTransaction(Map<String, dynamic> transaction, String role) async {
    try {
      WriteBatch batch = firebase.batch();
      //getting khata
      QuerySnapshot khataDoc = await firebase
          .collection("Khata")
          .where("userId", isEqualTo: transaction["userId"])
          .get();
      //updating values in khata
      double total = 0;
      double received = 0;
      double due = 0;
      if (transaction["transactionType"] == "DEBIT") {
        if (role == "vyapari") {
          total = khataDoc.docs[0]["total"] + transaction["amount"];
          due = total - khataDoc.docs[0]["received"];
          received = khataDoc.docs[0]["received"];
        } else {
          total = khataDoc.docs[0]["total"];
          received = khataDoc.docs[0]["received"] + transaction["amount"];
          due = total - received;
        }
      } else if (transaction["transactionType"] == "CREDIT") {
        if (role == "vyapari") {
          total = khataDoc.docs[0]["total"];
          received = khataDoc.docs[0]["received"] + transaction["amount"];
          due = total - received;
        } else {
          total = khataDoc.docs[0]["total"] + transaction["amount"];
          due = total - khataDoc.docs[0]["received"];
          received = khataDoc.docs[0]["received"];
        }
      }
      final khataRef = firebase.collection("Khata").doc(khataDoc.docs[0].id);
      batch
          .update(khataRef, {"total": total, "due": due, "received": received});
      //updating values in khata
      //adding transaction

      int newtransactionId = await generateUniqueTransactionId(role);
      transaction["transactionId"] = newtransactionId;
      transaction["khataId"] = khataDoc.docs[0]["khataId"].toString();

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
          .collection("Khata")
          .where("khataId", isEqualTo: transaction.khataId)
          .get();
      //updating values in khata
      double total = 0;
      double received = 0;
      double due = 0;
      if (transaction.transactionType == "DEBIT") {
        if (role == "vyapari") {
          total = khataDoc.docs[0]["total"] - transaction.amount;
          due = total - khataDoc.docs[0]["received"];
          received = khataDoc.docs[0]["received"];
        } else {
          total = khataDoc.docs[0]["total"];
          received = khataDoc.docs[0]["received"] - transaction.amount;
          due = total - received;
        }
      } else if (transaction.transactionType == "CREDIT") {
        if (role == "vyapari") {
          total = khataDoc.docs[0]["total"];
          received = khataDoc.docs[0]["received"] - transaction.amount;
          due = total - received;
        } else {
          total = khataDoc.docs[0]["total"] - transaction.amount;
          due = total - khataDoc.docs[0]["received"];
          received = khataDoc.docs[0]["received"];
        }
      }
      final khataRef = firebase.collection("Khata").doc(khataDoc.docs[0].id);
      batch
          .update(khataRef, {"total": total, "due": due, "received": received});
      //updating values in khata
      //deleting transaction
      QuerySnapshot transactionId = await firebase
          .collection("${role}_transaction")
          .where("transactionId", isEqualTo: transaction.transactionId)
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

  //generating transactionid
  Future<int> generateUniqueTransactionId(String role) async {
    final transactionsRef =
        FirebaseFirestore.instance.collection('${role}_transaction');

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the last bill (sorted by bill_number in descending order)
      final lastTransactionBillQuery = await transactionsRef
          .orderBy('transactionId', descending: true)
          .limit(1)
          .get();

      int lastTransactionNumber =
          0; // Default starting number if no bills exist
      if (role == "vyapari") {
        lastTransactionNumber = 9000000;
      } else if (role == "kissan") {
        lastTransactionNumber = 8000000;
      } else if (role == "kelagroup") {
        lastTransactionNumber = 7000000;
      }

      if (lastTransactionBillQuery.docs.isNotEmpty) {
        lastTransactionNumber =
            lastTransactionBillQuery.docs.first.data()['transactionId'];
      }

      int newBillNumber = lastTransactionNumber + 1;

      return newBillNumber;
    });
  }
}
