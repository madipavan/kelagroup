import 'package:kelawin/Models/multikissan_model.dart';

class BillModel {
  final int invoiceno;
  final String date;
  final String selectedkissan;
  final int kissanid;
  final String selectedvyapari;
  final int vyapariid;
  final String vyaparicompany;
  final String vyapariaddress;
  final String ras;
  final String board;
  final String motorno;
  final String bhuktanpk;
  final String? parchavillage;
  final double? bhav;
  final String? unit;
  final double? patival;
  final String? patiunit;
  final double? patiwt;
  final double? dandaval;
  final String? dandaunit;
  final double? dandawt;
  final double? wastageval;
  final String? wastageunit;
  final double? wastagewt;
  final double gross;
  final double tare;
  final int? lungar;
  final double wtDiff;
  final double nettweight;
  final double kissanamt;
  final double hammali;
  final int hammalipercent;
  final double commission;
  final int commissionpercent;
  final double mtax;
  final int mtaxpercent;
  final int ot;
  final double tcs;
  final int tcspercent;
  final double tds;
  final int tdspercent;
  final double subtotal;
  final double grandtotal;
  final int adminId;
  final bool isMultikissan;
  final List<MultikissanModel>? multiKissanList;
  final String note;

  BillModel(
      {required this.invoiceno,
      required this.date,
      required this.selectedkissan,
      required this.kissanid,
      required this.selectedvyapari,
      required this.vyapariid,
      required this.vyaparicompany,
      required this.vyapariaddress,
      required this.ras,
      required this.board,
      required this.motorno,
      required this.bhuktanpk,
      this.parchavillage,
      this.bhav,
      this.unit,
      this.patival,
      this.patiunit,
      this.patiwt,
      this.dandaval,
      this.dandaunit,
      this.dandawt,
      this.wastageval,
      this.wastageunit,
      this.wastagewt,
      required this.gross,
      required this.tare,
      this.lungar,
      required this.wtDiff,
      required this.nettweight,
      required this.kissanamt,
      required this.hammali,
      required this.hammalipercent,
      required this.commission,
      required this.commissionpercent,
      required this.mtax,
      required this.mtaxpercent,
      required this.ot,
      required this.tcs,
      required this.tcspercent,
      required this.tdspercent,
      required this.tds,
      required this.subtotal,
      required this.grandtotal,
      required this.adminId,
      required this.isMultikissan,
      this.multiKissanList,
      required this.note});

