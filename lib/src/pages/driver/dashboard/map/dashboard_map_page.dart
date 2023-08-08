import 'package:fbus_app_driver/src/models/route_model.dart';
import 'package:fbus_app_driver/src/pages/driver/dashboard/map/dashboard_map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DashboardMapPage extends StatefulWidget {
  RouteModel? route;
  late DashboardMapController con;

  //Receive param from previous page
  DashboardMapPage({@required this.route}) {
    con = Get.put(DashboardMapController(route!));
  }

  @override
  State<DashboardMapPage> createState() => _DashboardMapPageState();
}

class _DashboardMapPageState extends State<DashboardMapPage> {
  MapType _currenMapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              top: 30,
              right: 30,
              child: _changeMapType(),
            ),
          ],
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
