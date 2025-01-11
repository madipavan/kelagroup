import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelawin/Models/transaction_model.dart';

class BillandKhataAmountAdding {
  final firebase = FirebaseFirestore.instance;
  Future addBillandVyapariKhataAmountupdate(
    Map<String, dynamic> bill,
    int vyapariId,
    double vyapariAmount,
    int kissanId,
    double kissanAmount,
  ) async {
    try {
      WriteBatch batch = firebase.batch();
      //adding bill
      final billsRef = firebase.collection("Bills").doc();
      // Perform the transaction

      //khata updation vyapari
      QuerySnapshot vyaparidoc = await firebase
          .collection("vyapari_khata")
          .where("vyapari_id", isEqualTo: vyapariId)
          .get();

      final vyaparidocId = vyaparidoc.docs[0].id;
      double vyapariTotal = vyaparidoc.docs[0]["Total"] + vyapariAmount;
      double vyapariDue = vyapariTotal - vyaparidoc.docs[0]["Recieved"];

      //khata updation vyapari

      //vyapari transaction
      QuerySnapshot vyapariTransactiondoc = await firebase
          .collection("vyapari_transaction")
          .orderBy("transaction_id", descending: true)
          .limit(1)
          .get();

      int vyapariNewTransactionId =
          vyapariTransactiondoc.docs[0]["transaction_id"] + 1;
      Map<String, dynamic> vyapariTransaction = TransactionModel(
              billno: bill["bill_no"],
              amount: bill["grandtotal"],
              date: bill["date"],
              khataId: vyaparidoc.docs[0]["khata_id"].toString(),
              transactionId: vyapariNewTransactionId,
              transactionType: "DEBIT",
              userId: vyapariId.toString())
          .convertTomap();
      //vyapari transaction

      //kissan updation vyapari
      QuerySnapshot kissandoc = await firebase
          .collection("kissan_khata")
          .where("kissan_id", isEqualTo: kissanId)
          .get();

      final kissandocId = kissandoc.docs[0].id;
      double kissanTotal = kissandoc.docs[0]["Total"] + kissanAmount;
      double kissanDue = kissanTotal - kissandoc.docs[0]["Recieved"];

      //khata updation kissan
      //kissan transaction
      QuerySnapshot kissanTransactiondoc = await firebase
          .collection("kissan_transaction")
          .orderBy("transaction_id", descending: true)
          .limit(1)
          .get();

      int kissanNewTransactionId =
          kissanTransactiondoc.docs[0]["transaction_id"] + 1;
      Map<String, dynamic> kissanTransaction = TransactionModel(
              billno: bill["bill_no"],
              amount: bill["kissanamt"],
              date: bill["date"],
              khataId: kissandoc.docs[0]["khata_id"].toString(),
              transactionId: kissanNewTransactionId,
              transactionType: "DEBIT",
              userId: kissanId.toString())
          .convertTomap();
      //kissan transaction

      final vyapariKhataRef =
          firebase.collection("vyapari_khata").doc(vyaparidocId);
      final vyapariTransactionRef =
          firebase.collection("vyapari_transaction").doc();
      final kissanTransactionRef =
          firebase.collection("kissan_transaction").doc();
      final kissanKhataRef =
          firebase.collection("kissan_khata").doc(kissandocId);

      batch.set(billsRef, bill);
      batch.update(vyapariKhataRef, {"Total": vyapariTotal, "Due": vyapariDue});
      batch.update(kissanKhataRef, {"Total": kissanTotal, "Due": kissanDue});
      batch.set(vyapariTransactionRef, vyapariTransaction);
      batch.set(kissanTransactionRef, kissanTransaction);
      //final to comit batch
      await batch.commit();
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  ///multikissan bill and khata
  Future addMultiKissanbillAndKhataAmountupdate(
    Map<String, dynamic> bill,
    List<Map<String, dynamic>> multikissanList,
  ) async {
    try {
      WriteBatch batch = firebase.batch();
      //adding bill
      final billsRef = firebase.collection("Bills").doc();
      batch.set(billsRef, bill);

      for (var element in multikissanList) {
        final subCollectionRef = firebase
            .collection("Bills")
            .doc(billsRef.id)
            .collection("multikissan_names")
            .doc();

        batch.set(subCollectionRef, element);
      }

      // Perform the transaction

      //khata updation vyapari
      QuerySnapshot vyaparidoc = await firebase
          .collection("vyapari_khata")
          .where("vyapari_id", isEqualTo: bill["vyapari_id"])
          .get();

      final vyaparidocId = vyaparidoc.docs[0].id;

      double vyapariTotal = vyaparidoc.docs[0]["Total"] + bill["grandtotal"];
      double vyapariDue = vyapariTotal - vyaparidoc.docs[0]["Recieved"];
      final vyapariKhataRef =
          firebase.collection("vyapari_khata").doc(vyaparidocId);
      batch.update(vyapariKhataRef, {"Total": vyapariTotal, "Due": vyapariDue});

      //khata updation vyapari
      //vyapari transaction
      QuerySnapshot vyapariTransactiondoc = await firebase
          .collection("vyapari_transaction")
          .orderBy("transaction_id", descending: true)
          .limit(1)
          .get();

      int vyapariNewTransactionId =
          vyapariTransactiondoc.docs[0]["transaction_id"] + 1;
      Map<String, dynamic> vyapariTransaction = TransactionModel(
              billno: bill["bill_no"],
              amount: bill["grandtotal"],
              date: bill["date"],
              khataId: vyaparidoc.docs[0]["khata_id"].toString(),
              transactionId: vyapariNewTransactionId,
              transactionType: "DEBIT",
              userId: bill["vyapari_id"].toString())
          .convertTomap();

      final vyapariTransactionRef =
          firebase.collection("vyapari_transaction").doc();
      batch.set(vyapariTransactionRef, vyapariTransaction);
      //vyapari transaction

      //khata update multikissan and kelagroup

      for (var element in multikissanList) {
        if (element["iskelagroup"]) {
          //khata kelagroup
          QuerySnapshot kelagroupdoc = await firebase
              .collection("kelagroup_khata")
              .where("kelagroup_id", isEqualTo: element["user_id"])
              .get();

          final kelagroupdocId = kelagroupdoc.docs[0].id;

          double kelagroupTotal =
              kelagroupdoc.docs[0]["Total"] + element["amount"];
          double kelagroupDue =
              kelagroupTotal - kelagroupdoc.docs[0]["Recieved"];

          final kelagroupKhataRef =
              firebase.collection("kelagroup_khata").doc(kelagroupdocId);
          batch.update(kelagroupKhataRef,
              {"Total": kelagroupTotal, "Due": kelagroupDue});
          //khata kelagroup

          //kelagroup transaction
          QuerySnapshot kelagroupTransactiondoc = await firebase
              .collection("kelagroup_transaction")
              .orderBy("transaction_id", descending: true)
              .limit(1)
              .get();

          int kelagroupNewTransactionId =
              kelagroupTransactiondoc.docs[0]["transaction_id"] + 1;
          Map<String, dynamic> kelagroupTransaction = TransactionModel(
                  billno: bill["bill_no"],
                  amount: element["amount"],
                  date: bill["date"],
                  khataId: kelagroupdoc.docs[0]["khata_id"].toString(),
                  transactionId: kelagroupNewTransactionId,
                  transactionType: "DEBIT",
                  userId: element["kelagroup_id"].toString())
              .convertTomap();

          final kelagroupTransactionRef =
              firebase.collection("kelagroup_transaction").doc();
          batch.set(kelagroupTransactionRef, kelagroupTransaction);
          //kelagroup transaction
        } else {
          //kissan khata
          QuerySnapshot kissandoc = await firebase
              .collection("kissan_khata")
              .where("kissan_id", isEqualTo: element["user_id"])
              .get();

          final kissandocId = kissandoc.docs[0].id;
          double kissanTotal = kissandoc.docs[0]["Total"] + element["amount"];
          double kissanDue = kissanTotal - kissandoc.docs[0]["Recieved"];

          final kissanKhataRef =
              firebase.collection("kissan_khata").doc(kissandocId);
          batch
              .update(kissanKhataRef, {"Total": kissanTotal, "Due": kissanDue});
          //kissan khata
          //kissan transaction
          QuerySnapshot kissanTransactiondoc = await firebase
              .collection("kissan_transaction")
              .orderBy("transaction_id", descending: true)
              .limit(1)
              .get();

          int kissanNewTransactionId =
              kissanTransactiondoc.docs[0]["transaction_id"] + 1;

          Map<String, dynamic> kissanTransaction = TransactionModel(
                  billno: bill["bill_no"],
                  amount: element["amount"],
                  date: bill["date"],
                  khataId: kissandoc.docs[0]["khata_id"].toString(),
                  transactionId: kissanNewTransactionId,
                  transactionType: "DEBIT",
                  userId: element["kissan_id"].toString())
              .convertTomap();

          final kissanTransactionRef =
              firebase.collection("kissan_transaction").doc();
          batch.set(kissanTransactionRef, kissanTransaction);
          //kissan transaction
        }
      }
      //khata update multikissan and kelagroup

      //final to comit batch
      await batch.commit();
    } on FirebaseException catch (e) {
      print("${e}jjjjj");
      throw Exception(e.toString());
    } catch (e) {
      print("${e}jjjjj");
      throw Exception(e.toString());
    }
  }
}
