import 'package:fbus_app_driver/src/pages/driver/dashboard/start/dashboard_start_trip_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:get/get.dart';

class DashboardStartTripPage extends StatefulWidget {
  DashboardStartTripController con = Get.put(DashboardStartTripController());
  @override
  State<DashboardStartTripPage> createState() => _DashboardStartTripPageState();
}

class _DashboardStartTripPageState extends State<DashboardStartTripPage> {
  MapType _currenMapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _googleMaps(),
          Positioned(
            bottom: 40,
            left: 20,
            child: _redirectToDeparture(),
          ),
          Positioned(
            bottom: 100,
            left: 20,
            child: _redirectToDestination(),
          ),
          Positioned(
            top: 50,
            right: 30,
            child: _changeMapType(),
          ),
          Positioned(
            bottom: 40,
            right: MediaQuery.of(context).size.width * 0.5 - 50 - 15,
            child: _buttonEndTrip(),
          ),
        ],
      ),
    );
  }

  Widget _buttonEndTrip() {
    return GestureDetector(
      onTap: () => widget.con.goToHome(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(1),
              spreadRadius: 5,
              blurRadius: 7,
            ),
          ],
        ),
        child: Image.asset(
          "assets/icon/ico_end.png",
          width: 50,
          height: 50,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _changeMapType() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
        minimumSize: MaterialStateProperty.all<Size>(Size(50, 50)),
      ),
      onPressed: () {
        setState(() {
          _currenMapType = _currenMapType == MapType.normal
              ? MapType.satellite
              : MapType.normal;
        });
      },
      child: Icon(
        Icons.hourglass_bottom_rounded,
        size: 20,
      ),
    );
  }

  Widget _redirectToDestination() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
        minimumSize: MaterialStateProperty.all<Size>(Size(50, 50)),
      ),
      onPressed: () => widget.con.goToDetination(),
      child: Icon(
        Icons.location_searching,
        size: 20,
      ),
    );
  }

  Widget _redirectToDeparture() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
        minimumSize: MaterialStateProperty.all<Size>(Size(50, 50)),
      ),
      onPressed: () => widget.con.goToDeparture(),
      child: Icon(
        Icons.location_on,
        size: 20,
      ),
    );
  }

  Widget _googleMaps() {
    return GoogleMap(
      initialCameraPosition: widget.con.initialPosition,
      mapType: _currenMapType,
      onMapCreated: widget.con.onMapCreate,
      myLocationButtonEnabled: true, //icon
      myLocationEnabled: true,
      onCameraMove: (position) {
        widget.con.initialPosition = position;
      },
      markers: {
        widget.con.departureMarker,
        widget.con.destinationMarker,
      },
      polylines: {widget.con.polyline},
    );
  }
}
