import 'package:cloud_firestore/cloud_firestore.dart';

class BranchCrudOperationsService {
  final firebase = FirebaseFirestore.instance;
  Future<List<String>> getAllBranch() async {
    List<String> items = [];
    try {
      DocumentSnapshot<Map<String, dynamic>> branchList =
          await firebase.collection("dynamic_list_items").doc("branch").get();
      items = List<String>.from(branchList["branch"]);
    } on FirebaseException catch (e) {
      throw Exception("${e}Error while Fetching Branch");
    } catch (e) {
      throw Exception("${e}Error while Fetching Branch");
    }
    return items;
  }

  Future addBranch(String branchName) async {
    try {
      await firebase.collection("dynamic_list_items").doc("branch").update({
        "branch": FieldValue.arrayUnion([branchName])
      });
    } on FirebaseException catch (e) {
      throw Exception("${e}Error while Adding Branch");
    } catch (e) {
      throw Exception("${e}Error while Adding Branch");
    }
  }

  Future deleteBranch(String branch) async {
    try {
      QuerySnapshot<Map<String, dynamic>> data = await firebase
          .collection("Users")
          .where("branch", isEqualTo: branch)
          .limit(1)
          .get();

      if (data.docs.isEmpty) {
        await firebase.collection("dynamic_list_items").doc("branch").update({
          "branch": FieldValue.arrayRemove([branch])
        });
      } else {
        throw Exception(
            "User has Branch , it cannot delete :User iD =: ${data.docs[0]["userId"]}");
      }
    } on FirebaseException catch (e) {
      throw Exception("${e}Error while Deleting Branch");
    } catch (e) {
      throw Exception("${e}Error while Deleting Branch");
    }
  }
}
