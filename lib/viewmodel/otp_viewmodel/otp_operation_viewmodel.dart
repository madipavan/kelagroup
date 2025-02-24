import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kelawin/utils/apputils.dart';

import '../../service/otpService/otp_services.dart';

class OtpOperationViewmodel {
  Future sendOtp(BuildContext context, String reason) async {
    try {
      Apputils().loader(context);
      Random random = Random();
      int otp = 100000 + random.nextInt(900000);
      await OtpServices().sendOtpService(otp.toString(), reason);
    } catch (e) {
      debugPrint("error in sending otp$e");
    }
  }

  Future<String> verifyOtp() async {
    try {
      String otp = await OtpServices().getOtpService();
      return otp;
    } catch (e) {
      debugPrint("error in verifying otp$e");
      return "";
    }
  }
}
