import 'package:cloud_firestore/cloud_firestore.dart';

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
  final double? gross;
  final double? tare;
  final String? lungar;
  final double nettweight;
  final double kissanamt;
  final double hammali;
  final int hammalipercent;
  final double commission;
  final int commissionpercent;
  final double mtax;
  final int mtaxpercent;
  final double ot;
  final double tcs;
  final double subtotal;
  final double grandtotal;
  final String adminname;
  final bool isMultikissan;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>>? multiKissanList;
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
      this.gross,
      this.tare,
      this.lungar,
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
      required this.subtotal,
      required this.grandtotal,
      required this.adminname,
      required this.isMultikissan,
      this.multiKissanList,
      required this.note});

  factory BillModel.fromJson(QueryDocumentSnapshot<Map<String, dynamic>> bill,
      QuerySnapshot<Map<String, dynamic>>? kissanList) {
    if (bill["ismultikissan"]) {
      return BillModel(
          invoiceno: bill["bill_no"],
          date: bill["date"],
          selectedkissan: bill["kissan_name"],
          kissanid: bill["kissan_id"],
          selectedvyapari: bill["vyapari_name"],
          vyapariid: bill["vyapari_id"],
          vyaparicompany: bill["vyapari_company"],
          vyapariaddress: bill["vyapari_address"],
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
          subtotal: bill["subtotal"],
          grandtotal: bill["grandtotal"],
          adminname: bill["adminname"],
          isMultikissan: bill["ismultikissan"],
          multiKissanList: kissanList!.docs,
          note: bill["note"]);
    }
    return BillModel(
        invoiceno: bill["bill_no"],
        date: bill["date"],
        selectedkissan: bill["kissan_name"],
        kissanid: bill["kissan_id"],
        selectedvyapari: bill["vyapari_name"],
        vyapariid: bill["vyapari_id"],
        vyaparicompany: bill["vyapari_company"],
        vyapariaddress: bill["vyapari_address"],
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
        subtotal: bill["subtotal"],
        grandtotal: bill["grandtotal"],
        adminname: bill["adminname"],
        isMultikissan: bill["ismultikissan"],
        note: bill["note"]);
  }
}
