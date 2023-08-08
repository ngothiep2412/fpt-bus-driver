import 'dart:convert';
import 'package:fbus_app_driver/src/environment/environment.dart';
import 'package:fbus_app_driver/src/models/response_api.dart';
import 'package:fbus_app_driver/src/models/users.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UsersProviders extends GetConnect {
  String url = '${Environment.API_URL}api/users';

  Future<void> uploadNotification(
      String token, String title, String comment, String jwtToken) async {
    // Define the API endpoint
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/notification');

    // Create the request headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    // Create the request body
    Map<String, dynamic> body = {
      'token': token,
      'title': title,
      'content': comment,
    };

    // Send the POST request to the API endpoint
    final response =
        await http.post(uri, headers: headers, body: jsonEncode(body));

    // Check the response status code
    if (response.statusCode == 200) {
      print('Notification uploaded successfully');
    } else {
      throw Error();
    }
  }

  Future<void> subScribeToTripTopic(String id) async {
    await FirebaseMessaging.instance.subscribeToTopic(id);
  }

  Future<ResponseApi> getOtp(String phone) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/auth/phone/sign-in');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'phone': phone,
    };

    final http.Response otp = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );
    if (otp.statusCode == 400) {
      Get.snackbar("Fail",
          "Your phone number is not registered! Please contact your administrator to support your account!");
      throw Exception('Failed to get otp');
    }
    if (otp.statusCode == 200) {
      final data = json.decode(otp.body);
      final responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } else {
      Get.snackbar("ERROR", "Can not get OTP");
      throw Exception('Failed to get otp');
    }
  }

  Future<ResponseApi> loginDriver(String phone, String otp) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/auth/verify-otp');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> body = {
      "phone": phone,
      "code": otp,
    };

    final http.Response response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final responseApi = ResponseApi.fromJson(data);
      print("Login successfully.");
      return responseApi;
    } else {
      throw Exception('Failed get user');
    }
  }

  Future<ResponseApi> uploadPicture(
      UserModel user, String base64Image, String jwtToken) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/upload-file');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final Map<String, dynamic> body = {
      'type': 'profile',
      'imageBase64': "data:image/jpeg;base64,$base64Image",
      'userId': user.id,
    };

    final http.Response response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } else {
      throw Exception('Failed to update profile picture');
    }
  }

  Future<ResponseApi> updateProfileWithoutPicture(
      String name, String phone, String jwtToken, UserModel user) async {
    Uri uri =
        Uri.http(Environment.API_URL_OLD, '/api/v1/users/update/${user.id}');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final Map<String, dynamic> body = {
      'fullname': name,
      'phone_number': phone,
    };

    final http.Response response = await http.put(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 400) {
      Get.snackbar("Invalid", "You need enter with valid data");
    }
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } else {
      throw Exception('Failed to update profile picture');
    }
  }

  Future<ResponseApi> updateProfilePicture(String imageUrl, String name,
      String phone, String jwtToken, UserModel user) async {
    Uri uri =
        Uri.http(Environment.API_URL_OLD, '/api/v1/users/update/${user.id}');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final Map<String, dynamic> body = {
      'fullname': name,
      'phone_number': phone,
      'profile_img': imageUrl,
    };

    final http.Response response = await http.put(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 400) {
      Get.snackbar("Invalid", "You need enter with valid data");
    }
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } else {
      throw Exception('Failed to update profile picture');
    }
  }
}
