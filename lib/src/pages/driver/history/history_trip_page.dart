import 'dart:convert';

import 'package:dotted_line/dotted_line.dart';
import 'package:fbus_app_driver/src/core/const/colors.dart';
import 'package:fbus_app_driver/src/core/helpers/image_helper.dart';
import 'package:fbus_app_driver/src/environment/environment.dart';
import 'package:fbus_app_driver/src/models/response_api.dart';
import 'package:fbus_app_driver/src/models/trip_model.dart';
import 'package:fbus_app_driver/src/models/users.dart';
import 'package:fbus_app_driver/src/pages/driver/history/history_trip_controller.dart';
import 'package:fbus_app_driver/src/utils/helper.dart';
import 'package:fbus_app_driver/src/widgets/app_bar_container.dart';
import 'package:fbus_app_driver/src/widgets/skelton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class HistoryTripPage extends StatefulWidget {
  @override
  State<HistoryTripPage> createState() => _HistoryTripPageState();
}

class _HistoryTripPageState extends State<HistoryTripPage> {
  HistoryTripController con = Get.put(HistoryTripController());
  FlutterSecureStorage storage = const FlutterSecureStorage();
  double screenWidth = 0;
  bool listIsEmpty = false;
  bool _isFirstLoadRunning = false;
  List<TripModel> _listTripDone = [];

  _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true; // Display a progress indicator at the bottom
    });

    try {
      String? accessToken = await storage.read(key: 'accessToken');
      UserModel driverUser =
          UserModel.fromJson(GetStorage().read('driverUser') ?? {});

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
        List responseApi = ResponseApi.fromJson(data).data;
        _listTripDone = responseApi
            .map((item) => TripModel.fromJson(item))
            .where((trip) => trip.status == 5)
            .toList();
      }
    } catch (err) {
      print('Something went wrong');
    }

    setState(() {
      _isFirstLoadRunning = false; // Display a progress indicator at the bottom
    });
  }

  @override
  void initState() {
    super.initState();
    _firstLoad();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async {
        setState(() {
          // _page = 1;
          // _limit = 3;
          // _hasNextPage = true;
        });
        await _firstLoad();
      },
      child: _isFirstLoadRunning
          ? Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20, left: 25, bottom: 10),
                  child: Row(
                    children: [
                      Skelton(
                        height: 30,
                        width: 300,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Skelton(
                        height: 220,
                        width: 310,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Skelton(
                        height: 220,
                        width: 310,
                      ),
                    ],
                  ),
                ),
              ],
            )
          : _listTripDone.isEmpty
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: const Center(
                          child: Text(
                            "No History",
                            style: TextStyle(
                              color: AppColor.busdetailColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 300,
                      ),
                    ],
                  ),
                )
              : Column(children: [
                  Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Text(
                        'List of trips done',
                        style: TextStyle(
                          color: AppColor.busdetailColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                  _listTripDone.length <= 2
                      ? Expanded(
                          child: Container(
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height,
                            ),
                            child: ListView.builder(
                              // controller: _controller,
                              itemCount: _listTripDone.length,
                              itemBuilder: (context, index) {
                                return _listItem(context, index);
                              },
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            // controller: _controller,
                            itemCount: _listTripDone.length,
                            itemBuilder: (context, index) {
                              return _listItem(context, index);
                            },
                          ),
                        ),
                ]),
    ));
  }

  Widget _listItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: const BoxDecoration(
          // color: Colors.greenAccent,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        width: screenWidth * 0.75,
        child: Stack(
          children: [
            Card(
              elevation: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 0,
                    ),
                    Text(
                      "FPT Bus",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 120,
                          width: screenWidth * 0.63,
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "Start",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "End",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: 17,
                                    height: 17,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      border: Border.all(
                                        color: Colors.orange,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 2,
                                    height: 86,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.orange, Colors.black54],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 17,
                                    height: 17,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      border: Border.all(
                                        color: Colors.black54,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Container(
                                width: 130,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _listTripDone[index].departure,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      _listTripDone[index].destination,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(),
                      ],
                    ),
                    Container(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 20,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.17),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(100),
                                bottomRight: Radius.circular(100),
                              ),
                            ),
                          ),
                          DottedLine(
                            direction: Axis.horizontal,
                            dashColor: Colors.black.withOpacity(0.2),
                            // dashGradient: [Colors.red, Colors.blue],
                            lineLength: screenWidth * 0.55,
                            lineThickness: 3,
                          ),
                          Container(
                            width: 20,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.17),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(100),
                                bottomLeft: Radius.circular(100),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 60,
                      margin: const EdgeInsets.only(
                          left: 35, right: 35, bottom: 15),
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/icon/ico_time.png",
                                    width: 20,
                                    height: 20,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    _listTripDone[index].departureTime,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/icon/ico_schedule_bus_list.png",
                                    width: 20,
                                    height: 20,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    _listTripDone[index]
                                        .departureDate
                                        .toString()
                                        .split(" ")[0],
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.orange,
                            ),
                            // padding: EdgeInsets.all(15),
                            child: Text(
                              _listTripDone[index].ticketQuantity.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // trip.status == 5
            //     ? Positioned(
            //         right: 20,
            //         child: Image.asset(
            //           "assets/images/bookmark.png",
            //           width: 40,
            //         ),
            //       )
            //     : Container(),
          ],
        ),
      ),
    );
  }
}
