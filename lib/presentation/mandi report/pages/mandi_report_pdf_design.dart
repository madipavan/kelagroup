import 'package:intl/intl.dart';
import 'package:kelawin/Models/billmodel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

List<pw.Widget> buildPrintableDataMandiReport(List<BillModel> allBills) {
  return [
    _mandiReportTable(allBills),
  ];
}

pw.Widget _mandiReportTable(List<BillModel> allBills) {
  List<pw.TableRow> tableRows = [
    pw.TableRow(
        decoration: const pw.BoxDecoration(
            border: pw.Border(
          bottom: pw.BorderSide(width: 1, color: PdfColors.black),
          top: pw.BorderSide(width: 1, color: PdfColors.black),
        )),
        children: [
          pw.Padding(
            padding:
                const pw.EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
            child: pw.Text(
              'Board No/Anuban',
              textAlign: pw.TextAlign.start,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ),
          pw.Padding(
            padding:
                const pw.EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
            child: pw.Text(
              'Bhuktan Pk',
              textAlign: pw.TextAlign.start,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ),
          pw.Padding(
            padding:
                const pw.EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
            child: pw.Text(
              'Date',
              textAlign: pw.TextAlign.start,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ),
          pw.Padding(
            padding:
                const pw.EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
            child: pw.Text(
              'Kissan Name',
              textAlign: pw.TextAlign.start,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ),
          pw.Padding(
            padding:
                const pw.EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
            child: pw.Text(
              'Net Wt',
              textAlign: pw.TextAlign.start,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ),
          pw.Padding(
            padding:
                const pw.EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
            child: pw.Text(
              'Rate',
              textAlign: pw.TextAlign.start,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ),
          pw.Padding(
            padding:
                const pw.EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
            child: pw.Text(
              'Amount',
              textAlign: pw.TextAlign.start,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ),
          pw.Padding(
            padding:
                const pw.EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
            child: pw.Text(
              'Mandi Tax',
              textAlign: pw.TextAlign.start,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ),
        ])
  ];

  //adding rows
  for (BillModel bill in allBills) {
    tableRows.add(pw.TableRow(
        decoration: const pw.BoxDecoration(
            border: pw.Border(
          bottom: pw.BorderSide(width: 1, color: PdfColors.black),
        )),
        children: [
          pw.Padding(
            padding:
                const pw.EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
            child: pw.Text(
              bill.board,
              textAlign: pw.TextAlign.start,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
          pw.Padding(
            padding:
                const pw.EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
            child: pw.Text(
              bill.bhuktanpk,
              textAlign: pw.TextAlign.start,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
          pw.Padding(
            padding:
                const pw.EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
            child: pw.Text(
              bill.date,
              textAlign: pw.TextAlign.start,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
          pw.Padding(
            padding:
                const pw.EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
            child: pw.Text(
              'Kissan Name',
              textAlign: pw.TextAlign.start,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
          pw.Padding(
            padding:
                const pw.EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
            child: pw.Text(
              'Net Wt',
              textAlign: pw.TextAlign.start,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
          pw.Padding(
            padding:
                const pw.EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
            child: pw.Text(
              'Rate',
              textAlign: pw.TextAlign.start,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
          pw.Padding(
            padding:
                const pw.EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
            child: pw.Text(
              'Amount',
              textAlign: pw.TextAlign.start,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
          pw.Padding(
            padding:
                const pw.EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
            child: pw.Text(
              NumberFormat('#,##0.00').format(bill.mtax),
              textAlign: pw.TextAlign.start,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
        ]));
  }

  //adding rows

  return pw.Table(
    columnWidths: const {
      3: pw.FractionColumnWidth(0.25),
      0: pw.FractionColumnWidth(0.12),
      1: pw.FractionColumnWidth(0.1),
    },
    border: const pw.TableBorder(
      // Horizontal borders
      verticalInside: pw.BorderSide(color: PdfColors.black, width: 1),
    ),
    children: tableRows,
  );
}
