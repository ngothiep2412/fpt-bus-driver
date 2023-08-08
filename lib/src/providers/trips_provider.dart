import 'dart:convert';

import 'package:fbus_app_driver/src/environment/environment.dart';
import 'package:fbus_app_driver/src/models/response_api.dart';
import 'package:fbus_app_driver/src/models/trip_model.dart';
import 'package:fbus_app_driver/src/models/users.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class TripsProviders extends GetConnect {
  UserModel driverUser =
      UserModel.fromJson(GetStorage().read('driverUser') ?? {});

  Future<List<TripModel>> getAllTodayTrip(String accessToken) async {
    Uri uri = Uri.http(
        // Environment.API_URL_OLD, '/api/v1/trip/driver-${driverUser.id}');
        Environment.API_URL_OLD,
        '/api/v1/trip/driver-${driverUser.id}');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final http.Response response = await http.get(
      uri,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // final responseApi = ResponseApi.fromJson(data);
      print('Data Trip : ${data['data']}');
      List<TripModel> trips = TripModel.fromJsonList(data['data']);
      return trips;
    } else {
      List<TripModel> trips = [];
      return trips;
    }
  }

  Future<ResponseApi> getTripDetail(String jwtToken, String tripId) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/trip/search/$tripId');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final http.Response response = await http.get(
      uri,
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } else {
      throw Exception('Failed to get Trip Detail');
    }
  }

  Future<ResponseApi> updateTripStatus(
      String idTrip, String accessToken, int status) async {
    Uri uri =
        Uri.http(Environment.API_URL_OLD, '/api/v1/trip/change-status/$idTrip');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final Map<String, dynamic> body = {"status": status};

    final http.Response response = await http.put(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    print('Update BODY : ${response.statusCode}');
    print('Update BODY : ${response.body}');

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 404) {
      final data = json.decode(response.body);
      final responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } else {
      throw Exception('Update trip status false');
    }
  }

  // Future<ResponseApi> updateTripToStart(
  //     String idTrip, String accessToken) async {
  //   Uri uri =
  //       Uri.http(Environment.API_URL_OLD, '/api/v1/trip/change-status/$idTrip');
  //   final Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $accessToken',
  //   };

  //   final Map<String, dynamic> body = {"status": 4};

  //   final http.Response response = await http.put(
  //     uri,
  //     headers: headers,
  //     body: jsonEncode(body),
  //   );

  //   print('Update start BODY : ${response.statusCode}');
  //   print('Update start BODY : ${response.body}');

  //   if (response.statusCode == 400) {
  //     final data = json.decode(response.body);
  //     final responseApi = ResponseApi.fromJson(data);
  //     return responseApi;
  //   }

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     final responseApi = ResponseApi.fromJson(data);
  //     return responseApi;
  //   } else {
  //     throw Exception('Update trip status false');
  //   }
  // }

  // Future<ResponseApi> updateTripToEnd(String idTrip, String accessToken) async {
  //   Uri uri =
  //       Uri.http(Environment.API_URL_OLD, '/api/v1/trip/change-status/$idTrip');
  //   final Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $accessToken',
  //   };

  //   final Map<String, dynamic> body = {"status": 5};

  //   final http.Response response = await http.put(
  //     uri,
  //     headers: headers,
  //     body: jsonEncode(body),
  //   );

  //   print('Update end BODY : ${response.statusCode}');
  //   print('Update end BODY : ${response.body}');

  //   if (response.statusCode == 400) {
  //     Get.snackbar(
  //         "Check-in is unavailable now", json.decode(response.body)['message']);
  //     throw Exception('Update trip status false');
  //   }

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     final responseApi = ResponseApi.fromJson(data);
  //     return responseApi;
  //   } else {
  //     throw Exception('Update trip status false');
  //   }
  // }
}
