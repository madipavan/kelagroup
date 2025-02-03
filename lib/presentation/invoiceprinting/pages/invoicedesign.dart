import 'package:intl/intl.dart';
import 'package:kelawin/Models/billmodel.dart';
import 'package:kelawin/Models/khata_model.dart';
import 'package:kelawin/Models/multikissan_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

pw.Widget buildPrintableDataInvoice(
    Font customFont,
    PdfColor color,
    PdfColor textcolor,
    Font bold,
    BillModel billdata,
    KhataModel khata,
    String amtinwords,
    String vyapariphone) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(0),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
            color: PdfColors.white,
            height: 65,
            width: 500,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Container(
                    height: 65,
                    width: 200,
                    color: PdfColors.white,
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "NEW SHREE SAMARTH KELAGROUP",
                            style: pw.TextStyle(
                                font: bold,
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 15),
                          ),
                          pw.Text(
                            "OOP,Nimar Hospital Amravati Road,",
                            style: pw.TextStyle(
                                font: customFont,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10),
                          ),
                          pw.Text(
                            "Burhanpur M.P - 450331",
                            style: pw.TextStyle(
                                font: bold,
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 10),
                          ),
                          pw.Text(
                            "Phone - 9826909035",
                            style: pw.TextStyle(
                                font: customFont,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10),
                          ),
                          pw.Text(
                            "Email - amodedipesh12@gmail.com",
                            style: pw.TextStyle(
                                font: customFont,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10),
                          ),
                        ])),
                pw.Container(
                    height: 75,
                    width: 170,
                    color: PdfColors.white,
                    child: pw.Center(
                      child: pw.Text("logo"),
                    )),
              ],
            )),
        pw.Divider(color: color),
        pw.Container(
          width: 500,
          height: 35,
          color: PdfColors.white,
          margin: const pw.EdgeInsets.only(top: 0),
          child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "TAX INVOICE",
                  style: pw.TextStyle(
                      font: bold,
                      color: color,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 25),
                ),
              ]),
        ),
        pw.Container(
            margin: const pw.EdgeInsets.only(top: 0),
            color: PdfColors.white,
            height: 100,
            width: 500,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Container(
                    height: 100,
                    width: 170,
                    color: PdfColors.white,
                    child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "Bill To",
                            style: pw.TextStyle(
                                font: bold,
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 10),
                          ),
                          pw.Text(
                            billdata.selectedvyapari,
                            style: pw.TextStyle(
                                font: bold,
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 10),
                          ),
                          pw.Text(
                            billdata.vyaparicompany,
                            style: pw.TextStyle(
                                font: customFont,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10),
                          ),
                          pw.Text(
                            "Phone - $vyapariphone",
                            style: pw.TextStyle(
                                font: customFont,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10),
                          ),
                          pw.Text(
                            billdata.vyapariaddress,
                            style: pw.TextStyle(
                                font: customFont,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10),
                          ),
                        ])),
                pw.Container(
                    height: 100,
                    width: 170,
                    color: PdfColors.white,
                    child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            "Invoice Details",
                            style: pw.TextStyle(
                                font: bold,
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 10),
                          ),
                          pw.Text(
                            "Invoice No:${billdata.invoiceno}",
                            style: pw.TextStyle(
                                font: bold,
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 10),
                          ),
                          pw.Text(
                            "Date:${billdata.date}",
                            style: pw.TextStyle(
                                font: customFont,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10),
                          ),
                          pw.Text(
                            "Truck No: ${billdata.motorno}",
                            style: pw.TextStyle(
                                font: bold,
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 10),
                          ),
                          pw.Text(
                            "Board: ${billdata.board},Ras: ${billdata.ras}",
                            style: pw.TextStyle(
                                font: customFont,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10),
                          ),
                        ])),
              ],
            )),
        pw.SizedBox(
          height: 15,
        ),
        //table
        billdata.isMultikissan
            ? _multikissanTable(color, bold, textcolor, billdata)
            : _singlekissanTable(color, bold, textcolor, billdata),

        pw.Container(
            color: PdfColors.white,
            height: 215,
            width: 500,
            child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.all(20),
                    color: PdfColors.white,
                    height: 200,
                    width: 230,
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "Invoice Amount In Words",
                            style: pw.TextStyle(
                                font: bold,
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 13),
                          ),
                          pw.SizedBox(
                            height: 20,
                          ),
                          pw.Text(
                            amtinwords.toString(),
                            style: pw.TextStyle(
                                font: customFont,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 12),
                          ),
                        ]),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(20),
                    color: PdfColors.white,
                    height: 180,
                    width: 250,
                    child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                "Sub Total",
                                style: pw.TextStyle(
                                    font: customFont,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 12),
                              ),
                              pw.Text(
                                NumberFormat('#,##0.00')
                                    .format(billdata.subtotal),
                                style: pw.TextStyle(
                                    font: customFont,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                "Mandi Tax",
                                style: pw.TextStyle(
                                    font: customFont,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 12),
                              ),
                              pw.Text(
                                NumberFormat('#,##0.00').format(billdata.mtax),
                                style: pw.TextStyle(
                                    font: customFont,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                "Commission",
                                style: pw.TextStyle(
                                    font: customFont,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 12),
                              ),
                              pw.Text(
                                NumberFormat('#,##0.00')
                                    .format(billdata.commission),
                                style: pw.TextStyle(
                                    font: customFont,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                "Hammali",
                                style: pw.TextStyle(
                                    font: customFont,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 12),
                              ),
                              pw.Text(
                                NumberFormat('#,##0.00')
                                    .format(billdata.hammali),
                                style: pw.TextStyle(
                                    font: customFont,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                "OT",
                                style: pw.TextStyle(
                                    font: customFont,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 12),
                              ),
                              pw.Text(
                                NumberFormat('#,##0.00').format(billdata.ot),
                                style: pw.TextStyle(
                                    font: customFont,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                          pw.Container(
                            height: 20,
                            width: 250,
                            color: color,
                            child: pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  "Total",
                                  style: pw.TextStyle(
                                      font: bold,
                                      color: textcolor,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 12),
                                ),
                                pw.Text(
                                  NumberFormat('#,##0.00')
                                      .format(billdata.grandtotal),
                                  style: pw.TextStyle(
                                      font: bold,
                                      color: textcolor,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          pw.Divider(color: color),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                "Recieved",
                                style: pw.TextStyle(
                                    font: customFont,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 12),
                              ),
                              pw.Text(
                                NumberFormat('#,##0.00').format(khata.received),
                                style: pw.TextStyle(
                                    font: customFont,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                "Due",
                                style: pw.TextStyle(
                                    font: customFont,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 12),
                              ),
                              pw.Text(
                                NumberFormat('#,##0.00').format(khata.due),
                                style: pw.TextStyle(
                                    font: customFont,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ])),
        pw.Container(
            color: PdfColors.white,
            height: 200,
            width: 500,
            child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.all(20),
                    color: PdfColors.white,
                    height: 200,
                    width: 230,
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "Pay To:",
                            style: pw.TextStyle(
                                font: bold,
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 13),
                          ),
                          pw.SizedBox(
                            height: 20,
                          ),
                          pw.Text(
                            "Bank Name:PUNAB NATIONAL BANK,SHANWARA ROAD,BURHANPUR",
                            style: pw.TextStyle(
                                font: customFont,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 12),
                          ),
                          pw.SizedBox(
                            height: 15,
                          ),
                          pw.Text(
                            "Bank Account No: 3236002100021268",
                            style: pw.TextStyle(
                                font: customFont,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 12),
                          ),
                          pw.SizedBox(
                            height: 15,
                          ),
                          pw.Text(
                            "Bank IFSC Code: PUNB0323600",
                            style: pw.TextStyle(
                                font: customFont,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 12),
                          ),
                          pw.SizedBox(
                            height: 15,
                          ),
                          pw.Text(
                            "Account Holder's Name:Sanjay Singh S/O ShyamaSingh Pardeshi",
                            style: pw.TextStyle(
                                font: customFont,
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 12),
                          ),
                        ]),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(20),
                    color: PdfColors.white,
                    height: 170,
                    width: 250,
                    child: pw.Center(
                      child: pw.Text(
                        "Authorised Signatory",
                        style: pw.TextStyle(
                            font: bold,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12),
                      ),
                    ),
                  ),
                ])),
      ],
    ),
  );
}

