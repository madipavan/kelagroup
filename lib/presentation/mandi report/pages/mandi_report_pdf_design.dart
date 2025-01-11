import 'package:intl/intl.dart';
import 'package:kelawin/Models/billmodel.dart';
import 'package:kelawin/Models/multikissan_model.dart';
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
            padding: const pw.EdgeInsets.only(top: 5, bottom: 5),
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
  double dayTotalNetWt = 0;
  double dayTotalKissanAmount = 0;
  double dayTotalMandiTax = 0;
  double grandTotalNetWt = 0;
  double grandTotalKissanAmount = 0;
  double grandTotalMandiTax = 0;

  //adding rows
  for (int i = 0; i < allBills.length; i++) {
    dayTotalNetWt += allBills[i].nettweight;
    dayTotalKissanAmount += (allBills[i].kissanamt).round();
    dayTotalMandiTax += allBills[i].mtax;

    grandTotalNetWt += allBills[i].nettweight;
    grandTotalKissanAmount += (allBills[i].kissanamt).round();
    grandTotalMandiTax += allBills[i].mtax;
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
              allBills[i].board,
              textAlign: pw.TextAlign.start,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
          pw.Padding(
            padding:
                const pw.EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
            child: pw.Text(
              allBills[i].bhuktanpk,
              textAlign: pw.TextAlign.start,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
          pw.Padding(
            padding:
                const pw.EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
            child: pw.Text(
              allBills[i].date,
              textAlign: pw.TextAlign.start,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
          //kissan name
          allBills[i].isMultikissan
              ? pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                      for (MultikissanModel kissan
                          in allBills[i].multiKissanList!)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(
                              top: 5, bottom: 5, right: 5, left: 5),
                          child: pw.Text(
                            kissan.name,
                            textAlign: pw.TextAlign.start,
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                        ),
                      pw.Divider(
                        color: PdfColors.grey700,
                        height: 1,
                        thickness: .5,
                      ),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Padding(
                              padding:
                                  const pw.EdgeInsets.only(top: 5, bottom: 5),
                              child: pw.Text(
                                "JANTRI TOTAL",
                                textAlign: pw.TextAlign.start,
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ]),
                      pw.Divider(
                        color: PdfColors.grey700,
                        height: 1,
                        thickness: .5,
                      ),
                      DateFormat("dd-MM-yyyy")
                              .parse(
                                  allBills[i == allBills.length - 1 ? i : i + 1]
                                      .date)
                              .isAfter(DateFormat("dd-MM-yyyy")
                                  .parse(allBills[i].date))
                          ? pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: pw.Text(
                                      "DAY TOTAL",
                                      textAlign: pw.TextAlign.start,
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold),
                                    ),
                                  )
                                ])
                          : pw.SizedBox(height: 0)
                    ])
              : pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(
                            top: 5, bottom: 5, right: 0, left: 5),
                        child: pw.Text(
                          allBills[i].selectedkissan,
                          textAlign: pw.TextAlign.start,
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ),
                      pw.Divider(
                        color: PdfColors.grey700,
                        height: 1,
                        thickness: .5,
                      ),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Padding(
                              padding:
                                  const pw.EdgeInsets.only(top: 5, bottom: 5),
                              child: pw.Text(
                                "JANTRI TOTAL",
                                textAlign: pw.TextAlign.start,
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ]),
                      pw.Divider(
                        color: PdfColors.grey700,
                        height: 1,
                        thickness: .5,
                      ),
                      DateFormat("dd-MM-yyyy")
                              .parse(
                                  allBills[i == allBills.length - 1 ? i : i + 1]
                                      .date)
                              .isAfter(DateFormat("dd-MM-yyyy")
                                  .parse(allBills[i].date))
                          ? pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: pw.Text(
                                      "DAY TOTAL",
                                      textAlign: pw.TextAlign.start,
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold),
                                    ),
                                  )
                                ])
                          : pw.SizedBox(height: 0)
                    ]),
          //kissan name
          //nett wt
          allBills[i].isMultikissan
              ? pw.Column(
                  children: [
                    for (MultikissanModel kissan
                        in allBills[i].multiKissanList!)
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(
                            top: 5, bottom: 5, right: 5, left: 5),
                        child: pw.Text(
                          kissan.netwt.toStringAsFixed(2),
                          textAlign: pw.TextAlign.start,
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ),
                    pw.Divider(
                      color: PdfColors.grey700,
                      height: 1,
                      thickness: .5,
                    ),
                    //total netwt Jantri
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(
                          top: 5, bottom: 5, right: 5, left: 5),
                      child: pw.Text(
                        allBills[i].nettweight.toStringAsFixed(2),
                        textAlign: pw.TextAlign.start,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Divider(
                      color: PdfColors.grey700,
                      height: 1,
                      thickness: .5,
                    ),
                    DateFormat("dd-MM-yyyy")
                            .parse(
                                allBills[i == allBills.length - 1 ? i : i + 1]
                                    .date)
                            .isAfter(DateFormat("dd-MM-yyyy")
                                .parse(allBills[i].date))
                        ? pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(
                                      top: 5, bottom: 5),
                                  child: pw.Text(
                                    dayTotalNetWt.toStringAsFixed(2),
                                    textAlign: pw.TextAlign.start,
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.bold),
                                  ),
                                )
                              ])
                        : pw.SizedBox(height: 0)
                  ],
                )
              : pw.Column(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(
                          top: 5, bottom: 5, right: 5, left: 5),
                      child: pw.Text(
                        allBills[i].nettweight.toStringAsFixed(2),
                        textAlign: pw.TextAlign.start,
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ),
                    pw.Divider(
                      color: PdfColors.grey700,
                      height: 1,
                      thickness: .5,
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(
                          top: 5, bottom: 5, right: 5, left: 5),
                      child: pw.Text(
                        allBills[i].nettweight.toStringAsFixed(2),
                        textAlign: pw.TextAlign.start,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Divider(
                      color: PdfColors.grey700,
                      height: 1,
                      thickness: .5,
                    ),
                    DateFormat("dd-MM-yyyy")
                            .parse(
                                allBills[i == allBills.length - 1 ? i : i + 1]
                                    .date)
                            .isAfter(DateFormat("dd-MM-yyyy")
                                .parse(allBills[i].date))
                        ? pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(
                                      top: 5, bottom: 5),
                                  child: pw.Text(
                                    dayTotalNetWt.toStringAsFixed(2),
                                    textAlign: pw.TextAlign.start,
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.bold),
                                  ),
                                )
                              ])
                        : pw.SizedBox(height: 0)
                  ],
                ),
          allBills[i].isMultikissan
              ? pw.Column(children: [
                  for (MultikissanModel kissan in allBills[i].multiKissanList!)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(
                          top: 5, bottom: 5, right: 5, left: 5),
                      child: pw.Text(
                        kissan.bhav.toStringAsFixed(2),
                        textAlign: pw.TextAlign.start,
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ),
                  pw.Divider(
                    color: PdfColors.grey700,
                    height: 1,
                    thickness: .5,
                  ),
                ])
              : pw.Column(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(
                        top: 5, bottom: 5, right: 5, left: 5),
                    child: pw.Text(
                      allBills[i].bhav!.toStringAsFixed(2),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                  pw.Divider(
                    color: PdfColors.grey700,
                    height: 1,
                    thickness: .5,
                  ),
                ]),
          allBills[i].isMultikissan
              ? pw.Column(children: [
                  for (MultikissanModel kissan in allBills[i].multiKissanList!)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(
                          top: 5, bottom: 5, right: 5, left: 5),
                      child: pw.Text(
                        kissan.amount.toStringAsFixed(2),
                        textAlign: pw.TextAlign.start,
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ),
                  pw.Divider(
                    color: PdfColors.grey700,
                    height: 1,
                    thickness: .5,
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(
                        top: 5, bottom: 5, right: 5, left: 5),
                    child: pw.Text(
                      allBills[i].kissanamt.toStringAsFixed(2),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Divider(
                    color: PdfColors.grey700,
                    height: 1,
                    thickness: .5,
                  ),
                  DateFormat("dd-MM-yyyy")
                          .parse(allBills[i == allBills.length - 1 ? i : i + 1]
                              .date)
                          .isAfter(
                              DateFormat("dd-MM-yyyy").parse(allBills[i].date))
                      ? pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                              pw.Padding(
                                padding:
                                    const pw.EdgeInsets.only(top: 5, bottom: 5),
                                child: pw.Text(
                                  NumberFormat('#,##0.00')
                                      .format(dayTotalKissanAmount),
                                  textAlign: pw.TextAlign.start,
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              )
                            ])
                      : pw.SizedBox(height: 0)
                ])
              : pw.Column(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(
                        top: 5, bottom: 5, right: 5, left: 5),
                    child: pw.Text(
                      allBills[i].kissanamt.toStringAsFixed(2),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                  pw.Divider(
                    color: PdfColors.grey700,
                    height: 1,
                    thickness: .5,
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(
                        top: 5, bottom: 5, right: 5, left: 5),
                    child: pw.Text(
                      allBills[i].kissanamt.toStringAsFixed(2),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Divider(
                    color: PdfColors.grey700,
                    height: 1,
                    thickness: .5,
                  ),
                  DateFormat("dd-MM-yyyy")
                          .parse(allBills[i == allBills.length - 1 ? i : i + 1]
                              .date)
                          .isAfter(
                              DateFormat("dd-MM-yyyy").parse(allBills[i].date))
                      ? pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                              pw.Padding(
                                padding:
                                    const pw.EdgeInsets.only(top: 5, bottom: 5),
                                child: pw.Text(
                                  NumberFormat('#,##0.00')
                                      .format(dayTotalKissanAmount),
                                  textAlign: pw.TextAlign.start,
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              )
                            ])
                      : pw.SizedBox(height: 0)
                ]),
          allBills[i].isMultikissan
              ? pw.Column(children: [
                  for (MultikissanModel kissan in allBills[i].multiKissanList!)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(
                          top: 5, bottom: 5, right: 5, left: 5),
                      child: pw.Text(
                        NumberFormat('#,##0.00')
                            .format((kissan.amount * 0.01).round()),
                        textAlign: pw.TextAlign.start,
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ),
                  pw.Divider(
                    color: PdfColors.grey700,
                    height: 1,
                    thickness: .5,
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(
                        top: 5, bottom: 5, right: 5, left: 5),
                    child: pw.Text(
                      NumberFormat('#,##0.00').format(allBills[i].mtax),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Divider(
                    color: PdfColors.grey700,
                    height: 1,
                    thickness: .5,
                  ),
                  DateFormat("dd-MM-yyyy")
                          .parse(allBills[i == allBills.length - 1 ? i : i + 1]
                              .date)
                          .isAfter(
                              DateFormat("dd-MM-yyyy").parse(allBills[i].date))
                      ? pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                              pw.Padding(
                                padding:
                                    const pw.EdgeInsets.only(top: 5, bottom: 5),
                                child: pw.Text(
                                  NumberFormat('#,##0.00')
                                      .format(dayTotalMandiTax),
                                  textAlign: pw.TextAlign.start,
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              )
                            ])
                      : pw.SizedBox(height: 0)
                ])
              : pw.Column(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(
                        top: 5, bottom: 5, right: 5, left: 5),
                    child: pw.Text(
                      NumberFormat('#,##0.00').format(allBills[i].mtax),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                  pw.Divider(
                    color: PdfColors.grey700,
                    height: 1,
                    thickness: .5,
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(
                        top: 5, bottom: 5, right: 5, left: 5),
                    child: pw.Text(
                      NumberFormat('#,##0.00').format(allBills[i].mtax),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Divider(
                    color: PdfColors.grey700,
                    height: 1,
                    thickness: .5,
                  ),
                  DateFormat("dd-MM-yyyy")
                          .parse(allBills[i == allBills.length - 1 ? i : i + 1]
                              .date)
                          .isAfter(
                              DateFormat("dd-MM-yyyy").parse(allBills[i].date))
                      ? pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                              pw.Padding(
                                padding:
                                    const pw.EdgeInsets.only(top: 5, bottom: 5),
                                child: pw.Text(
                                  NumberFormat('#,##0.00')
                                      .format(dayTotalMandiTax),
                                  textAlign: pw.TextAlign.start,
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              )
                            ])
                      : pw.SizedBox(height: 0)
                ]),
        ]));

    //making it zero for next dates
    DateFormat("dd-MM-yyyy")
            .parse(allBills[i == allBills.length - 1 ? i : i + 1].date)
            .isAfter(DateFormat("dd-MM-yyyy").parse(allBills[i].date))
        ? {
            dayTotalNetWt = 0,
            dayTotalKissanAmount = 0,
            dayTotalMandiTax = 0,
          }
        : null;
    //making it zero for next dates
  }

  //adding rows
  //last rows
  tableRows.insert(
      tableRows.length,
      pw.TableRow(
          decoration: const pw.BoxDecoration(
              border: pw.Border(
            bottom: pw.BorderSide(width: 1, color: PdfColors.black),
            top: pw.BorderSide(width: 1, color: PdfColors.black),
          )),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 5, bottom: 5),
              child: pw.Text(
                '',
                textAlign: pw.TextAlign.start,
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.only(
                  top: 5, bottom: 5, right: 5, left: 5),
              child: pw.Text(
                '',
                textAlign: pw.TextAlign.start,
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.only(
                  top: 5, bottom: 5, right: 5, left: 5),
              child: pw.Text(
                '',
                textAlign: pw.TextAlign.start,
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
              ),
            ),
            pw.Column(children: [
              pw.Padding(
                padding: const pw.EdgeInsets.only(
                    top: 5, bottom: 5, right: 5, left: 5),
                child: pw.Text(
                  'DAY TOTAL',
                  textAlign: pw.TextAlign.start,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 10),
                ),
              ),
              pw.Divider(height: 1, thickness: 1),
              pw.Padding(
                padding: const pw.EdgeInsets.only(
                    top: 5, bottom: 5, right: 5, left: 5),
                child: pw.Text(
                  'GRAND TOTAL',
                  textAlign: pw.TextAlign.start,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 10),
                ),
              ),
            ]),
            pw.Column(children: [
              pw.Padding(
                padding: const pw.EdgeInsets.only(
                    top: 5, bottom: 5, right: 5, left: 5),
                child: pw.Text(
                  dayTotalNetWt.toStringAsFixed(2),
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 10),
                ),
              ),
              pw.Divider(height: 1, thickness: 1),
              pw.Padding(
                padding: const pw.EdgeInsets.only(
                    top: 5, bottom: 5, right: 5, left: 5),
                child: pw.Text(
                  grandTotalNetWt.toStringAsFixed(2),
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 10),
                ),
              ),
            ]),
            pw.Column(children: [
              pw.Padding(
                padding: const pw.EdgeInsets.only(
                    top: 5, bottom: 5, right: 5, left: 5),
                child: pw.Text(
                  "",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 10),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.only(
                    top: 5, bottom: 5, right: 5, left: 5),
                child: pw.Text(
                  "",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 10),
                ),
              ),
            ]),
            pw.Column(children: [
              pw.Padding(
                padding: const pw.EdgeInsets.only(
                    top: 5, bottom: 5, right: 5, left: 5),
                child: pw.Text(
                  NumberFormat('#,##0.00').format(dayTotalKissanAmount),
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 10),
                ),
              ),
              pw.Divider(height: 1, thickness: 1),
              pw.Padding(
                padding: const pw.EdgeInsets.only(
                    top: 5, bottom: 5, right: 5, left: 5),
                child: pw.Text(
                  NumberFormat('#,##0.00').format(grandTotalKissanAmount),
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 10),
                ),
              ),
            ]),
            pw.Column(children: [
              pw.Padding(
                padding: const pw.EdgeInsets.only(
                    top: 5, bottom: 5, right: 5, left: 5),
                child: pw.Text(
                  NumberFormat('#,##0.00').format(dayTotalMandiTax),
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 10),
                ),
              ),
              pw.Divider(height: 1, thickness: 1),
              pw.Padding(
                padding: const pw.EdgeInsets.only(
                    top: 5, bottom: 5, right: 5, left: 5),
                child: pw.Text(
                  NumberFormat('#,##0.00').format(grandTotalMandiTax),
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 10),
                ),
              ),
            ]),
          ]));
  //last rows

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
