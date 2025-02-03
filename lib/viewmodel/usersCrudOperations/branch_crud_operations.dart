import 'package:flutter/widgets.dart';
import 'package:kelawin/service/usersCrudOperationsService/branch_crud_operations_service.dart';

import '../../utils/apputils.dart';

class BranchCrudOperations {
  Future<List<String>> getBranchFromServer() async {
    List<String> items = [];
    try {
      items = await BranchCrudOperationsService().getAllBranch();
      return items;
    } catch (e) {
      print("$e: fetching Branch failed!");
      return items;
    }
  }

  Future addBranchOnServer(BuildContext context, String branchName) async {
    try {
      Apputils().loader(context);
      await BranchCrudOperationsService().addBranch(branchName);
      Apputils().transactionSuccess(context, 3, "Branch added!");
    } catch (e) {
      Apputils().transactionUnsuccess(context, "$e: adding Branch failed!");
      print("$e: addiing Branch failed!");
    }
  }

  Future deleteBranchOnServer(BuildContext context, String branch) async {
    try {
      Apputils().loader(context);
      await BranchCrudOperationsService().deleteBranch(branch);
      Apputils().transactionSuccess(context, 3, "Branch deleted!");
    } catch (e) {
      Apputils().transactionUnsuccess(context, "$e: deletion Branch failed!");
      print("$e: deletion Branch failed!");
    }
  }
}
