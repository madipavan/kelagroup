import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelawin/Models/billmodel.dart';
import 'package:kelawin/Models/multikissan_model.dart';

class GetBillService {
  final firebase = FirebaseFirestore.instance;

  Future<BillModel?> getbill(int billno) async {
    try {
      QuerySnapshot<Map<String, dynamic>> bill = await firebase
          .collection("Bills")
          .where("invoiceno", isEqualTo: billno)
          .limit(1)
          .get();

      if (bill.docs[0]["isMultikissan"]) {
        QuerySnapshot<Map<String, dynamic>> subCollectionBill = await firebase
            .collection("Bills")
            .doc(bill.docs[0].id)
            .collection("multikissan_names")
            .get();
        List<MultikissanModel> temp = [];
        for (var element in subCollectionBill.docs) {
          temp.add(MultikissanModel.toJson(element.data()));
        }
        return BillModel.fromJson(bill.docs[0].data(), temp);
      } else {
        return BillModel.fromJson(bill.docs[0].data(), null);
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
      QuerySnapshot<Map<String, dynamic>> bills = await firebase
          .collection("Bills")
          .orderBy("invoiceno", descending: true)
          .get();

      for (int i = 0; i < bills.docs.length; i++) {
        if (bills.docs[i]["isMultikissan"]) {
          QuerySnapshot<Map<String, dynamic>> subCollectionBill = await firebase
              .collection("Bills")
              .doc(bills.docs[i].id)
              .collection("multikissan_names")
              .get();
          List<MultikissanModel> temp = [];
          for (var element in subCollectionBill.docs) {
            temp.add(MultikissanModel.toJson(element.data()));
          }
          allBills.add(BillModel.fromJson(bills.docs[i].data(), temp));
        } else {
          allBills.add(BillModel.fromJson(bills.docs[i].data(), null));
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
