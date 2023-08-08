import 'dart:convert';

import 'package:fbus_app_driver/src/environment/environment.dart';
import 'package:fbus_app_driver/src/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';

class DashboardQrController extends GetxController {
  final storage = const FlutterSecureStorage();

  void goBack() {
    Get.back();
  }

  UsersProviders usersProviders = UsersProviders();

  // This function is designed for pushing notifications.
  // void pushNotification(String statusMessage, String message) async {
  //   String? accessToken = await storage.read(key: 'accessToken');
  //   if (accessToken != null) {
  //     try {
  //       usersProviders.uploadNotification(
  //           "eNrV2VEgTgWdPqHzK2GW11:APA91bHDCvMM9CPove26ppQoS7Ipr-ouAZ41jjBBbJnxECSVvR19T92pcXzJ96Kqqxfp6m7_abxTSKC73jddlLpoDjnE9ZZZlrgHo7wxysJncwgh31P1czVNE-hUy_mFbKwxieiUE3NH",
  //           statusMessage,
  //           message,
  //           accessToken);
  //     } catch (err) {
  //       // Show a SnackBar with the error message
  //       Get.snackbar('Error', 'Failed to upload notification');

  //       // Navigate to the Home page
  //       // Get.offAllNamed('/navigation');
  //     }
  //   }
  // }

  void checkIn(Barcode barcode) async {
    //Get TICKET ID
    // List<String> parts = barcode.code!.split('/');
    // String ticketId = parts.last;
    // Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/ticket/check-in/$ticketId');
    // String jwtToken = GetStorage().read('accessToken');
    // print('jwtToken: $jwtToken');
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken != null) {
      List<String> parts = barcode.code!.split('/');
      String ticketId = parts.last;
      Uri uri = Uri.http(
          Environment.API_URL_OLD, '/api/v1/ticket/check-in/$ticketId');
      // Uri uri = Uri.http(barcode.code!);
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final http.Response response = await http.put(
        uri,
        headers: headers,
      );

      if (response.statusCode == 200) {
        print('data: ${json.decode(response.body)}');
        // pushNotification("SUCCESS", json.decode(response.body)['message']);
        Fluttertoast.showToast(
          msg: json.decode(response.body)['message'],
          fontSize: 14,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.black54,
        );
        // Get.snackbar("SUCCESS", "Successfully");
      } else if (response.statusCode == 400) {
        print('data: ${json.decode(response.body)}');
        // pushNotification("FAIL", json.decode(response.body)['message']);
        Fluttertoast.showToast(
          msg: json.decode(response.body)['message'],
          fontSize: 14,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.black54,
        );
        // Get.snackbar("Fail", "Ticket is already used ");
      }
    }
  }
}
