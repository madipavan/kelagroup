import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kelawin/Models/khata_model.dart';
import 'package:kelawin/Models/user_model.dart';

import '../../service/usersCrudOperationsService/users_crud_operations_service.dart';
import '../../utils/apputils.dart';

class UsersCrudOperations {
  Future<List<UserModel>> getAllUsersFromServer(BuildContext context) async {
    try {
      List<UserModel> allUsersList =
          await UsersCrudOperationsService().getAllUsers();
      return allUsersList;
    } catch (e) {
      Apputils().transactionUnsuccess(context, "Fetching Users Failed!");
      print("$e:fecthing users failed!");
      return [];
    }
  }

  Future<UserModel> getSingleUserFromServer(int userID) async {
    UserModel user;
    try {
      user = await UsersCrudOperationsService().getSingleUsers(userID);
      return user;
    } catch (e) {
      debugPrint("$e:fecthing single user failed!");
      throw Exception("${e}Error while Fetching single users");
    }
  }

  Future deleteUserFromServer(BuildContext context, UserModel user) async {
    try {
      Apputils().loader(context);
      await UsersCrudOperationsService().deleteUser(user);
      Apputils().transactionSuccess(context, 2, "user deleted!");
    } catch (e) {
      Apputils().transactionUnsuccess(context, "$e: deletion user failed!");
      print("$e: deletion user failed!");
    }
  }

  Future addUserOnServer(
      BuildContext context, UserModel user, KhataModel userkhata) async {
    try {
      Apputils().loader(context);

      int newUserid =
          await UsersCrudOperationsService().generateUniqueUserId(user.role);
      newUserid != 0 ? user.userId = newUserid : throw Exception("UserId is 0");
      int newKhataid =
          await UsersCrudOperationsService().generateUniqueUserKhataId();
      newKhataid != 0
          ? userkhata.khataId = newKhataid
          : throw Exception("khataId is 0");

      await UsersCrudOperationsService().addUser(user, userkhata);
      Apputils().transactionSuccess(context, 2, "user added!");
    } catch (e) {
      Apputils().transactionUnsuccess(context, "$e: addingn user failed!");
      print("$e: addiing user failed!");
    }
  }

  Future updateUserOnServer(BuildContext context, UserModel user) async {
    try {
      Apputils().loader(context);
      await UsersCrudOperationsService().updateUser(user);
      Apputils().transactionSuccess(context, 2, "user updated!");
    } catch (e) {
      Apputils().transactionUnsuccess(context, "$e: user updation failed!");
      print("$e: deletion user failed!");
    }
  }
}
