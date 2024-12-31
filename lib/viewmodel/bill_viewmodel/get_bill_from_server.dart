import 'package:kelawin/Models/billmodel.dart';

import '../../service/BillService/get_bill_service.dart';

class GetBillFromServer {
  Future<BillModel?> getbill(int billno) async {
    try {
      BillModel? bill = await GetBillService().getbill(billno);
      return bill;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<BillModel>> getAllbills() async {
    try {
      List<BillModel> bills = await GetBillService().getAllbills();
      return bills;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
