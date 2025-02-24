import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelawin/Models/transaction_model.dart';
import 'package:synchronized/synchronized.dart';

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
    // Create a lock instance
    int newTransactionId = 0;
    final counterRef = FirebaseFirestore.instance
        .collection('idCounters')
        .doc("${role}TransactionIdCounter");
    try {
      final lock = Lock();
      await lock.synchronized(() async {
        return await FirebaseFirestore.instance
            .runTransaction((transaction) async {
          // Get the last bill (sorted by bill_number in descending order)
          DocumentSnapshot counterDoc = await transaction.get(counterRef);

          int lastTransactionId =
              0; // Default starting number if no bills exist
          if (role == "vyapari") {
            lastTransactionId = 9000000;
          } else if (role == "kissan") {
            lastTransactionId = 8000000;
          } else if (role == "kelagroup") {
            lastTransactionId = 7000000;
          }

          if (!counterDoc.exists) {
          } else {
            lastTransactionId = counterDoc.exists
                ? (counterDoc.get("transactionId") ?? lastTransactionId)
                : lastTransactionId;
            newTransactionId = lastTransactionId + 1;
            transaction.update(counterRef, {"transactionId": newTransactionId});
          }

          return newTransactionId;
        });
      });
      return newTransactionId;
    } on FirebaseException catch (e) {
      throw Exception("${e}Error while creating userId");
    } catch (e) {
      throw Exception("${e}Error while creating userId");
    }
  }
}
