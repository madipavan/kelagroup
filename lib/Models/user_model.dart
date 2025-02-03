class UserModel {
  String name;
  String password;
  String phone;
  String pincode;
  String role;
  String state;
  String address;
  String city;
  String company;
  String email;
  int userId;
  String aadhar;
  String panCard;
  String branch;
  int ledgerGroupId;

  int commissionPercent;
  int hammaliPercent;
  String note;

  UserModel({
    required this.name,
    required this.password,
    required this.phone,
    required this.pincode,
    required this.role,
    required this.state,
    required this.address,
    required this.city,
    required this.company,
    required this.email,
    required this.userId,
    required this.aadhar,
    required this.panCard,
    required this.branch,
    required this.ledgerGroupId,
    required this.commissionPercent,
    required this.hammaliPercent,
    required this.note,
  });

  factory UserModel.fromJson(Map user) {
    return UserModel(
      name: user["name"],
      password: user["password"],
      address: user["address"],
      city: user["city"],
      company: user["company"],
      email: user["email"],
      phone: user["phone"],
      pincode: user["pincode"],
      role: user["role"],
      state: user["state"],
      userId: user["userId"],
      aadhar: user["aadhar"],
      panCard: user["panCard"],
      branch: user["branch"],
      ledgerGroupId: user["ledgerGroupId"],
      commissionPercent: user["commissionPercent"],
      hammaliPercent: user["hammaliPercent"],
      note: user["note"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "password": password,
      "address": address,
      "city": city,
      "company": company,
      "email": email,
      "phone": phone,
      "pincode": pincode,
      "role": role,
      "state": state,
      "userId": userId,
      "aadhar": aadhar,
      "panCard": panCard,
      "branch": branch,
      "ledgerGroupId": ledgerGroupId,
      "commissionPercent": commissionPercent,
      "hammaliPercent": hammaliPercent,
      "note": note,
    };
  }
}
