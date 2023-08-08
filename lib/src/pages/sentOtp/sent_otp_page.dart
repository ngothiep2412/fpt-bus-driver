import 'package:fbus_app_driver/src/core/const/colors.dart';
import 'package:fbus_app_driver/src/pages/sentOtp/sent_otp_controller.dart';
import 'package:fbus_app_driver/src/widgets/otp_text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SendOTPPage extends StatelessWidget {
  SendOTPController con = Get.put(SendOTPController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            textTitle(),
            const SizedBox(
              height: 20,
            ),
            textDesc(),
            const SizedBox(
              height: 50,
            ),
            inputTextField(context),
            const SizedBox(
              height: 20,
            ),
            btnSentOtp(),
            const SizedBox(height: 20),
            textSentOtpAgain()
          ],
        ),
      ),
    ));
  }

  Widget textTitle() {
    return const Text(
      'We have sent you an OTP to your Mobile',
      style: TextStyle(
        color: AppColor.primary,
        fontSize: 25,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget textDesc() {
    return Text(
      'Please check your mobile number ${GetStorage().read('phone')} continue to reset your password',
      textAlign: TextAlign.center,
    );
  }

  Widget inputTextField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        4,
        (index) => OtpTextField(
          controller: con.controllers[index],
          size: 4,
          onChanged: (value) {
            if (value.length == 1) {
              int nextIndex = index + 1;
              if (nextIndex < con.controllers.length) {
                FocusScope.of(context).requestFocus(con.focusNodes[nextIndex]);
              }
            }
          },
          focusNode: con.focusNodes[index],
        ),
      ),
    );
  }

  Widget btnSentOtp() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          con.checkOtp();
        },
        child: const Text(
          "Next",
          style: TextStyle(
            color: AppColor.textColor,
          ),
        ),
      ),
    );
  }

  Widget textSentOtpAgain() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Didn't Recieve? "),
        GestureDetector(
          onTap: () => con.sentOtpAgain(),
          child: const Text(
            "Click Here",
            style: TextStyle(
              color: AppColor.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
