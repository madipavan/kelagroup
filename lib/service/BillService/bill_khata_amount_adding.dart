import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelawin/Models/firmtransaction_model.dart';
import 'package:kelawin/Models/transaction_model.dart';

class BillandKhataAmountAdding {
  final firebase = FirebaseFirestore.instance;
  Future addBillandVyapariKhataAmountupdate(
    Map<String, dynamic> bill,
  ) async {
    try {
      WriteBatch batch = firebase.batch();
      //getting billnumber
      int invoiceno = await generateUniqueBillNumber();
      bill["invoiceno"] = invoiceno;
      //getting billnumber
      //adding bill
      final billsRef = firebase.collection("Bills").doc();
      // Perform the transaction

      //khata updation vyapari
      QuerySnapshot vyaparidoc = await firebase
          .collection("Khata")
          .where("userId", isEqualTo: bill["vyapariid"])
          .get();

      final vyaparidocId = vyaparidoc.docs[0].id;
      double vyapariTotal = vyaparidoc.docs[0]["total"] + bill["grandtotal"];
      double vyapariDue = vyapariTotal - vyaparidoc.docs[0]["received"];

      //khata updation vyapari

      //vyapari transaction
      QuerySnapshot vyapariTransactiondoc = await firebase
          .collection("vyapari_transaction")
          .orderBy("transactionId", descending: true)
          .limit(1)
          .get();

      int vyapariNewTransactionId =
          vyapariTransactiondoc.docs[0]["transactionId"] + 1;
      Map<String, dynamic> vyapariTransaction = TransactionModel(
              invoiceno: bill["invoiceno"],
              amount: bill["grandtotal"],
              date: bill["date"],
              khataId: vyaparidoc.docs[0]["khataId"],
              transactionId: vyapariNewTransactionId,
              transactionType: "DEBIT",
              userId: bill["vyapariid"])
          .convertTomap();
      //vyapari transaction

      //khata updation kissan
      QuerySnapshot kissandoc = await firebase
          .collection("Khata")
          .where("userId", isEqualTo: bill["kissanid"])
          .get();

      final kissandocId = kissandoc.docs[0].id;
      double kissanTotal = kissandoc.docs[0]["total"] + bill["kissanamt"];
      double kissanDue = kissanTotal - kissandoc.docs[0]["received"];

      //khata updation kissan
      //kissan transaction
      QuerySnapshot kissanTransactiondoc = await firebase
          .collection("kissan_transaction")
          .orderBy("transactionId", descending: true)
          .limit(1)
          .get();

      int kissanNewTransactionId =
          kissanTransactiondoc.docs[0]["transactionId"] + 1;
      Map<String, dynamic> kissanTransaction = TransactionModel(
              invoiceno: bill["invoiceno"],
              amount: bill["kissanamt"],
              date: bill["date"],
              khataId: kissandoc.docs[0]["khataId"],
              transactionId: kissanNewTransactionId,
              transactionType: "CREDIT",
              userId: bill["kissanid"])
          .convertTomap();
      //kissan transaction
      //mandi transaction
      DocumentReference<Map<String, dynamic>> mandiKhatadoc =
          firebase.collection("firm_khata").doc("mandi");
      batch
          .update(mandiKhatadoc, {"total": FieldValue.increment(bill["mtax"])});
      final mandiTransactionRef = firebase.collection("firm_transaction").doc();
      Map<String, dynamic> mandiTransaction = FirmtransactionModel(
              transactionType: "CREDIT",
              khataId: "mandi",
              invoiceno: bill["invoiceno"],
              amount: bill["mtax"])
          .convertTomap();
      batch.set(mandiTransactionRef, mandiTransaction);
      //mandi transaction
      //hammali transaction
      DocumentReference<Map<String, dynamic>> hammaliKhatadoc =
          firebase.collection("firm_khata").doc("hammali");
      batch.update(
          hammaliKhatadoc, {"total": FieldValue.increment(bill["hammali"])});
      final hammaliTransactionRef =
          firebase.collection("firm_transaction").doc();
      Map<String, dynamic> hammaliTransaction = FirmtransactionModel(
              transactionType: "CREDIT",
              khataId: "hammali",
              invoiceno: bill["invoiceno"],
              amount: bill["hammali"])
          .convertTomap();
      batch.set(hammaliTransactionRef, hammaliTransaction);
      //hammali transaction
      //commission transaction
      DocumentReference<Map<String, dynamic>> commissionKhatadoc =
          firebase.collection("firm_khata").doc("commission");
      batch.update(commissionKhatadoc,
          {"total": FieldValue.increment(bill["commission"])});
      final commissionTransactionRef =
          firebase.collection("firm_transaction").doc();
      Map<String, dynamic> commissionTransaction = FirmtransactionModel(
              transactionType: "CREDIT",
              khataId: "commission",
              invoiceno: bill["invoiceno"],
              amount: bill["commission"])
          .convertTomap();
      batch.set(commissionTransactionRef, commissionTransaction);
      //commission transaction
      //ot transaction
      DocumentReference<Map<String, dynamic>> otKhatadoc =
          firebase.collection("firm_khata").doc("ot");
      batch.update(otKhatadoc, {"total": FieldValue.increment(bill["ot"])});
      final otTransactionRef = firebase.collection("firm_transaction").doc();
      Map<String, dynamic> otTransaction = FirmtransactionModel(
              transactionType: "CREDIT",
              khataId: "ot",
              invoiceno: bill["invoiceno"],
              amount: bill["ot"])
          .convertTomap();
      batch.set(otTransactionRef, otTransaction);
      //ot transaction
      //tcs transaction
      DocumentReference<Map<String, dynamic>> tcsKhatadoc =
          firebase.collection("firm_khata").doc("tcs");
      batch.update(tcsKhatadoc, {"total": FieldValue.increment(bill["tcs"])});
      final tcsTransactionRef = firebase.collection("firm_transaction").doc();
      Map<String, dynamic> tcsTransaction = FirmtransactionModel(
              transactionType: "CREDIT",
              khataId: "tcs",
              invoiceno: bill["invoiceno"],
              amount: bill["tcs"])
          .convertTomap();
      batch.set(tcsTransactionRef, tcsTransaction);
      //tcs transaction
      //tds transaction
      DocumentReference<Map<String, dynamic>> tdsKhatadoc =
          firebase.collection("firm_khata").doc("tds");
      batch.update(tdsKhatadoc, {"total": FieldValue.increment(bill["tds"])});
      final tdsTransactionRef = firebase.collection("firm_transaction").doc();
      Map<String, dynamic> tdsTransaction = FirmtransactionModel(
              transactionType: "CREDIT",
              khataId: "tds",
              invoiceno: bill["invoiceno"],
              amount: bill["tds"])
          .convertTomap();
      batch.set(tdsTransactionRef, tdsTransaction);
      //tds transaction

      final vyapariKhataRef = firebase.collection("Khata").doc(vyaparidocId);
      final vyapariTransactionRef =
          firebase.collection("vyapari_transaction").doc();
      final kissanTransactionRef =
          firebase.collection("kissan_transaction").doc();
      final kissanKhataRef = firebase.collection("Khata").doc(kissandocId);

      batch.set(billsRef, bill);
      batch.update(vyapariKhataRef, {"total": vyapariTotal, "due": vyapariDue});
      batch.update(kissanKhataRef, {"total": kissanTotal, "due": kissanDue});
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
      //getting billnumber
      int invoiceno = await generateUniqueBillNumber();
      bill["invoiceno"] = invoiceno;
      //getting billnumber
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
          .collection("Khata")
          .where("userId", isEqualTo: bill["vyapariid"])
          .get();

      final vyaparidocId = vyaparidoc.docs[0].id;

      double vyapariTotal = vyaparidoc.docs[0]["total"] + bill["grandtotal"];
      double vyapariDue = vyapariTotal - vyaparidoc.docs[0]["received"];
      final vyapariKhataRef = firebase.collection("Khata").doc(vyaparidocId);
      batch.update(vyapariKhataRef, {"total": vyapariTotal, "due": vyapariDue});

      //khata updation vyapari
      //vyapari transaction
      QuerySnapshot vyapariTransactiondoc = await firebase
          .collection("vyapari_transaction")
          .orderBy("transactionId", descending: true)
          .limit(1)
          .get();

      int vyapariNewTransactionId =
          vyapariTransactiondoc.docs[0]["transactionId"] + 1;
      Map<String, dynamic> vyapariTransaction = TransactionModel(
              invoiceno: bill["invoiceno"],
              amount: bill["grandtotal"],
              date: bill["date"],
              khataId: vyaparidoc.docs[0]["khataId"],
              transactionId: vyapariNewTransactionId,
              transactionType: "DEBIT",
              userId: bill["vyapariid"])
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
              .collection("Khata")
              .where("userId", isEqualTo: element["userId"])
              .get();

          final kelagroupdocId = kelagroupdoc.docs[0].id;

          double kelagroupTotal =
              kelagroupdoc.docs[0]["total"] + element["amount"];
          double kelagroupDue =
              kelagroupTotal - kelagroupdoc.docs[0]["received"];

          final kelagroupKhataRef =
              firebase.collection("Khata").doc(kelagroupdocId);
          batch.update(kelagroupKhataRef,
              {"total": kelagroupTotal, "due": kelagroupDue});
          //khata kelagroup

          //kelagroup transaction
          QuerySnapshot kelagroupTransactiondoc = await firebase
              .collection("kelagroup_transaction")
              .orderBy("transactionId", descending: true)
              .limit(1)
              .get();

          int kelagroupNewTransactionId =
              kelagroupTransactiondoc.docs[0]["transactionId"] + 1;
          Map<String, dynamic> kelagroupTransaction = TransactionModel(
                  invoiceno: bill["invoiceno"],
                  amount: element["amount"],
                  date: bill["date"],
                  khataId: kelagroupdoc.docs[0]["khataId"],
                  transactionId: kelagroupNewTransactionId,
                  transactionType: "CREDIT",
                  userId: element["userId"])
              .convertTomap();

          final kelagroupTransactionRef =
              firebase.collection("kelagroup_transaction").doc();
          batch.set(kelagroupTransactionRef, kelagroupTransaction);
          //kelagroup transaction
        } else {
          //kissan khata
          QuerySnapshot kissandoc = await firebase
              .collection("Khata")
              .where("userId", isEqualTo: element["userId"])
              .get();

          final kissandocId = kissandoc.docs[0].id;
          double kissanTotal = kissandoc.docs[0]["total"] + element["amount"];
          double kissanDue = kissanTotal - kissandoc.docs[0]["received"];

          final kissanKhataRef = firebase.collection("Khata").doc(kissandocId);
          batch
              .update(kissanKhataRef, {"total": kissanTotal, "due": kissanDue});
          //kissan khata
          //kissan transaction
          QuerySnapshot kissanTransactiondoc = await firebase
              .collection("kissan_transaction")
              .orderBy("transactionId", descending: true)
              .limit(1)
              .get();

          int kissanNewTransactionId =
              kissanTransactiondoc.docs[0]["transactionId"] + 1;

          Map<String, dynamic> kissanTransaction = TransactionModel(
                  invoiceno: bill["invoiceno"],
                  amount: element["amount"],
                  date: bill["date"],
                  khataId: kissandoc.docs[0]["khataId"],
                  transactionId: kissanNewTransactionId,
                  transactionType: "CREDIT",
                  userId: element["userId"])
              .convertTomap();

          final kissanTransactionRef =
              firebase.collection("kissan_transaction").doc();
          batch.set(kissanTransactionRef, kissanTransaction);
          //kissan transaction
        }
      }
      //khata update multikissan and kelagroup

