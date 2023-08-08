import 'package:fbus_app_driver/src/models/response_api.dart';
import 'package:fbus_app_driver/src/models/route_model.dart';
import 'package:fbus_app_driver/src/models/trip_model.dart';
import 'package:fbus_app_driver/src/providers/routes_provider.dart';
import 'package:fbus_app_driver/src/providers/trips_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DashboardCheckinController extends GetxController {
  // TripModel trip = TripModel.fromJson(Get.arguments['trip']);
  String routeId = GetStorage().read('routeId');
  String tripId = GetStorage().read('tripId');
  // DashboardCheckinController() {
  //   print(trip.toJson());
  // }

  TripsProviders tripsProviders = TripsProviders();
  RoutesProvider routesProvider = RoutesProvider();
  final storage = const FlutterSecureStorage();

  void goToQrCode() {
    Get.toNamed('/dashboard-qr');
  }

  void goToStartTrip() async {
    String? accessToken = await storage.read(key: 'accessToken');
    RouteModel? route;
    if (accessToken != null) {
      ResponseApi updateResponse =
          await tripsProviders.updateTripStatus(tripId, accessToken, 4);

      if (updateResponse.data == null) {
        Fluttertoast.showToast(
          msg: updateResponse.message ?? "",
          fontSize: 16,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.black54,
        );
      } else {
        ResponseApi responseApi =
            await routesProvider.getRouteById(routeId, accessToken);
        route = RouteModel.fromJson(responseApi.data);
        Get.offNamedUntil("/dashboard-start-trip", (route) => false,
            arguments: {'route': route, 'tripId': tripId});
      }
    }
  }
}
