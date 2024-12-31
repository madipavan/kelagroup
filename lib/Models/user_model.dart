import 'package:cloud_firestore/cloud_firestore.dart';

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
  });

  factory UserModel.fromJson(QuerySnapshot<Map<String, dynamic>> user) {
    return UserModel(
      name: user.docs[0]["name"],
      password: user.docs[0]["password"],
      address: user.docs[0]["address"],
      city: user.docs[0]["city"],
      company:
          user.docs[0]["role"] == "kissan" ? null : user.docs[0]["company"],
      email: user.docs[0]["email"],
      phone: user.docs[0]["phone"],
      pincode: user.docs[0]["pincode"],
      role: user.docs[0]["role"],
      state: user.docs[0]["state"],
      userId: user.docs[0]["${user.docs[0]["role"]}_id"],
    );
  }
}