      //mandi transaction
      DocumentReference<Map<String, dynamic>> mandiKhatadoc =
          firebase.collection("firm_khata").doc("mandi");
      batch
          .update(mandiKhatadoc, {"total": FieldValue.increment(bill["mtax"])});
      final mandiTransactionRef = firebase.collection("firm_transaction").doc();
      Map<String, dynamic> mandiTransaction = FirmtransactionModel(
              transactionType: "CREDIT",
              khataId: "mandi",
              invoiceno: bill["invoiceno"],
              amount: bill["mtax"])
          .convertTomap();
      batch.set(mandiTransactionRef, mandiTransaction);
      //mandi transaction
      //hammali transaction
      DocumentReference<Map<String, dynamic>> hammaliKhatadoc =
          firebase.collection("firm_khata").doc("hammali");
      batch.update(
          hammaliKhatadoc, {"total": FieldValue.increment(bill["hammali"])});
      final hammaliTransactionRef =
          firebase.collection("firm_transaction").doc();
      Map<String, dynamic> hammaliTransaction = FirmtransactionModel(
              transactionType: "CREDIT",
              khataId: "hammali",
              invoiceno: bill["invoiceno"],
              amount: bill["hammali"])
          .convertTomap();
      batch.set(hammaliTransactionRef, hammaliTransaction);
      //hammali transaction
      //commission transaction
      DocumentReference<Map<String, dynamic>> commissionKhatadoc =
          firebase.collection("firm_khata").doc("commission");
      batch.update(commissionKhatadoc,
          {"total": FieldValue.increment(bill["commission"])});
      final commissionTransactionRef =
          firebase.collection("firm_transaction").doc();
      Map<String, dynamic> commissionTransaction = FirmtransactionModel(
              transactionType: "CREDIT",
              khataId: "commission",
              invoiceno: bill["invoiceno"],
              amount: bill["commission"])
          .convertTomap();
      batch.set(commissionTransactionRef, commissionTransaction);
      //commission transaction
      //ot transaction
      DocumentReference<Map<String, dynamic>> otKhatadoc =
          firebase.collection("firm_khata").doc("ot");
      batch.update(otKhatadoc, {"total": FieldValue.increment(bill["ot"])});
      final otTransactionRef = firebase.collection("firm_transaction").doc();
      Map<String, dynamic> otTransaction = FirmtransactionModel(
              transactionType: "CREDIT",
              khataId: "ot",
              invoiceno: bill["invoiceno"],
              amount: bill["ot"])
          .convertTomap();
      batch.set(otTransactionRef, otTransaction);
      //ot transaction
      //tcs transaction
      DocumentReference<Map<String, dynamic>> tcsKhatadoc =
          firebase.collection("firm_khata").doc("tcs");
      batch.update(tcsKhatadoc, {"total": FieldValue.increment(bill["tcs"])});
      final tcsTransactionRef = firebase.collection("firm_transaction").doc();
      Map<String, dynamic> tcsTransaction = FirmtransactionModel(
              transactionType: "CREDIT",
              khataId: "tcs",
              invoiceno: bill["invoiceno"],
              amount: bill["tcs"])
          .convertTomap();
      batch.set(tcsTransactionRef, tcsTransaction);
      //tcs transaction
      //tds transaction
      DocumentReference<Map<String, dynamic>> tdsKhatadoc =
          firebase.collection("firm_khata").doc("tds");
      batch.update(tdsKhatadoc, {"total": FieldValue.increment(bill["tds"])});
      final tdsTransactionRef = firebase.collection("firm_transaction").doc();
      Map<String, dynamic> tdsTransaction = FirmtransactionModel(
              transactionType: "CREDIT",
              khataId: "tds",
              invoiceno: bill["invoiceno"],
              amount: bill["tds"])
          .convertTomap();
      batch.set(tdsTransactionRef, tdsTransaction);
      //tds transaction
      //final to comit batch
      await batch.commit();
    } on FirebaseException catch (e) {
      print("${e}error in adding bill on server");
      throw Exception(e.toString());
    } catch (e) {
      print("${e}error in adding bill on server");
      throw Exception(e.toString());
    }
  }

  //generating number
  Future<int> generateUniqueBillNumber() async {
    final billsRef = FirebaseFirestore.instance.collection('Bills');

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the last bill (sorted by bill_number in descending order)
      final lastBillQuery =
          await billsRef.orderBy('invoiceno', descending: true).limit(1).get();

      int lastBillNumber = 0; // Default starting number if no bills exist
      if (lastBillQuery.docs.isNotEmpty) {
        lastBillNumber = lastBillQuery.docs.first.data()['invoiceno'];
      }

      int newBillNumber = lastBillNumber + 1;

      return newBillNumber;
    });
  }
}
