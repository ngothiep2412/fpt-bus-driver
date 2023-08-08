import 'dart:async';
import 'package:fbus_app_driver/src/models/route_model.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DashboardMapController extends GetxController {
  RouteModel? route;

  DashboardMapController(RouteModel route) {
    this.route = route;
    _initializeGoogleData();
  }

  Completer<GoogleMapController> mapController = Completer();
  // late BitmapDescriptor departureIcon;
  // late BitmapDescriptor destinationIcon;

  late CameraPosition initialPosition;
  late Marker departureMarker;
  late Marker destinationMarker;
  late Polyline polyline;

  Future<void> _initializeGoogleData() async {
    initialPosition = CameraPosition(
      target: LatLng(
        (double.parse(route!.departureCoordinates.first.latitude) +
                double.parse(route!.destinationCoordinates.first.latitude)) /
            2,
        (double.parse(route!.departureCoordinates.first.longitude) +
                double.parse(route!.destinationCoordinates.first.longitude)) /
            2,
      ),
      zoom: 11,
    );

    departureMarker = Marker(
      markerId: const MarkerId("_departureMarker"),
      infoWindow: InfoWindow(title: "Departure", snippet: route?.departure),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: LatLng(
        double.parse(route!.departureCoordinates.first.latitude),
        double.parse(route!.departureCoordinates.first.longitude),
      ),
    );

    destinationMarker = Marker(
      markerId: const MarkerId("_destinationMarker"),
      infoWindow: InfoWindow(title: "Destiny", snippet: route?.destination),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      position: LatLng(
        double.parse(route!.destinationCoordinates.first.latitude),
        double.parse(route!.destinationCoordinates.first.longitude),
      ),
    );

    polyline = Polyline(
      polylineId: const PolylineId('_polyline'),
      points: [
        LatLng(
          double.parse(route!.departureCoordinates.first.latitude),
          double.parse(route!.departureCoordinates.first.longitude),
        ), //start
        LatLng(
          double.parse(route!.destinationCoordinates.first.latitude),
          double.parse(route!.destinationCoordinates.first.longitude),
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
            double.parse(route!.departureCoordinates.first.latitude),
            double.parse(route!.departureCoordinates.first.longitude),
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
            double.parse(route!.destinationCoordinates.first.latitude),
            double.parse(route!.destinationCoordinates.first.longitude),
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
}
