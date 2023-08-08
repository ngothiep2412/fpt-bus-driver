import 'dart:async';

import 'package:fbus_app_driver/src/models/response_api.dart';
import 'package:fbus_app_driver/src/models/route_model.dart';
import 'package:fbus_app_driver/src/providers/trips_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DashboardStartTripController extends GetxController {
  RouteModel route = Get.arguments['route'];
  String tripId = Get.arguments['tripId'];
  TripsProviders tripsProviders = TripsProviders();
  final storage = const FlutterSecureStorage();

  DashboardStartTripController() {
    _initializeGoogleData();
  }

  Completer<GoogleMapController> mapController = Completer();

  late CameraPosition initialPosition;
  late Marker departureMarker;
  late Marker destinationMarker;
  late Polyline polyline;

  Future<void> _initializeGoogleData() async {
    initialPosition = CameraPosition(
      target: LatLng(
        (double.parse(route.departureCoordinates.first.latitude) +
                double.parse(route.destinationCoordinates.first.latitude)) /
            2,
        (double.parse(route.departureCoordinates.first.longitude) +
                double.parse(route.destinationCoordinates.first.longitude)) /
            2,
      ),
      zoom: 11,
    );

    departureMarker = Marker(
      markerId: const MarkerId("_departureMarker"),
      infoWindow: InfoWindow(title: "Departure", snippet: route.departure),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: LatLng(
        double.parse(route.departureCoordinates.first.latitude),
        double.parse(route.departureCoordinates.first.longitude),
      ),
    );

    destinationMarker = Marker(
      markerId: const MarkerId("_destinationMarker"),
      infoWindow: InfoWindow(title: "Destiny", snippet: route.destination),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      position: LatLng(
        double.parse(route.destinationCoordinates.first.latitude),
        double.parse(route.destinationCoordinates.first.longitude),
      ),
    );

    polyline = Polyline(
      polylineId: const PolylineId('_polyline'),
      points: [
        LatLng(
          double.parse(route.departureCoordinates.first.latitude),
          double.parse(route.departureCoordinates.first.longitude),
        ), //start
        LatLng(
          double.parse(route.destinationCoordinates.first.latitude),
          double.parse(route.destinationCoordinates.first.longitude),
        ), //end
      ],
      width: 5,
    );
  }

  Future<void> goToDeparture() async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            double.parse(route.departureCoordinates.first.latitude),
            double.parse(route.departureCoordinates.first.longitude),
          ),
          zoom: 14,
        ),
      ),
    );
  }

  Future<void> goToDetination() async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            double.parse(route.destinationCoordinates.first.latitude),
            double.parse(route.destinationCoordinates.first.longitude),
          ),
          zoom: 14,
        ),
      ),
    );
  }

  void onMapCreate(GoogleMapController controller) {
    if (!mapController.isCompleted) {
      mapController.complete(controller);
    }
  }

  void goToHome() async {
    String? accessToken = await storage.read(key: 'accessToken');

    if (accessToken != null) {
      ResponseApi updateResponse =
          await tripsProviders.updateTripStatus(tripId, accessToken, 5);
      if (updateResponse.data == null) {
        Fluttertoast.showToast(
          msg: updateResponse.message ?? "",
          fontSize: 16,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.black54,
        );
      } else {
        Fluttertoast.showToast(
          msg: "You are completing 1 trip. Have a nice day.",
          fontSize: 15,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.black54,
        );
        Get.offNamedUntil("/home-driver", (route) => false);
      }
    }
  }
}
