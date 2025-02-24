import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelawin/Models/billmodel.dart';
import 'package:kelawin/Models/firmtransaction_model.dart';
import 'package:kelawin/Models/multikissan_model.dart';
import 'package:kelawin/Models/transaction_model.dart';
import 'package:synchronized/synchronized.dart';

import '../KhataService/add_delete_transaction_service.dart';

class BillandKhataAmountAdding {
  final firebase = FirebaseFirestore.instance;
  Future addBillandVyapariKhataAmountupdate(
    Map<String, dynamic> bill,
  ) async {
    try {
      WriteBatch batch = firebase.batch();

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
      Map<String, dynamic> vyapariTransaction = TransactionModel(
              vocherType: "BILL",
              invoiceno: bill["invoiceno"],
              amount: bill["grandtotal"],
              date: bill["date"],
              khataId: vyaparidoc.docs[0]["khataId"],
              transactionId: await AddDeleteTransactionService()
                  .generateUniqueTransactionId("vyapari"),
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

      Map<String, dynamic> kissanTransaction = TransactionModel(
              vocherType: "BILL",
              invoiceno: bill["invoiceno"],
              amount: bill["kissanamt"],
              date: bill["date"],
              khataId: kissandoc.docs[0]["khataId"],
              transactionId: await AddDeleteTransactionService()
                  .generateUniqueTransactionId("kissan"),
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
              amount: double.parse(bill["ot"].toString()))
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

      //adding bill
      final billsRef = firebase.collection("Bills").doc();
      batch.set(billsRef, bill);
      final subCollectionRef = firebase
          .collection("Bills")
          .doc(billsRef.id)
          .collection("multikissan_names")
          .doc();
      for (var element in multikissanList) {
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

      Map<String, dynamic> vyapariTransaction = TransactionModel(
              vocherType: "BILL",
              invoiceno: bill["invoiceno"],
              amount: bill["grandtotal"],
              date: bill["date"],
              khataId: vyaparidoc.docs[0]["khataId"],
              transactionId: await AddDeleteTransactionService()
                  .generateUniqueTransactionId("vyapari"),
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

          Map<String, dynamic> kelagroupTransaction = TransactionModel(
                  vocherType: "BILL",
                  invoiceno: bill["invoiceno"],
                  amount: element["amount"],
                  date: bill["date"],
                  khataId: kelagroupdoc.docs[0]["khataId"],
                  transactionId: await AddDeleteTransactionService()
                      .generateUniqueTransactionId("kelagroup"),
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

          Map<String, dynamic> kissanTransaction = TransactionModel(
                  vocherType: "BILL",
                  invoiceno: bill["invoiceno"],
                  amount: element["amount"],
                  date: bill["date"],
                  khataId: kissandoc.docs[0]["khataId"],
                  transactionId: await AddDeleteTransactionService()
                      .generateUniqueTransactionId("kissan"),
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
              amount: double.parse(bill["ot"].toString()))
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
  Future<int> generateUniqueinvoiceId() async {
    int newinvoiceId = 0;

    try {
      final lock = Lock();
      await lock.synchronized(() async {
        return await FirebaseFirestore.instance
            .runTransaction((transaction) async {
          final billIdCounterRef = FirebaseFirestore.instance
              .collection('idCounters')
              .doc("billIdCounter");
          DocumentSnapshot counterDoc = await transaction.get(billIdCounterRef);

          int lastinvoiceId = 0; // Default starting number if no bills exist

          if (!counterDoc.exists) {
            throw Exception(
                "Counter document is missing! Initialize it first.");
          } else {
            lastinvoiceId = counterDoc.exists
                ? (counterDoc.get("invoiceno") ?? lastinvoiceId)
                : lastinvoiceId;
            newinvoiceId = lastinvoiceId + 1;
            transaction.update(billIdCounterRef, {"invoiceno": newinvoiceId});
          }

          return newinvoiceId;
        });
      });
      return newinvoiceId;
    } on FirebaseException catch (e) {
      throw Exception("${e}Error while creating userKhataId");
    } catch (e) {
      throw Exception("${e}Error while creating userkhataId");
    }
  }

  //edit bill
  Future editBillandVyapariKhataAmount(Map<String, dynamic> bill) async {
    WriteBatch batch = firebase.batch();
    QuerySnapshot<Map<String, dynamic>> billDoc = await firebase
        .collection("Bills")
        .where("invoiceno", isEqualTo: bill["invoiceno"])
        .limit(1)
        .get();
    BillModel oldBill = BillModel.fromJson(billDoc.docs[0].data(), []);

    //updating bill

    batch.update(billDoc.docs[0].reference, bill);
    //updating bill
    //vyapari khata Resettle
    if (oldBill.vyapariid == bill["vyapariid"]) {
      double diffAmt = oldBill.grandtotal - bill["grandtotal"];
      QuerySnapshot vyapariDoc = await firebase
          .collection("Khata")
          .where("userId", isEqualTo: oldBill.vyapariid)
          .get();
      final vyapariKhataRef =
          firebase.collection("Khata").doc(vyapariDoc.docs[0].id);
      batch.update(vyapariKhataRef, {
        "total": FieldValue.increment(diffAmt),
        "due": FieldValue.increment(diffAmt),
      });
      QuerySnapshot transactionDoc = await firebase
          .collection("vyapari_transaction")
          .where("invoiceno", isEqualTo: bill["invoiceno"])
          .where("userId", isEqualTo: oldBill.vyapariid)
          .get();

      batch.update(transactionDoc.docs[0].reference, {
        "amount": FieldValue.increment(diffAmt),
      });
    } else {
      //if vyapari is new
      //settling khaata of old vyapari

      QuerySnapshot oldVyapariDoc = await firebase
          .collection("Khata")
          .where("userId", isEqualTo: oldBill.vyapariid)
          .get();
      final oldvyapariKhataRef =
          firebase.collection("Khata").doc(oldVyapariDoc.docs[0].id);
      batch.update(oldvyapariKhataRef, {
        "total": FieldValue.increment(-oldBill.grandtotal),
        "due": FieldValue.increment(-oldBill.grandtotal),
      });
      QuerySnapshot transactionDoc = await firebase
          .collection("vyapari_transaction")
          .where("invoiceno", isEqualTo: bill["invoiceno"])
          .where("userId", isEqualTo: oldBill.vyapariid)
          .get();

      batch.delete(transactionDoc.docs[0].reference);

      //settling new vyapari khata

      QuerySnapshot newVyaparikhataDoc = await firebase
          .collection("Khata")
          .where("userId", isEqualTo: bill["vyapariid"])
          .get();
      final newVyapariKhataRef =
          firebase.collection("Khata").doc(newVyaparikhataDoc.docs[0].id);
      batch.update(newVyapariKhataRef, {
        "total": FieldValue.increment(bill["grandtotal"]),
        "due": FieldValue.increment(bill["grandtotal"]),
      });

      final newVyapariTransactionRef =
          firebase.collection("vyapari_transaction").doc();
      Map<String, dynamic> newVyapariTransaction = TransactionModel(
              vocherType: "BILL",
              invoiceno: bill["invoiceno"],
              amount: bill["grandtotal"],
              date: bill["date"],
              khataId: newVyaparikhataDoc.docs[0]["khataId"],
              transactionId: await AddDeleteTransactionService()
                  .generateUniqueTransactionId("vyapari"),
              transactionType: "DEBIT",
              userId: bill["vyapariid"])
          .convertTomap();
      batch.set(newVyapariTransactionRef, newVyapariTransaction);
      //settling new vyapari khata
    }

    //vyapari khata Resettle
    //settling kissan khaatass

    BillModel newBill = BillModel.fromJson(bill, []);
    if (oldBill.kissanid == newBill.kissanid) {
      //settling old kissan khata
      double diffKissanAmt = oldBill.kissanamt - bill["kissanamt"];
      QuerySnapshot oldKissanDoc = await firebase
          .collection("Khata")
          .where("userId", isEqualTo: oldBill.kissanid)
          .get();

      batch.update(oldKissanDoc.docs[0].reference, {
        "total": FieldValue.increment(diffKissanAmt),
        "due": FieldValue.increment(diffKissanAmt),
      });
      QuerySnapshot oldKissantransactionDoc = await firebase
          .collection("kissan_transaction")
          .where("invoiceno", isEqualTo: bill["invoiceno"])
          .where("userId", isEqualTo: oldBill.kissanid)
          .limit(1)
          .get();

      batch.update(oldKissantransactionDoc.docs[0].reference, {
        "amount": FieldValue.increment(diffKissanAmt),
      });
    } else {
      //if kissan is new
      //settling khaata of old kissan

      QuerySnapshot oldKissanDoc = await firebase
          .collection("Khata")
          .where("userId", isEqualTo: oldBill.kissanid)
          .get();
      batch.update(oldKissanDoc.docs[0].reference, {
        "total": FieldValue.increment(-oldBill.kissanamt),
        "due": FieldValue.increment(-oldBill.kissanamt),
      });
      QuerySnapshot oldkissantransactionDoc = await firebase
          .collection("kissan_transaction")
          .where("invoiceno", isEqualTo: bill["invoiceno"])
          .where("userId", isEqualTo: oldBill.kissanid)
          .limit(1)
          .get();
      batch.delete(oldkissantransactionDoc.docs[0].reference);

      //settling new kissan khata

      QuerySnapshot newKissankhataDoc = await firebase
          .collection("Khata")
          .where("userId", isEqualTo: newBill.kissanid)
          .limit(1)
          .get();

      batch.update(newKissankhataDoc.docs[0].reference, {
        "total": FieldValue.increment(newBill.kissanamt),
        "due": FieldValue.increment(newBill.kissanamt),
      });

      final newKissanTransactionRef =
          firebase.collection("kissan_transaction").doc();
      Map<String, dynamic> newKissanTransaction = TransactionModel(
              vocherType: "BILL",
              invoiceno: newBill.invoiceno,
              amount: newBill.kissanamt,
              date: newBill.date,
              khataId: newKissankhataDoc.docs[0]["khataId"],
              transactionId: await AddDeleteTransactionService()
                  .generateUniqueTransactionId("kissan"),
              transactionType: "CREDIT",
              userId: newBill.kissanid)
          .convertTomap();
      batch.set(newKissanTransactionRef, newKissanTransaction);
      //settling new kissan khata
    }

    //settling other khata

    //mandi transaction

    {
      double mtaxAmtDiff = oldBill.mtax - newBill.mtax;
      DocumentReference<Map<String, dynamic>> mandiKhatadoc =
          firebase.collection("firm_khata").doc("mandi");
      batch.update(mandiKhatadoc, {"total": FieldValue.increment(mtaxAmtDiff)});
      QuerySnapshot manditransactionDoc = await firebase
          .collection("firm_transaction")
          .where("invoiceno", isEqualTo: bill["invoiceno"])
          .where("khataId", isEqualTo: "mandi")
          .limit(1)
          .get();
      batch.update(manditransactionDoc.docs[0].reference,
          {"amount": FieldValue.increment(mtaxAmtDiff)});
    }
    //mandi transaction
    //commission transaction

    {
      double commissionAmtDiff = oldBill.commission - newBill.commission;
      DocumentReference<Map<String, dynamic>> commissionKhatadoc =
          firebase.collection("firm_khata").doc("commission");
      batch.update(commissionKhatadoc,
          {"total": FieldValue.increment(commissionAmtDiff)});
      QuerySnapshot commissiontransactionDoc = await firebase
          .collection("firm_transaction")
          .where("invoiceno", isEqualTo: bill["invoiceno"])
          .where("khataId", isEqualTo: "commission")
          .limit(1)
          .get();
      batch.update(commissiontransactionDoc.docs[0].reference,
          {"amount": FieldValue.increment(commissionAmtDiff)});
    }
    //commission transaction
    //hammali transaction

    {
      double hammaliAmtDiff = oldBill.hammali - newBill.hammali;
      DocumentReference<Map<String, dynamic>> hammaliKhatadoc =
          firebase.collection("firm_khata").doc("hammali");
      batch.update(
          hammaliKhatadoc, {"total": FieldValue.increment(hammaliAmtDiff)});
      QuerySnapshot hammalitransactionDoc = await firebase
          .collection("firm_transaction")
          .where("invoiceno", isEqualTo: bill["invoiceno"])
          .where("khataId", isEqualTo: "hammali")
          .limit(1)
          .get();
      batch.update(hammalitransactionDoc.docs[0].reference,
          {"amount": FieldValue.increment(hammaliAmtDiff)});
    }
    //hammali transaction

    // ot transaction

    {
      int otAmtDiff = oldBill.ot - newBill.ot;
      DocumentReference<Map<String, dynamic>> otKhatadoc =
          firebase.collection("firm_khata").doc("ot");
      batch.update(otKhatadoc, {"total": FieldValue.increment(otAmtDiff)});
      QuerySnapshot ottransactionDoc = await firebase
          .collection("firm_transaction")
          .where("invoiceno", isEqualTo: bill["invoiceno"])
          .where("khataId", isEqualTo: "ot")
          .limit(1)
          .get();
      batch.update(ottransactionDoc.docs[0].reference,
          {"amount": FieldValue.increment(otAmtDiff)});
    }
    // ot transaction
    // tcs transaction

    {
      double tcsAmtDiff = oldBill.tcs - newBill.tcs;
      DocumentReference<Map<String, dynamic>> tcsKhatadoc =
          firebase.collection("firm_khata").doc("tcs");
      batch.update(tcsKhatadoc, {"total": FieldValue.increment(tcsAmtDiff)});
      QuerySnapshot tcstransactionDoc = await firebase
          .collection("firm_transaction")
          .where("invoiceno", isEqualTo: bill["invoiceno"])
          .where("khataId", isEqualTo: "tcs")
          .limit(1)
          .get();
      batch.update(tcstransactionDoc.docs[0].reference,
          {"amount": FieldValue.increment(tcsAmtDiff)});
    }
    // tcs transaction
    // tds transaction

    {
      double tdsAmtDiff = oldBill.tds - newBill.tds;
      DocumentReference<Map<String, dynamic>> tdsKhatadoc =
          firebase.collection("firm_khata").doc("tds");
      batch.update(tdsKhatadoc, {"total": FieldValue.increment(tdsAmtDiff)});
      QuerySnapshot tdstransactionDoc = await firebase
          .collection("firm_transaction")
          .where("invoiceno", isEqualTo: bill["invoiceno"])
          .where("khataId", isEqualTo: "tds")
          .limit(1)
          .get();
      batch.update(tdstransactionDoc.docs[0].reference,
          {"amount": FieldValue.increment(tdsAmtDiff)});
    }
    // tds transaction
    //batch commit
    await batch.commit();
    //
  }

  //multikissan bill edit
  Future editMultiKissanBillandVyapariKhataAmount(Map<String, dynamic> bill,
      List<Map<String, dynamic>> multikissanList) async {
    WriteBatch batch = firebase.batch();
    QuerySnapshot<Map<String, dynamic>> oldbillDoc = await firebase
        .collection("Bills")
        .where("invoiceno", isEqualTo: bill["invoiceno"])
        .limit(1)
        .get();

    final oldbillsubCollection = await firebase
        .collection("Bills")
        .doc(oldbillDoc.docs[0].id)
        .collection("multikissan_names")
        .get();
    //updating bill

    batch.update(oldbillDoc.docs[0].reference, bill);
    //updating bill
    for (var element in oldbillsubCollection.docs) {
      batch.delete(element.reference);
    }
    for (var element in multikissanList) {
      batch.set(oldbillsubCollection.docs[0].reference, element);
    }

    //to covert into mukissanmodel
    List<MultikissanModel> oldBillMultikissanList = [];
    for (var element in oldbillsubCollection.docs) {
      oldBillMultikissanList.add(MultikissanModel.toJson(element.data()));
    }

    BillModel oldBill =
        BillModel.fromJson(oldbillDoc.docs[0].data(), oldBillMultikissanList);

    //vyapari khata Resettle
    if (oldBill.vyapariid == bill["vyapariid"]) {
      double diffAmt = oldBill.grandtotal - bill["grandtotal"];
      QuerySnapshot vyapariDoc = await firebase
          .collection("Khata")
          .where("userId", isEqualTo: oldBill.vyapariid)
          .get();
      final vyapariKhataRef =
          firebase.collection("Khata").doc(vyapariDoc.docs[0].id);
      batch.update(vyapariKhataRef, {
        "total": FieldValue.increment(diffAmt),
        "due": FieldValue.increment(diffAmt),
      });
      QuerySnapshot transactionDoc = await firebase
          .collection("vyapari_transaction")
          .where("invoiceno", isEqualTo: bill["invoiceno"])
          .where("userId", isEqualTo: oldBill.vyapariid)
          .get();

      batch.update(transactionDoc.docs[0].reference, {
        "amount": FieldValue.increment(diffAmt),
      });
    } else {
      //if vyapari is new
      //settling khaata of old vyapari

      QuerySnapshot oldVyapariDoc = await firebase
          .collection("Khata")
          .where("userId", isEqualTo: oldBill.vyapariid)
          .get();
      final oldvyapariKhataRef =
          firebase.collection("Khata").doc(oldVyapariDoc.docs[0].id);
      batch.update(oldvyapariKhataRef, {
        "total": FieldValue.increment(-oldBill.grandtotal),
        "due": FieldValue.increment(-oldBill.grandtotal),
      });
      QuerySnapshot transactionDoc = await firebase
          .collection("vyapari_transaction")
          .where("invoiceno", isEqualTo: bill["invoiceno"])
          .where("userId", isEqualTo: oldBill.vyapariid)
          .get();

      batch.delete(transactionDoc.docs[0].reference);

      //settling new vyapari khata

      QuerySnapshot newVyaparikhataDoc = await firebase
          .collection("Khata")
          .where("userId", isEqualTo: bill["vyapariid"])
          .get();
      final newVyapariKhataRef =
          firebase.collection("Khata").doc(newVyaparikhataDoc.docs[0].id);
      batch.update(newVyapariKhataRef, {
        "total": FieldValue.increment(bill["grandtotal"]),
        "due": FieldValue.increment(bill["grandtotal"]),
      });

      final newVyapariTransactionRef =
          firebase.collection("vyapari_transaction").doc();
      Map<String, dynamic> newVyapariTransaction = TransactionModel(
              vocherType: "BILL",
              invoiceno: bill["invoiceno"],
              amount: bill["grandtotal"],
              date: bill["date"],
              khataId: newVyaparikhataDoc.docs[0]["khataId"],
              transactionId: await AddDeleteTransactionService()
                  .generateUniqueTransactionId("vyapari"),
              transactionType: "DEBIT",
              userId: bill["vyapariid"])
          .convertTomap();
      batch.set(newVyapariTransactionRef, newVyapariTransaction);
      //settling new vyapari khata
    }
    //vyapari khata Resettle
    //settling kissan khaatass
    //to covert into mukissanmodel
    List<MultikissanModel> newBillMultikissanList = [];
    for (var element in multikissanList) {
      oldBillMultikissanList.add(MultikissanModel.toJson(element));
    }

    BillModel newBill = BillModel.fromJson(bill, newBillMultikissanList);
    for (MultikissanModel kissan in oldBill.multiKissanList!) {
      String role = kissan.iskelagroup ? "kelagroup" : "kissan";

      QuerySnapshot oldKissanDoc = await firebase
          .collection("Khata")
          .where("userId", isEqualTo: kissan.userId)
          .get();
      batch.update(oldKissanDoc.docs[0].reference, {
        "total": FieldValue.increment(-kissan.amount),
        "due": FieldValue.increment(-kissan.amount),
      });
      QuerySnapshot oldkissantransactionDoc = await firebase
          .collection("${role}_transaction")
          .where("invoiceno", isEqualTo: bill["invoiceno"])
          .where("userId", isEqualTo: kissan.userId)
          .limit(1)
          .get();
      batch.delete(oldkissantransactionDoc.docs[0].reference);
    }
    //for new bill list
    for (MultikissanModel kissan in newBill.multiKissanList!) {
      String role = kissan.iskelagroup ? "kelagroup" : "kissan";
      //settling new kissan khata

      QuerySnapshot newKissankhataDoc = await firebase
          .collection("Khata")
          .where("userId", isEqualTo: kissan.userId)
          .limit(1)
          .get();

      batch.update(newKissankhataDoc.docs[0].reference, {
        "total": FieldValue.increment(kissan.amount),
        "due": FieldValue.increment(kissan.amount),
      });

      final newKissanTransactionRef =
          firebase.collection("${role}_transaction").doc();
      Map<String, dynamic> newKissanTransaction = TransactionModel(
              vocherType: "BILL",
              invoiceno: newBill.invoiceno,
              amount: kissan.amount,
              date: newBill.date,
              khataId: newKissankhataDoc.docs[0]["khataId"],
              transactionId: await AddDeleteTransactionService()
                  .generateUniqueTransactionId(role),
              transactionType: "CREDIT",
              userId: kissan.userId)
          .convertTomap();
      batch.set(newKissanTransactionRef, newKissanTransaction);
      //settling new kissan khata
    }

    //settling other khata

    //mandi transaction

    {
      double mtaxAmtDiff = oldBill.mtax - newBill.mtax;
      DocumentReference<Map<String, dynamic>> mandiKhatadoc =
          firebase.collection("firm_khata").doc("mandi");
      batch.update(mandiKhatadoc, {"total": FieldValue.increment(mtaxAmtDiff)});
      QuerySnapshot manditransactionDoc = await firebase
          .collection("firm_transaction")
          .where("invoiceno", isEqualTo: bill["invoiceno"])
          .where("khataId", isEqualTo: "mandi")
          .limit(1)
          .get();
      batch.update(manditransactionDoc.docs[0].reference,
          {"amount": FieldValue.increment(mtaxAmtDiff)});
    }
    //mandi transaction
    //commission transaction

    {
      double commissionAmtDiff = oldBill.commission - newBill.commission;
      DocumentReference<Map<String, dynamic>> commissionKhatadoc =
          firebase.collection("firm_khata").doc("commission");
      batch.update(commissionKhatadoc,
          {"total": FieldValue.increment(commissionAmtDiff)});
      QuerySnapshot commissiontransactionDoc = await firebase
          .collection("firm_transaction")
          .where("invoiceno", isEqualTo: bill["invoiceno"])
          .where("khataId", isEqualTo: "commission")
          .limit(1)
          .get();
      batch.update(commissiontransactionDoc.docs[0].reference,
          {"amount": FieldValue.increment(commissionAmtDiff)});
    }
    //commission transaction
    //hammali transaction

    {
      double hammaliAmtDiff = oldBill.hammali - newBill.hammali;
      DocumentReference<Map<String, dynamic>> hammaliKhatadoc =
          firebase.collection("firm_khata").doc("hammali");
      batch.update(
          hammaliKhatadoc, {"total": FieldValue.increment(hammaliAmtDiff)});
      QuerySnapshot hammalitransactionDoc = await firebase
          .collection("firm_transaction")
          .where("invoiceno", isEqualTo: bill["invoiceno"])
          .where("khataId", isEqualTo: "hammali")
          .limit(1)
          .get();
      batch.update(hammalitransactionDoc.docs[0].reference,
          {"amount": FieldValue.increment(hammaliAmtDiff)});
    }
    //hammali transaction

    // ot transaction

    {
      int otAmtDiff = oldBill.ot - newBill.ot;
      DocumentReference<Map<String, dynamic>> otKhatadoc =
          firebase.collection("firm_khata").doc("ot");
      batch.update(otKhatadoc, {"total": FieldValue.increment(otAmtDiff)});
      QuerySnapshot ottransactionDoc = await firebase
          .collection("firm_transaction")
          .where("invoiceno", isEqualTo: bill["invoiceno"])
          .where("khataId", isEqualTo: "ot")
          .limit(1)
          .get();
      batch.update(ottransactionDoc.docs[0].reference,
          {"amount": FieldValue.increment(otAmtDiff)});
    }
    // ot transaction
    // tcs transaction

    {
      double tcsAmtDiff = oldBill.tcs - newBill.tcs;
      DocumentReference<Map<String, dynamic>> tcsKhatadoc =
          firebase.collection("firm_khata").doc("tcs");
      batch.update(tcsKhatadoc, {"total": FieldValue.increment(tcsAmtDiff)});
      QuerySnapshot tcstransactionDoc = await firebase
          .collection("firm_transaction")
          .where("invoiceno", isEqualTo: bill["invoiceno"])
          .where("khataId", isEqualTo: "tcs")
          .limit(1)
          .get();
      batch.update(tcstransactionDoc.docs[0].reference,
          {"amount": FieldValue.increment(tcsAmtDiff)});
    }
    // tcs transaction
    // tds transaction

    {
      double tdsAmtDiff = oldBill.tds - newBill.tds;
      DocumentReference<Map<String, dynamic>> tdsKhatadoc =
          firebase.collection("firm_khata").doc("tds");
      batch.update(tdsKhatadoc, {"total": FieldValue.increment(tdsAmtDiff)});
      QuerySnapshot tdstransactionDoc = await firebase
          .collection("firm_transaction")
          .where("invoiceno", isEqualTo: bill["invoiceno"])
          .where("khataId", isEqualTo: "tds")
          .limit(1)
          .get();
      batch.update(tdstransactionDoc.docs[0].reference,
          {"amount": FieldValue.increment(tdsAmtDiff)});
    }
    // tds transaction
    await batch.commit();
  }
}
