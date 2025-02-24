import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelawin/Models/ledgergroup_model.dart';
import 'package:synchronized/synchronized.dart';

class LedgerGroupOperationsService {
  final firebase = FirebaseFirestore.instance;
  Future<List<String>> getAllLedgerGroupType() async {
    List<String> items = [];
    try {
      DocumentSnapshot<Map<String, dynamic>> typeList = await firebase
          .collection("dynamic_list_items")
          .doc("ledgergroupstype")
          .get();
      items = List<String>.from(typeList["items"]);
    } on FirebaseException catch (e) {
      throw Exception("${e}Error while Fetching LedgerGroupType");
    } catch (e) {
      throw Exception("${e}Error while Fetching LedgerGroupType");
    }
    return items;
  }

  Future<List<LedgergroupModel>> getAllLedgerGroup() async {
    List<LedgergroupModel> ledgerGroups = [];
    try {
      QuerySnapshot<Map<String, dynamic>> ledgergroupsList = await firebase
          .collection("LedgerGroups")
          .orderBy("ledgerGroupId", descending: true)
          .get();

      for (var element in ledgergroupsList.docs) {
        ledgerGroups.add(LedgergroupModel.fromJson(element.data()));
      }
    } on FirebaseException catch (e) {
      throw Exception("${e}Error while Fetching LedgerGroup");
    } catch (e) {
      throw Exception("${e}Error while Fetching LedgerGroup");
    }
    return ledgerGroups;
  }

  Future addLedgerGroupType(String ledgerGroupType) async {
    try {
      await firebase
          .collection("dynamic_list_items")
          .doc("ledgergroupstype")
          .update({
        "items": FieldValue.arrayUnion([ledgerGroupType])
      });
    } on FirebaseException catch (e) {
      throw Exception("${e}Error while Adding LedgerGroup");
    } catch (e) {
      throw Exception("${e}Error while Adding LedgerGroup");
    }
  }

  Future addLedgerGroup(LedgergroupModel ledgerGroup) async {
    try {
      Map<String, dynamic> ledgerGroupMap = ledgerGroup.toMap();
      await firebase.collection("LedgerGroups").add(ledgerGroupMap);
    } on FirebaseException catch (e) {
      throw Exception("${e}Error while Adding LedgerGroup");
    } catch (e) {
      throw Exception("${e}Error while Adding LedgerGroup");
    }
  }

  Future deleteLedgerGroup(int ledgerGroupId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> data = await firebase
          .collection("Users")
          .where("ledgerGroupId", isEqualTo: ledgerGroupId)
          .limit(1)
          .get();

      if (data.docs.isEmpty) {
        QuerySnapshot<Map<String, dynamic>> ledgergroupData = await firebase
            .collection("LedgerGroups")
            .where("ledgerGroupId", isEqualTo: ledgerGroupId)
            .get();

        await firebase
            .collection("LedgerGroups")
            .doc(ledgergroupData.docs[0].id)
            .delete();
      } else {
        throw Exception(
            "User has group , it cannot delete : useriD  = : ${data.docs[0]["userId"]}");
      }
    } on FirebaseException catch (e) {
      throw Exception("${e}Error while Deleting LedgerGroup");
    } catch (e) {
      throw Exception("${e}Error while Deleting LedgerGroup");
    }
  }

  Future deleteLedgerGroupType(String ledgerGroupType) async {
    try {
      QuerySnapshot<Map<String, dynamic>> data = await firebase
          .collection("LedgerGroups")
          .where("groupType", isEqualTo: ledgerGroupType)
          .limit(1)
          .get();

      if (data.docs.isEmpty) {
        await firebase
            .collection("dynamic_list_items")
            .doc("ledgergroupstype")
            .update({
          "items": FieldValue.arrayRemove([ledgerGroupType])
        });
      } else {
        throw Exception(
            "LedgerGroup has type , it cannot delete : iD =: ${data.docs[0]["ledgerGroupId"]}");
      }
    } on FirebaseException catch (e) {
      throw Exception("${e}Error while Deleting LedgerGroupType");
    } catch (e) {
      throw Exception("${e}Error while Deleting LedgerGroupType");
    }
  }

  Future<int> generateUniqueLedgerId() async {
    int newLedgerGroupId = 0;

    try {
      final lock = Lock();
      await lock.synchronized(() async {
        return await FirebaseFirestore.instance
            .runTransaction((transaction) async {
          final ledgerGroupIdCounterRef = FirebaseFirestore.instance
              .collection('idCounters')
              .doc("ledgerGroupIdCounter");
          DocumentSnapshot counterDoc =
              await transaction.get(ledgerGroupIdCounterRef);

          int lastledgerGroupId =
              900; // Default starting number if no bills exist

          if (!counterDoc.exists) {
            throw Exception(
                "Counter document is missing! Initialize it first.");
          } else {
            lastledgerGroupId = counterDoc.exists
                ? (counterDoc.get("ledgerGroupId") ?? lastledgerGroupId)
                : lastledgerGroupId;
            newLedgerGroupId = lastledgerGroupId + 1;
            transaction.update(
                ledgerGroupIdCounterRef, {"ledgerGroupId": newLedgerGroupId});
          }

          return newLedgerGroupId;
        });
      });
      return newLedgerGroupId;
    } on FirebaseException catch (e) {
      throw Exception("${e}Error while creating userKhataId");
    } catch (e) {
      throw Exception("${e}Error while creating userkhataId");
    }
  }
}
