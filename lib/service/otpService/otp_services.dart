import 'package:cloud_firestore/cloud_firestore.dart';

class OtpServices {
  final firebase = FirebaseFirestore.instance;

  Future sendOtpService(String otp, String reason) async {
    try {
      final docRef = firebase.collection("idCounters").doc("otp");
      await docRef.update({"otp": otp, "reason": reason});
    } on FirebaseException catch (e) {
      throw Exception("${e}Error while deletion user");
    } catch (e) {
      throw Exception("${e}Error while deletion user");
    }
  }

  Future<String> getOtpService() async {
    try {
      final docRef = firebase.collection("idCounters").doc("otp");
      final otpData = await docRef.get();
      String otp = otpData.data()!["otp"];
      return otp;
    } on FirebaseException catch (e) {
      throw Exception("${e}Error while deletion user");
    } catch (e) {
      throw Exception("${e}Error while deletion user");
    }
  }
}
