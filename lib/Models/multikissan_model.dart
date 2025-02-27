class MultikissanModel {
  String name;
  double pati;
  double danda;
  double wastage;
  double bhav;
  double weight;
  int lungar;
  String unit;
  String patiunit;
  String dandaunit;
  String wastageunit;

  int userId;
  int kelagroupCommissionPercent;
  int kelagroupHammaliPercent;
  int kelagroupMtaxPercent;

  double patiwt;
  double dandawt;
  double wastagewt;

  double netwt;
  bool iskelagroup;

  double amount;

  MultikissanModel({
    required this.name,
    required this.pati,
    required this.danda,
    required this.wastage,
    required this.bhav,
    required this.weight,
    required this.lungar,
    required this.unit,
    required this.patiunit,
    required this.dandaunit,
    required this.wastageunit,
    required this.userId,
    required this.patiwt,
    required this.dandawt,
    required this.wastagewt,
    required this.netwt,
    required this.iskelagroup,
    required this.amount,
    required this.kelagroupCommissionPercent,
    required this.kelagroupHammaliPercent,
    required this.kelagroupMtaxPercent,
  });

  factory MultikissanModel.forTextFields(Map kissan) {
    return MultikissanModel(
        name: kissan["name"].text.toString(),
        pati: double.parse(kissan["pati"].text),
        danda: double.parse(kissan["danda"].text),
        wastage: double.parse(kissan["wastage"].text),
        bhav: double.parse(kissan["bhav"].text),
        weight: double.parse(kissan["weight"].text),
        lungar: ((kissan["lungar"].text.toString().isEmpty)
                ? 0
                : double.parse(kissan["lungar"].text))
            .toInt(),
        unit: kissan["unit"],
        patiunit: kissan["patiunit"],
        dandaunit: kissan["dandaunit"],
        wastageunit: kissan["wastageunit"],
        userId: kissan["userId"],
        patiwt: kissan["patiwt"],
        dandawt: kissan["dandawt"],
        wastagewt: kissan["wastagewt"],
        netwt: kissan["netwt"],
        iskelagroup: kissan["iskelagroup"],
        kelagroupCommissionPercent: kissan["iskelagroup"]
            ? int.parse(kissan["kelagroupCommissionPercent"].text)
            : 0,
        kelagroupHammaliPercent: kissan["iskelagroup"]
            ? int.parse(kissan["kelagroupHammaliPercent"].text)
            : 0,
        kelagroupMtaxPercent: kissan["iskelagroup"]
            ? int.parse(kissan["kelagroupMtaxPercent"].text)
            : 0,
        amount: double.parse(kissan["amount"].toString()));
  }

  factory MultikissanModel.toJson(Map kissan) {
    return MultikissanModel(
        name: kissan["name"],
        pati: kissan["pati"],
        danda: kissan["danda"],
        wastage: kissan["wastage"],
        bhav: kissan["bhav"],
        weight: kissan["weight"],
        lungar: kissan["lungar"],
        unit: kissan["unit"],
        patiunit: kissan["patiunit"],
        dandaunit: kissan["dandaunit"],
        wastageunit: kissan["wastageunit"],
        userId: kissan["userId"],
        patiwt: kissan["patiwt"],
        dandawt: kissan["dandawt"],
        wastagewt: kissan["wastagewt"],
        netwt: kissan["netwt"],
        iskelagroup: kissan["iskelagroup"],
        kelagroupCommissionPercent:
            kissan["iskelagroup"] ? kissan["kelagroupCommissionPercent"] : 0,
        kelagroupHammaliPercent:
            kissan["iskelagroup"] ? kissan["kelagroupHammaliPercent"] : 0,
        kelagroupMtaxPercent:
            kissan["iskelagroup"] ? kissan["kelagroupMtaxPercent"] : 0,
        amount: kissan["amount"]);
  }
}
