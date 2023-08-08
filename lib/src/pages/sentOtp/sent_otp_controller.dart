import 'package:fbus_app_driver/src/models/response_api.dart';
import 'package:fbus_app_driver/src/providers/users_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class SendOTPController extends GetxController {
  final storage = const FlutterSecureStorage();
  List<TextEditingController> controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  List<FocusNode> focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );

  // String expectedOtp = "1234";

  UsersProviders usersProviders = UsersProviders();

  void checkOtp() async {
    // if (GetStorage().read('otp') != null) {
    //   expectedOtp = GetStorage().read('otp');
    // }
    String enteredOtp = "";

    for (var i = 0; i < 4; i++) {
      enteredOtp += controllers[i].text;
    }
    if (enteredOtp == "" || enteredOtp.length < 4) {
      Get.snackbar('Failed', 'You have entered wrong otp !');
    } else {
      ResponseApi responseApi = await usersProviders.loginDriver(
          GetStorage().read('phone'), enteredOtp);
      if (responseApi.data != null) {
        print('User: ${responseApi.data['user']}');
        final accessToken = responseApi.data['accessToken'];
        GetStorage().write('driverUser', responseApi.data['user']);
        await storage.write(key: 'accessToken', value: accessToken);
        Get.snackbar('Success', 'Successful authentication');
        gotoMainPage();
      } else {
        Get.snackbar('Failed', 'Failed authentication');
      }
    }
  }

  void gotoMainPage() {
    Get.offNamedUntil('/home-driver', (route) => false);
  }

  void sentOtpAgain() async {
    String phone = GetStorage().read('phone');
    try {
      print('Phone: $phone');
      ResponseApi responseApi = await usersProviders.getOtp(phone);
      if (responseApi.data['status'] == "pending") {
        Get.snackbar("Sent OTP",
            "Your OTP has been sent again to your phone number $phone.");
      }
    } catch (e) {
      Get.snackbar("Fail", "You can not get OTP");
    }
  }
}
