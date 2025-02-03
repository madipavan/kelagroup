class LedgergroupModel {
  int ledgerGroupId;
  String groupName;
  String groupType;
  String balanceSheetHead;

  LedgergroupModel({
    required this.ledgerGroupId,
    required this.groupName,
    required this.groupType,
    required this.balanceSheetHead,
  });

  Map<String, dynamic> toMap() {
    return {
      "ledgerGroupId": ledgerGroupId,
      "groupName": groupName,
      "groupType": groupType,
      "balanceSheetHead": balanceSheetHead,
    };
  }

  factory LedgergroupModel.fromJson(Map<String, dynamic> ledgerGroupmap) {
    return LedgergroupModel(
        ledgerGroupId: ledgerGroupmap["ledgerGroupId"],
        groupName: ledgerGroupmap["groupName"],
        groupType: ledgerGroupmap["groupType"],
        balanceSheetHead: ledgerGroupmap["balanceSheetHead"]);
  }
}