  factory BillModel.fromJson(Map bill, List<MultikissanModel>? kissanList) {
    if (bill["isMultikissan"]) {
      return BillModel(
          invoiceno: bill["invoiceno"],
          date: bill["date"],
          selectedkissan: bill["selectedkissan"],
          kissanid: bill["kissanid"],
          selectedvyapari: bill["selectedvyapari"],
          vyapariid: bill["vyapariid"],
          vyaparicompany: bill["vyaparicompany"],
          vyapariaddress: bill["vyapariaddress"],
          ras: bill["ras"],
          board: bill["board"],
          motorno: bill["motorno"],
          bhuktanpk: bill["bhuktanpk"],
          nettweight: bill["nettweight"],
          kissanamt: bill["kissanamt"],
          hammali: bill["hammali"],
          hammalipercent: bill["hammalipercent"],
          commission: bill["commission"],
          commissionpercent: bill["commissionpercent"],
          mtax: bill["mtax"],
          mtaxpercent: bill["mtaxpercent"],
          ot: bill["ot"],
          tcs: bill["tcs"],
          tcspercent: bill["tcspercent"],
          tds: bill["tds"],
          tdspercent: bill["tdspercent"],
          subtotal: bill["subtotal"],
          grandtotal: bill["grandtotal"],
          adminId: bill["adminId"],
          isMultikissan: bill["isMultikissan"],
          wtDiff: bill["wtDiff"],
          gross: bill["gross"],
          tare: bill["tare"],
          multiKissanList: kissanList,
          note: bill["note"]);
    }
    return BillModel(
        invoiceno: bill["invoiceno"],
        date: bill["date"],
        selectedkissan: bill["selectedkissan"],
        kissanid: bill["kissanid"],
        selectedvyapari: bill["selectedvyapari"],
        vyapariid: bill["vyapariid"],
        vyaparicompany: bill["vyaparicompany"],
        vyapariaddress: bill["vyapariaddress"],
        ras: bill["ras"],
        board: bill["board"],
        motorno: bill["motorno"],
        bhuktanpk: bill["bhuktanpk"],
        parchavillage: bill["parchavillage"],
        bhav: bill["bhav"],
        unit: bill["unit"],
        patival: bill["patival"],
        patiunit: bill["patiunit"],
        patiwt: bill["patiwt"],
        dandaval: bill["dandaval"],
        dandaunit: bill["dandaunit"],
        dandawt: bill["dandawt"],
        wastageval: bill["wastageval"],
        wastageunit: bill["wastageunit"],
        wastagewt: bill["wastagewt"],
        gross: bill["gross"],
        tare: bill["tare"],
        lungar: bill["lungar"],
        wtDiff: bill["wtDiff"],
        nettweight: bill["nettweight"],
        kissanamt: bill["kissanamt"],
        hammali: bill["hammali"],
        hammalipercent: bill["hammalipercent"],
        commission: bill["commission"],
        commissionpercent: bill["commissionpercent"],
        mtax: bill["mtax"],
        mtaxpercent: bill["mtaxpercent"],
        ot: bill["ot"],
        tcs: bill["tcs"],
        tcspercent: bill["tcspercent"],
        tdspercent: bill["tdspercent"],
        tds: bill["tds"],
        subtotal: bill["subtotal"],
        grandtotal: bill["grandtotal"],
        adminId: bill["adminId"],
        isMultikissan: bill["isMultikissan"],
        note: bill["note"]);
  }
  Map<String, dynamic> tomap() {
    if (isMultikissan) {
      return {
        "invoiceno": invoiceno,
        "date": date,
        "selectedkissan": selectedkissan,
        "kissanid": kissanid,
        "selectedvyapari": selectedvyapari,
        "vyapariid": vyapariid,
        "vyaparicompany": vyaparicompany,
        "vyapariaddress": vyapariaddress,
        "ras": ras,
        "board": board,
        "motorno": motorno,
        "bhuktanpk": bhuktanpk,
        "nettweight": nettweight,
        "kissanamt": kissanamt,
        "hammali": hammali,
        "hammalipercent": hammalipercent,
        "commission": commission,
        "commissionpercent": commissionpercent,
        "mtax": mtax,
        "mtaxpercent": mtaxpercent,
        "ot": ot,
        "tcs": tcs,
        "tds": tds,
        "tcspercent": tcspercent,
        "tdspercent": tdspercent,
        "subtotal": subtotal,
        "grandtotal": grandtotal,
        "adminId": adminId,
        "isMultikissan": isMultikissan,
        "wtDiff": wtDiff,
        "gross": gross,
        "tare": tare,
        "note": note
      };
    }
    return {
      "invoiceno": invoiceno,
      "date": date,
      "selectedkissan": selectedkissan,
      "kissanid": kissanid,
      "selectedvyapari": selectedvyapari,
      "vyapariid": vyapariid,
      "vyaparicompany": vyaparicompany,
      "vyapariaddress": vyapariaddress,
      "ras": ras,
      "board": board,
      "motorno": motorno,
      "bhuktanpk": bhuktanpk,
      "parchavillage": parchavillage,
      "bhav": bhav,
      "unit": unit,
      "patival": patival,
      "patiunit": patiunit,
      "patiwt": patiwt,
      "dandaval": dandaval,
      "dandaunit": dandaunit,
      "dandawt": dandawt,
      "wastageval": wastageval,
      "wastageunit": wastageunit,
      "wastagewt": wastagewt,
      "gross": gross,
      "tare": tare,
      "lungar": lungar,
      "wtDiff": wtDiff,
      "nettweight": nettweight,
      "kissanamt": kissanamt,
      "hammali": hammali,
      "hammalipercent": hammalipercent,
      "commission": commission,
      "commissionpercent": commissionpercent,
      "mtax": mtax,
      "mtaxpercent": mtaxpercent,
      "ot": ot,
      "tcs": tcs,
      "tcspercent": tcspercent,
      "tdspercent": tdspercent,
      "tds": tds,
      "subtotal": subtotal,
      "grandtotal": grandtotal,
      "adminId": adminId,
      "isMultikissan": isMultikissan,
      "note": note
    };
  }
}
