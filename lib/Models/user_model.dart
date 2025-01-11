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

  factory UserModel.fromJson(Map user) {
    return UserModel(
      name: user["name"],
      password: user["password"],
      address: user["address"],
      city: user["city"],
      company: user["role"] == "kissan" ? "" : user["company"],
      email: user["email"],
      phone: user["phone"],
      pincode: user["pincode"],
      role: user["role"],
      state: user["state"],
      userId: user["${user["role"]}_id"],
    );
  }
}
