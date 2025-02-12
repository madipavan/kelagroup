import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelawin/Models/khata_model.dart';

import '../../Models/user_model.dart';

class UsersCrudOperationsService {
  final firebase = FirebaseFirestore.instance;
  Future<List<UserModel>> getAllUsers() async {
    List<UserModel> allUsersList = [];
    try {
      QuerySnapshot<Map<String, dynamic>> usersList =
          await firebase.collection("Users").get();

      for (int i = 0; i < usersList.docs.length; i++) {
        allUsersList.add(UserModel.fromJson(usersList.docs[i].data()));
      }
    } on FirebaseException catch (e) {
      throw Exception("${e}Error while Fetching all users");
    } catch (e) {
      throw Exception("${e}Error while Fetching all users");
    }
    return allUsersList;
  }

  Future deleteUser(UserModel user) async {
    try {
      WriteBatch batch = firebase.batch();
      QuerySnapshot<Map<String, dynamic>> khataData = await firebase
          .collection("Khata")
          .where("userId", isEqualTo: user.userId)
          .get();
      KhataModel userKhata = KhataModel.fromJson(khataData);
      if (userKhata.due > 1) {
        throw Exception("User has due amount : ${userKhata.due}");
      } else {
        //deletion of transactions
        QuerySnapshot<Map<String, dynamic>> transaction = await firebase
            .collection("${user.role}_transaction")
            .where("userId", isEqualTo: user.userId)
            .get();
        if (transaction.docs.isNotEmpty) {
          for (var element in transaction.docs) {
            final transactionRef =
                firebase.collection("${user.role}_transaction").doc(element.id);
            batch.delete(transactionRef);
          }
        }

        //deletion of khata
        final khataRef = firebase.collection("Khata").doc(khataData.docs[0].id);
        batch.delete(khataRef);
        //deletion of user
        QuerySnapshot<Map<String, dynamic>> userData = await firebase
            .collection("Users")
            .where("userId", isEqualTo: user.userId)
            .get();
        final userRef = firebase.collection("Users").doc(userData.docs[0].id);
        batch.delete(userRef);
        batch.commit();
      }
    } on FirebaseException catch (e) {
      throw Exception("${e}Error while deletion user");
    } catch (e) {
      throw Exception("${e}Error while deletion user");
    }
  }

  Future addUser(UserModel user, KhataModel userKhata) async {
    try {
      WriteBatch batch = firebase.batch();
      //for userid

      int newUserID = await generateUniqueUserId(user.role);
      user.userId = newUserID;

      if (user.role == "kissan") {
        user.email = "swaminsamarth@${user.userId}.com";
        user.password = "password${user.userId}";
      }
      //now for khata

      int newKhataID = await generateUniqueUserKhataId();

      Map<String, dynamic> khata = KhataModel(
              khataId: newKhataID,
              received: userKhata.received,
              total: userKhata.total,
              due: userKhata.due,
              userId: user.userId)
          .toMap();
      //adding on server
      final userRef = firebase.collection("Users").doc();
      final khataRef = firebase.collection("Khata").doc();
      batch.set(userRef, user.toMap());
      batch.set(khataRef, khata);
      await batch.commit();
    } on FirebaseException catch (e) {
      throw Exception("${e}Error while adding user");
    } catch (e) {
      throw Exception("${e}Error while adding user");
    }
  }

  //generating userID
  Future<int> generateUniqueUserId(String role) async {
    final usersRef = FirebaseFirestore.instance.collection('Users');

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the last bill (sorted by bill_number in descending order)
      final lastUserQuery = await usersRef
          .where("role", isEqualTo: role)
          .orderBy('userId', descending: true)
          .limit(1)
          .get();

      int lastUserId = 0; // Default starting number if no bills exist
      if (role == "vyapari") {
        lastUserId = 20000;
      } else if (role == "kissan") {
        lastUserId = 10000;
      } else if (role == "kelagroup") {
        lastUserId = 30000;
      }

      if (lastUserQuery.docs.isNotEmpty) {
        lastUserId = lastUserQuery.docs.first.data()['userId'];
      }

      int newUserId = lastUserId + 1;

      return newUserId;
    });
  }

  //generating khataID
  Future<int> generateUniqueUserKhataId() async {
    final usersRef = FirebaseFirestore.instance.collection('Khata');

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the last bill (sorted by bill_number in descending order)
      final lastKhataQuery =
          await usersRef.orderBy('khataId', descending: true).limit(1).get();

      int lastKhataId = 0; // Default starting number if no bills exist

      if (lastKhataQuery.docs.isNotEmpty) {
        lastKhataId = lastKhataQuery.docs.first.data()['userId'];
      }

      int newKhataId = lastKhataId + 1;

      return newKhataId;
    });
  }
}
