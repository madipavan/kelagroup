import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelawin/Models/billmodel.dart';

class GetBillService {
  final firebase = FirebaseFirestore.instance;

  Future<BillModel?> getbill(int billno) async {
    try {
      QuerySnapshot<Map<String, dynamic>> bill = await firebase
          .collection("Bills")
          .where("bill_no", isEqualTo: billno)
          .get();

      if (bill.docs[0]["ismultikissan"]) {
        QuerySnapshot<Map<String, dynamic>> subCollectionBill = await firebase
            .collection("Bills")
            .doc(bill.docs[0].id)
            .collection("multikissan_names")
            .get();
        return BillModel.fromJson(bill.docs[0], subCollectionBill);
      } else {
        return BillModel.fromJson(bill.docs[0], null);
      }
    } on FirebaseException catch (e) {
      print(e);
      throw Exception(e.toString());
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  Future<List<BillModel>> getAllbills() async {
    List<BillModel> allBills = [];
    try {
      QuerySnapshot<Map<String, dynamic>> bills =
          await firebase.collection("Bills").get();

      for (int i = 0; i < bills.docs.length; i++) {
        if (bills.docs[i]["ismultikissan"]) {
          QuerySnapshot<Map<String, dynamic>> subCollectionBill = await firebase
              .collection("Bills")
              .doc(bills.docs[i].id)
              .collection("multikissan_names")
              .get();
          allBills.add(BillModel.fromJson(bills.docs[i], subCollectionBill));
        } else {
          allBills.add(BillModel.fromJson(bills.docs[i], null));
        }
      }

      return allBills;
    } on FirebaseException catch (e) {
      print(e);
      throw Exception(e.toString());
    } catch (e) {
      print("${e}erroe in fetching all bills");
      throw Exception(e.toString());
    }
  }
}