pw.Widget _singlekissanTable(
    PdfColor color, Font bold, PdfColor textcolor, BillModel bill) {
  return pw.Table(children: [
    pw.TableRow(decoration: pw.BoxDecoration(color: color), children: [
      pw.Padding(
        padding: const pw.EdgeInsets.all(8.0),
        child: pw.Text(
          'Lungar',
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
              font: bold,
              color: textcolor,
              fontWeight: pw.FontWeight.bold,
              fontSize: 10),
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(8.0),
        child: pw.Text(
          'Weight',
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
              font: bold,
              color: textcolor,
              fontWeight: pw.FontWeight.bold,
              fontSize: 10),
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(8.0),
        child: pw.Text(
          'Rate',
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
              font: bold,
              color: textcolor,
              fontWeight: pw.FontWeight.bold,
              fontSize: 10),
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(8.0),
        child: pw.Text(
          'Amount',
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
              font: bold,
              color: textcolor,
              fontWeight: pw.FontWeight.bold,
              fontSize: 10),
        ),
      ),
    ]),
    pw.TableRow(
        decoration: pw.BoxDecoration(
            border: pw.Border(
                bottom: pw.BorderSide(
                    width: 1,
                    color:
                        color == PdfColors.white ? PdfColors.black : color))),
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(8.0),
            child: pw.Text(
              bill.lungar.toString(),
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                  font: bold, fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(8.0),
            child: pw.Text(
              bill.nettweight.toString(),
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                  font: bold, fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(8.0),
            child: pw.Text(
              bill.bhav.toString(),
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                  font: bold, fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(8.0),
            child: pw.Text(
              bill.subtotal.toString(),
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                  font: bold, fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ),
        ]),
    pw.TableRow(
        decoration: pw.BoxDecoration(
            border: pw.Border(
                bottom: pw.BorderSide(
                    width: 1,
                    color:
                        color == PdfColors.white ? PdfColors.black : color))),
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(8.0),
            child: pw.Text(
              'Total',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                  font: bold, fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ),
          pw.Spacer(),
          pw.Spacer(),
          pw.Padding(
            padding: const pw.EdgeInsets.all(8.0),
            child: pw.Text(
              bill.subtotal.toString(),
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                  font: bold, fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ),
        ])
  ]);
  //row
}

pw.Widget _multikissanTable(
    PdfColor color, Font bold, PdfColor textcolor, BillModel bill) {
  return pw.Table(children: _addrows(color, bold, textcolor, bill));
  //row
}

List<pw.TableRow> _addrows(
    PdfColor color, Font bold, PdfColor textcolor, BillModel bill) {
  List<MultikissanModel> kissanlist = _doNotreapeatbhav(bill.multiKissanList);

  List<pw.TableRow> tableRows = [
    //kissan details bhav and all
    pw.TableRow(decoration: pw.BoxDecoration(color: color), children: [
      pw.Padding(
        padding: const pw.EdgeInsets.all(8.0),
        child: pw.Text(
          'Lungar',
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
              font: bold,
              color: textcolor,
              fontWeight: pw.FontWeight.bold,
              fontSize: 10),
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(8.0),
        child: pw.Text(
          'Weight',
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
              font: bold,
              color: textcolor,
              fontWeight: pw.FontWeight.bold,
              fontSize: 10),
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(8.0),
        child: pw.Text(
          'Rate',
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
              font: bold,
              color: textcolor,
              fontWeight: pw.FontWeight.bold,
              fontSize: 10),
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(8.0),
        child: pw.Text(
          'Amount',
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
              font: bold,
              color: textcolor,
              fontWeight: pw.FontWeight.bold,
              fontSize: 10),
        ),
      ),
    ]),
  ];

  //converting kissandata into tablerows
  for (MultikissanModel element in kissanlist) {
    tableRows.add(
      pw.TableRow(
          decoration: pw.BoxDecoration(
              border: pw.Border(
                  bottom: pw.BorderSide(
                      width: 1,
                      color:
                          color == PdfColors.white ? PdfColors.black : color))),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(
                element.lungar.toString(),
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                    font: bold, fontWeight: pw.FontWeight.bold, fontSize: 10),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(
                element.netwt.toString(),
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                    font: bold, fontWeight: pw.FontWeight.bold, fontSize: 10),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(
                element.bhav.toString(),
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                    font: bold, fontWeight: pw.FontWeight.bold, fontSize: 10),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(
                element.amount.toString(),
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                    font: bold, fontWeight: pw.FontWeight.bold, fontSize: 10),
              ),
            ),
          ]),
    );
  }

  //converting kissandata into tablerows

  //at alst index
  tableRows.insert(
      tableRows.length,
      pw.TableRow(
          decoration: pw.BoxDecoration(
              border: pw.Border(
                  bottom: pw.BorderSide(
                      width: 1,
                      color:
                          color == PdfColors.white ? PdfColors.black : color))),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(
                'Total',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                    font: bold, fontWeight: pw.FontWeight.bold, fontSize: 10),
              ),
            ),
            pw.Spacer(),
            pw.Spacer(),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(
                bill.kissanamt.toString(),
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                    font: bold, fontWeight: pw.FontWeight.bold, fontSize: 10),
              ),
            ),
          ]));
  //at alst index

  return tableRows;
}

List<MultikissanModel> _doNotreapeatbhav(List<MultikissanModel>? kissanlist) {
  //to convert
  List<MultikissanModel> convertedKissanList = kissanlist!;

  List<int> indexFordelete = [];

  for (int i = 0; i < convertedKissanList.length; i++) {
    double currentBhav = convertedKissanList[i].bhav;
    for (int j = i + 1; j < convertedKissanList.length; j++) {
      if ((currentBhav == convertedKissanList[j].bhav) &&
          (convertedKissanList[j].iskelagroup == false)) {
        convertedKissanList[i].netwt += convertedKissanList[j].netwt;
        convertedKissanList[i].amount += convertedKissanList[j].amount;
        convertedKissanList[i].lungar += convertedKissanList[j].lungar;
        indexFordelete.add(j);
      }
    }

    //loop for removing matched bhav
    for (int k = 0; k < indexFordelete.length; k++) {
      k == 0
          ? convertedKissanList.removeAt(indexFordelete[k])
          : convertedKissanList.removeAt(indexFordelete[k] - 1);
    }
    indexFordelete.clear();
  }

  return convertedKissanList;
}
