import 'dart:convert';

import 'package:fbus_app_driver/src/environment/environment.dart';
import 'package:fbus_app_driver/src/models/response_api.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class RoutesProvider extends GetConnect {
  Future<ResponseApi> getRouteById(String id, String accessToken) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/route/$id');
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
      final responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } else {
      throw Exception('Failed to get route');
    }
  }
}
