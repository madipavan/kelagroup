import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelawin/Models/khata_model.dart';
import 'package:synchronized/synchronized.dart';

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
        //adding user all things in disabled acc
        final disableCollectionRef =
            firebase.collection("disableAccount").doc();
        final subCollectionRef = firebase
            .collection("disableAccount")
            .doc(disableCollectionRef.id)
            .collection("khata")
            .doc();
        batch.set(disableCollectionRef, user.toMap());
        batch.set(subCollectionRef, khataData.docs[0].data());
        //adding user all things in disabled acc
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

      if (user.role == "kissan") {
        user.email = "swaminsamarth@${user.userId}.com";
        user.password = "password${user.userId}";
      }
      //now for khata

      Map<String, dynamic> khata = KhataModel(
              khataId: userKhata.khataId,
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
    // Create a lock instance
    int newUserId = 0;
    final counterRef = FirebaseFirestore.instance
        .collection('idCounters')
        .doc("${role}IdCounter");
    try {
      final lock = Lock();
      await lock.synchronized(() async {
        return await FirebaseFirestore.instance
            .runTransaction((transaction) async {
          // Get the last bill (sorted by bill_number in descending order)
          DocumentSnapshot counterDoc = await transaction.get(counterRef);

          int lastUserId = 0; // Default starting number if no bills exist
          if (role == "vyapari") {
            lastUserId = 20000;
          } else if (role == "kissan") {
            lastUserId = 10000;
          } else if (role == "kelagroup") {
            lastUserId = 30000;
          }

          if (!counterDoc.exists) {
          } else {
            lastUserId = counterDoc.exists
                ? (counterDoc.get("userId") ?? lastUserId)
                : lastUserId;
            newUserId = lastUserId + 1;
            transaction.update(counterRef, {"userId": newUserId});
          }

          return newUserId;
        });
      });
      return newUserId;
    } on FirebaseException catch (e) {
      throw Exception("${e}Error while creating userId");
    } catch (e) {
      throw Exception("${e}Error while creating userId");
    }
  }

  //generating khataID
  Future<int> generateUniqueUserKhataId() async {
    int newKhataId = 0;

    try {
      final lock = Lock();
      await lock.synchronized(() async {
        return await FirebaseFirestore.instance
            .runTransaction((transaction) async {
          final khataIdCounterRef = FirebaseFirestore.instance
              .collection('idCounters')
              .doc("khataIdCounter");
          DocumentSnapshot counterDoc =
              await transaction.get(khataIdCounterRef);

          int lastKhataId =
              22000000; // Default starting number if no bills exist

          if (!counterDoc.exists) {
            throw Exception(
                "Counter document is missing! Initialize it first.");
          } else {
            lastKhataId = counterDoc.exists
                ? (counterDoc.get("khataId") ?? lastKhataId)
                : lastKhataId;
            newKhataId = lastKhataId + 1;
            transaction.update(khataIdCounterRef, {"khataId": newKhataId});
          }

          return newKhataId;
        });
      });
      return newKhataId;
    } on FirebaseException catch (e) {
      throw Exception("${e}Error while creating userKhataId");
    } catch (e) {
      throw Exception("${e}Error while creating userkhataId");
    }
  }

  //single user
  Future<UserModel> getSingleUsers(int userId) async {
    UserModel user;
    try {
      QuerySnapshot<Map<String, dynamic>> userDoc = await firebase
          .collection("Users")
          .where("userId", isEqualTo: userId)
          .get();
      userDoc.docs.isNotEmpty
          ? user = UserModel.fromJson(userDoc.docs[0].data())
          : throw Exception("Error while Fetching single users");
    } on FirebaseException catch (e) {
      throw Exception("${e}Error while Fetching single users");
    } catch (e) {
      throw Exception("${e}Error while Fetching single users");
    }
    return user;
  }

  //single user
  Future updateUser(UserModel user) async {
    print(user.userId);
    try {
      QuerySnapshot<Map<String, dynamic>> userDoc = await firebase
          .collection("Users")
          .where("userId", isEqualTo: user.userId)
          .limit(1)
          .get();
      await userDoc.docs[0].reference.update(user.toMap());
    } on FirebaseException catch (e) {
      throw Exception("${e}Error while Updating  user");
    } catch (e) {
      throw Exception("${e}Error while Updating  user");
    }
  }
}
