import 'package:fbus_app_driver/src/models/response_api.dart';
import 'package:fbus_app_driver/src/providers/users_provider.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  TextEditingController phoneController = TextEditingController();

  UsersProviders usersProviders = UsersProviders();

  final RegExp phoneExp = RegExp(r'^[0-9]+$');

  void goToLoginByDriverPage() {
    Get.toNamed('/');
  }

  void login() async {
    String phone = phoneController.text.trim();

    if (isValidForm(phone)) {
      // for ui
      // Get.toNamed('/home-driver');
      try {
        // send phone to get OTP
        ResponseApi otp = await usersProviders.getOtp(phone);
        GetStorage().write('phone', '0${otp.data['to'].substring(3, 12)}');
        print('otp: ${otp.data['status']}');
        if (otp.data['status'] == "pending") {
          Get.snackbar("Sent OTP",
              "Your OTP has been sent 2680to your phone number $phone.");
          Get.toNamed('/sent-otp');
        }
      } catch (e) {
        print('ERROR');
        // Get.snackbar("ERROR", "Can not get OTP");
      }
    }
  }

  void goToHomePage() {
    Get.toNamed('/navigation');
  }

  bool isValidForm(phone) {
    if (phone.isEmpty) {
      Get.snackbar('Invalid from', 'You must enter your phone');
      return false;
    }
    if (phoneExp.hasMatch(phone) == false) {
      Get.snackbar('Invalid from', 'You must enter number');
      return false;
    }
    return true;
  }
}
