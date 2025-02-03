import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodel/multikissanbillcalc/multi_grandtotal.dart';
import '../provider/multi_kissan_pro.dart';

class WtdiffTable extends StatelessWidget {
  const WtdiffTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MultiGrandtotal>(
      builder: (context, value, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
        child: Table(
          border: TableBorder(
            // Horizontal borders
            verticalInside: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          children: [
            TableRow(
                decoration: BoxDecoration(
                    border: const Border(
                        top: BorderSide(color: Colors.grey, width: 1),
                        bottom: BorderSide(color: Colors.grey, width: 1)),
                    color: Colors.blue.shade50),
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Name',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'UserID',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Lungar',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'NetWt',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Amount',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'WtDiff',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'FinalNetWt',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'FinalAmount',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
            for (int i = 0; i < value.resettleMentKissanList.length; i++)
              TableRow(
                  decoration: BoxDecoration(
                      border: const Border(
                          top: BorderSide(color: Colors.grey, width: 1),
                          bottom: BorderSide(color: Colors.grey, width: 1)),
                      color: Colors.blue.shade50),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        value.resettleMentKissanList[i].name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        value.resettleMentKissanList[i].userId.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        value.resettleMentKissanList[i].lungar.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        MultiKissanPro.multikissanCalclist[i]["netwt"]
                            .toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        MultiKissanPro.multikissanCalclist[i]["amount"]
                            .toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        (value.resettleMentKissanList[i].netwt -
                                MultiKissanPro.multikissanCalclist[i]["netwt"])
                            .toStringAsFixed(2),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        value.resettleMentKissanList[i].netwt.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        value.resettleMentKissanList[i].amount.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
          ],
        ),
      ),
    );
  }
}
