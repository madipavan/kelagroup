import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kelawin/Models/billmodel.dart';
import 'package:kelawin/Models/khata_model.dart';
import 'package:kelawin/Models/multikissan_model.dart';
import 'package:kelawin/Models/transaction_model.dart';
import 'package:kelawin/Models/user_model.dart';
import 'package:kelawin/presentation/khatabook/page/print_Transactions.dart';
import 'package:kelawin/utils/apputils.dart';
import 'package:number_to_character/number_to_character.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../presentation/invoiceprinting/pages/invoicedesign.dart';
import '../../presentation/invoiceprinting/pages/jantridesign.dart';
import '../../presentation/mandi report/pages/mandi_report_pdf_design.dart';
import '../../viewmodel/bill_viewmodel/get_bill_from_server.dart';

class PrintDocuments {
  Future<void> printInvoice(
    BuildContext context,
    color,
    invoiceno,
  ) async {
    print(invoiceno);
    Apputils().loader(context);
    //fetching bill data
    BillModel? billdata = await GetBillFromServer().getbill(invoiceno);

    //fetching vyapari khata
    List<dynamic> khatalists = await _getpdfkhata(billdata!.vyapariid);
    //fetching vyapari phone
    String vyapariphone = await _getvyapariDetail(billdata.vyapariid);
    //converting amount in words
    var converter = NumberToCharacterConverter('en');
    //converting grandtotal in words
    var amtinwords = converter.convertDouble(billdata.grandtotal);

    PdfColor billcolor = getColorFromString(color.toString());
    PdfColor textcolor;
    if (color == "White") {
      textcolor = PdfColors.black;
    } else {
      textcolor = PdfColors.white;
    }

    final ByteData fontData =
        await rootBundle.load("fonts/ProductSans-Regular.ttf");
    final pw.Font yourFont = pw.Font.ttf(fontData.buffer.asByteData());
    final ByteData fontDatabold =
        await rootBundle.load("fonts/ProductSans-Bold.ttf");
    final pw.Font bold = pw.Font.ttf(fontDatabold.buffer.asByteData());

    final doc = pw.Document();

    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return buildPrintableDataInvoice(yourFont, billcolor, textcolor, bold,
              billdata, khatalists, amtinwords, vyapariphone);
        }));

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
    Navigator.of(context).pop();
  }

  PdfColor getColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return PdfColors.red;
      case 'green':
        return PdfColors.green;
      case 'blue':
        return PdfColors.blue;
      case 'grey':
        return PdfColors.grey;
      case 'white':
        return PdfColors.white;
      case 'black':
        return PdfColors.black;
      // Add more cases for other colors as needed
      default:
        // Return a default color if the provided color name is not recognized
        return PdfColors.red;
    }
  }

  Future _getpdfkhata(id) async {
    try {
      QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection("vyapari_khata")
          .where("vyapari_id", isEqualTo: id)
          .get();

      return data.docs;
    } catch (e) {
      // Handle errors

      print("Error fetching data: $e");
      return [];
    }
  }

  Future _getvyapariDetail(id) async {
    try {
      QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection("vyapari")
          .where("vyapari_id", isEqualTo: id)
          .get();
      print(data.docs[0]["phone"]);
      return data.docs[0]["phone"];
    } catch (e) {
      // Handle errors

      print("Error fetching data: $e");
      return [];
    }
  }

  Future<void> printJantri(int invoiceno, BuildContext context) async {
    Apputils().loader(context);
    //fetching bill data
    BillModel? billdata = await GetBillFromServer().getbill(invoiceno);

    //fetching font
    final ByteData fontData =
        await rootBundle.load("fonts/ProductSans-Regular.ttf");
    final pw.Font yourFont = pw.Font.ttf(fontData.buffer.asByteData());

    //print jantri pdf
    final doc = pw.Document();

    final PdfPageFormat horizontalPageFormat = PdfPageFormat.a4.landscape;

    doc.addPage(pw.Page(
        pageFormat: horizontalPageFormat,
        margin: const pw.EdgeInsets.all(10),
        build: (pw.Context context) {
          return buildPrintableDataJantri(yourFont, billdata!);
        }));

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
    Navigator.of(context).pop();
  }

  //for transactions
  Future<void> printTransactions(List<TransactionModel> transactionsList,
      UserModel user, KhataModel khata, BuildContext context) async {
    Apputils().loader(context);
    //fetching  transactions
    List<Map> narrations = await _getNarrationsForTransaction(transactionsList);
    //fetching font
    //fetching openingBalance
    var (openingBalance, totalDebit, totalCredit) =
        _getOpeningBalance(transactionsList, khata);
    //print jantri pdf
    final doc = pw.Document();

    doc.addPage(pw.MultiPage(
        margin: const pw.EdgeInsets.all(10),
        footer: (context) {
          return pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                'Page ${context.pageNumber} of ${context.pagesCount}',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
              ),
            ],
          );
        },
        build: (pw.Context context) {
          return buildPrintableDataTransactions(transactionsList, narrations,
              user, khata, openingBalance, totalDebit, totalCredit);
        }));

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
    Navigator.of(context).pop();
  }

  //mandi reports
  Future<void> printMandiReports(List<BillModel> bills) async {
    final doc = pw.Document();

    doc.addPage(pw.MultiPage(
        margin: const pw.EdgeInsets.all(10),
        header: (context) {
          return pw.Column(children: [
            pw.Text("NEW SHREE SAMARTH KELAGROUP",
                style:
                    pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
              pw.Text("Print Date",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(width: 10),
              pw.Text(DateFormat('dd-MM-yyyy').format(DateTime.now())),
              pw.SizedBox(width: 50),
              pw.Text("From Date",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(width: 10),
              pw.Text(DateFormat('dd-MM-yyyy')
                  .format((DateFormat("dd-MM-yyyy").parse(bills[0].date)))
                  .toString()),
              pw.SizedBox(width: 50),
              pw.Text("To Date",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(width: 10),
              pw.Text(DateFormat('dd-MM-yyyy')
                  .format((DateFormat("dd-MM-yyyy")
                      .parse(bills[bills.length - 1].date)))
                  .toString()),
            ]),
            pw.SizedBox(height: 10),
            pw.Text("MANDI TAX REPORT",
                style:
                    pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
            pw.Divider(),
          ]);
        },
        footer: (context) {
          return pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                'Page ${context.pageNumber} of ${context.pagesCount}',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
              ),
            ],
          );
        },
        build: (pw.Context context) {
          return buildPrintableDataMandiReport(bills);
        }));

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }
}

