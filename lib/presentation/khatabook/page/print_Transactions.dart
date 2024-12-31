import 'package:intl/intl.dart';
import 'package:kelawin/Models/khata_model.dart';
import 'package:kelawin/Models/transaction_model.dart';
import 'package:kelawin/Models/user_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

List<pw.Widget> buildPrintableDataTransactions(
  List<TransactionModel> transactionsList,
  List<Map> narrations,
  UserModel user,
  KhataModel khata,
  double openingBalance,
  double totalDebit,
  double totalCredit,
) {
  return [
    pw.Column(children: [
      pw.Text("NEW SHREE SAMARTH KELAGROUP",
          style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
      pw.Text("Ledger Statement",
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
      pw.Divider(),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
        pw.Text("From Date",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(width: 10),
        pw.Text(transactionsList[0].date),
        pw.SizedBox(width: 50),
        pw.Text("To Date", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(width: 10),
        pw.Text(transactionsList[transactionsList.length - 1].date),
      ]),
      pw.Divider(),
      pw.Row(children: [
        pw.Text(user.userId.toString(),
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(width: 20),
        pw.Text(user.name, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Spacer(),
        pw.Text("Opening Balance",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(width: 20),
        pw.Expanded(
          child: pw.Text(
              "${NumberFormat('#,##0.00').format(openingBalance)} Dr",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        )
      ]),
    ]),
    _trasactionTable(transactionsList, narrations, openingBalance),
    pw.SizedBox(height: 10),
    pw.Divider(),
    pw.Row(
      children: [
        pw.SizedBox(width: 180),
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 0, bottom: 0),
          child: pw.Text(
            'Total',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(width: 75),
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 0, bottom: 0),
          child: pw.Text(
            NumberFormat('#,##0.00').format(totalDebit),
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(width: 30),
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 0, bottom: 0),
          child: pw.Text(
            NumberFormat('#,##0.00').format(totalCredit),
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
      ],
    ),
    pw.Divider(),
    pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 0, bottom: 0),
          child: pw.Text(
            'Closing Balance',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 0, bottom: 0),
          child: pw.Text(
            "${NumberFormat('#,##0.00').format(khata.due)} Dr",
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
      ],
    ),
    pw.Divider(),
  ];
}

pw.Widget _trasactionTable(List<TransactionModel> transactionsList,
    List<Map> narrations, double openingBalance) {
  List<pw.TableRow> tableRows = [
    pw.TableRow(
        decoration: const pw.BoxDecoration(
            border: pw.Border(
                top: pw.BorderSide(width: 1, color: PdfColors.black),
                bottom: pw.BorderSide(width: 1, color: PdfColors.black))),
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 5, bottom: 5, left: 5),
            child: pw.Text(
              'Date',
              textAlign: pw.TextAlign.start,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 5, bottom: 5, left: 5),
            child: pw.Text(
              'Voc No',
              textAlign: pw.TextAlign.start,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 5, bottom: 5, left: 5),
            child: pw.Text(
              'Narrattion',
              textAlign: pw.TextAlign.start,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 5, bottom: 5, left: 5),
            child: pw.Text(
              'Dr Amount',
              textAlign: pw.TextAlign.start,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 5, bottom: 5, left: 5),
            child: pw.Text(
              'Cr Amount',
              textAlign: pw.TextAlign.start,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 5, bottom: 5, left: 5),
            child: pw.Text(
              'Balance',
              textAlign: pw.TextAlign.start,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 5, bottom: 5, left: 5),
            child: pw.Text(
              'Remark',
              textAlign: pw.TextAlign.start,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
        ])
  ];

  //adding middle Rows
  int i = 1;
  double balance = openingBalance;
  for (TransactionModel transaction in transactionsList) {
    transaction.transactionType == "DEBIT"
        ? balance = transaction.amount + balance
        : balance = balance - transaction.amount;
    tableRows.add(pw.TableRow(
        decoration: const pw.BoxDecoration(
            border: pw.Border(
                bottom: pw.BorderSide(width: 1, color: PdfColors.black))),
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 5, bottom: 5, left: 5),
            child: pw.Text(
              transaction.date.toString(),
              textAlign: pw.TextAlign.start,
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 5, bottom: 5, left: 5),
            child: pw.Text(
              transaction.billno == 0 ? "NA" : transaction.billno.toString(),
              textAlign: pw.TextAlign.start,
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 5, bottom: 5, left: 5),
            child: pw.Text(
              transaction.paymentMode != ""
                  ? "${narrations[i - 1]["paymentMode"]} - ${narrations[i - 1]["receiverName"]}"
                  : "L:${narrations[i - 1]["L"]} , Wt:${narrations[i - 1]["Wt"]} , Mno:${narrations[i - 1]["Mno"]} , Rate:${narrations[i - 1]["Rate"]}",
              textAlign: pw.TextAlign.start,
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 5, bottom: 5, left: 5),
            child: pw.Text(
              transaction.transactionType == "DEBIT"
                  ? NumberFormat('#,##0.00').format(transaction.amount)
                  : "-",
              textAlign: pw.TextAlign.start,
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 5, bottom: 5, left: 5),
            child: pw.Text(
              transaction.transactionType == "CREDIT"
                  ? NumberFormat('#,##0.00').format(transaction.amount)
                  : "-",
              textAlign: pw.TextAlign.start,
              style: pw.TextStyle(
                color: transaction.transactionType == "CREDIT"
                    ? PdfColors.green
                    : PdfColors.red,
              ),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 5, bottom: 5, left: 5),
            child: pw.Text(
              NumberFormat('#,##0.00').format(balance),
              textAlign: pw.TextAlign.start,
              style: const pw.TextStyle(),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 5, bottom: 5, left: 5),
            child: pw.Text(
              "",
              textAlign: pw.TextAlign.start,
              style: const pw.TextStyle(),
            ),
          ),
        ]));
    i++;
  }
  //adding middle Rows

  return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 10),
      child: pw.Table(
        columnWidths: const {
          2: pw.FractionColumnWidth(0.2),
        },
        border: const pw.TableBorder(
          // Horizontal borders
          verticalInside: pw.BorderSide(color: PdfColors.black, width: 1),
        ),
        children: tableRows,
      ));
}
