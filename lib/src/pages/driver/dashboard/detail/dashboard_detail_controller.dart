import 'package:fbus_app_driver/src/models/response_api.dart';
import 'package:fbus_app_driver/src/models/route_model.dart';
import 'package:fbus_app_driver/src/models/trip_model.dart';
import 'package:fbus_app_driver/src/pages/driver/dashboard/map/dashboard_map_page.dart';
import 'package:fbus_app_driver/src/providers/routes_provider.dart';
import 'package:fbus_app_driver/src/providers/trips_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DashboardDetailController extends GetxController {
  TripModel trip = TripModel.fromJson(Get.arguments['trip']);

  TripsProviders tripsProviders = TripsProviders();
  RoutesProvider routesProvider = RoutesProvider();
  final storage = const FlutterSecureStorage();

  DashboardDetailController() {
    print('Trip : ${trip.toJson()}');
  }

  void goBack() {
    Get.back();
  }

  void goToCheckin() async {
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken != null) {
      ResponseApi updateResponse =
          await tripsProviders.updateTripStatus(trip.id, accessToken, 2);

      if (updateResponse.data == null) {
        Fluttertoast.showToast(
          msg: updateResponse.message ?? "",
          fontSize: 16,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.black54,
        );
      } else {
        Get.toNamed('/dashboard-checkin', arguments: {'trip': trip.toJson()});
      }

      //testing
      // Get.toNamed('/dashboard-checkin', arguments: {'trip': trip.toJson()});
    }
  }

  void openGoogleMap(BuildContext context) async {
    String? accessToken = await storage.read(key: 'accessToken');
    RouteModel? route;
    if (accessToken != null) {
      ResponseApi responseApi =
          await routesProvider.getRouteById(trip.routeId, accessToken);
      route = RouteModel.fromJson(responseApi.data);
      showMaterialModalBottomSheet(
        context: context,
        builder: (context) => DashboardMapPage(
            route:
                route), //Declare at the next Page -> its Controller (both in the contructor)
      );
    }
  }
}