Future<List<Map>> _getNarrationsForTransaction(
    List<TransactionModel> transactionsList) async {
  List<Map> narrations = [];

  for (int j = 0; j < transactionsList.length; j++) {
    if (transactionsList[j].paymentMode != "") {
      narrations.insert(j, {
        "paymentMode": transactionsList[j].paymentMode,
        "receiverName": transactionsList[j].receiverName,
      });
    } else {
      BillModel? bill =
          await GetBillFromServer().getbill(transactionsList[j].billno);
      if (bill!.isMultikissan) {
        double totalLungar = 0;
        for (MultikissanModel element in bill.multiKissanList!) {
          totalLungar += element.lungar;
        }
        bill.multiKissanList![0].lungar;
        narrations.insert(j, {
          "L": totalLungar,
          "Wt": bill.nettweight,
          "Mno": bill.motorno,
          "Rate": ""
        });
      } else {
        narrations.insert(j, {
          "L": bill.lungar,
          "Wt": bill.nettweight,
          "Mno": bill.motorno,
          "Rate": bill.bhav
        });
      }
    }
  }

  return narrations;
}

(double, double, double) _getOpeningBalance(
    List<TransactionModel> transactionsList, KhataModel khata) {
  double openingBalance = 0;
  double totalOfTransactionsAmount = 0;
  double totalOfTransactionsCreditAmount = 0;

  //calc of opening balance
  for (TransactionModel transaction in transactionsList) {
    if (transaction.transactionType == "DEBIT") {
      totalOfTransactionsAmount += transaction.amount;
    } else {
      totalOfTransactionsCreditAmount += transaction.amount;
    }
  }

  openingBalance = khata.total - totalOfTransactionsAmount;
  //calc of opening balance
  return (
    openingBalance,
    totalOfTransactionsAmount,
    totalOfTransactionsCreditAmount
  );
}
