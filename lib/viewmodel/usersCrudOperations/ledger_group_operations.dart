import 'package:flutter/material.dart';
import 'package:kelawin/Models/ledgergroup_model.dart';
import 'package:kelawin/service/usersCrudOperationsService/ledger_group_operations_service.dart';
import 'package:kelawin/utils/apputils.dart';

class LedgerGroupOperations {
  Future<List<String>> getLedgerGroupTypeFromServer() async {
    List<String> items = [];
    try {
      items = await LedgerGroupOperationsService().getAllLedgerGroupType();
      return items;
    } catch (e) {
      print("$e: fetching ledgergouptype failed!");
      return items;
    }
  }

  Future<List<LedgergroupModel>> getAllLedgerGroupFromServer() async {
    List<LedgergroupModel> ledgerGroups = [];
    try {
      ledgerGroups = await LedgerGroupOperationsService().getAllLedgerGroup();
      return ledgerGroups;
    } catch (e) {
      print("$e: fetching ledgergoup failed!");
      return ledgerGroups;
    }
  }

  Future addLedgerGroupTypeOnServer(
      BuildContext context, String ledgerGroupType) async {
    try {
      Apputils().loader(context);
      await LedgerGroupOperationsService().addLedgerGroupType(ledgerGroupType);
      Apputils().transactionSuccess(context, 2, "LedgerGroupType added!");
    } catch (e) {
      Apputils()
          .transactionUnsuccess(context, "$e: adding LedgerGroupType failed!");
      print("$e: addiing LedgerGroup failed!");
    }
  }

  Future deleteLedgerGroupTypeOnServer(
      BuildContext context, String ledgerGroupType) async {
    try {
      Apputils().loader(context);
      await LedgerGroupOperationsService()
          .deleteLedgerGroupType(ledgerGroupType);
      Apputils().transactionSuccess(context, 2, "LedgerGroupType deleted!");
    } catch (e) {
      Apputils().transactionUnsuccess(
          context, "$e: deletion LedgerGroupType failed!");
      print("$e: addiing LedgerGroup failed!");
    }
  }

  Future addLedgerGroupOnServer(
      BuildContext context, LedgergroupModel ledgerGroup) async {
    try {
      Apputils().loader(context);
      await LedgerGroupOperationsService().addLedgerGroup(ledgerGroup);
      Apputils().transactionSuccess(context, 2, "LedgerGroup added!");
    } catch (e) {
      Apputils()
          .transactionUnsuccess(context, "$e: adding LedgerGroup failed!");
      print("$e: addiing LedgerGroup failed!");
    }
  }

  Future deleteLedgerGroupOnServer(
      BuildContext context, int ledgerGroupId) async {
    try {
      Apputils().loader(context);
      await LedgerGroupOperationsService().deleteLedgerGroup(ledgerGroupId);
      Apputils().transactionSuccess(context, 2, "LedgerGroup Deleted!");
    } catch (e) {
      Apputils().transactionUnsuccess(context, "$e");
      print("$e: deletion LedgerGroup failed!");
    }
  }
}
