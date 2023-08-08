import 'package:fbus_app_driver/src/pages/driver/dashboard/detail/dashboard_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardDetailPage extends StatelessWidget {
  DashboardDetailController con = Get.put(DashboardDetailController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.42,
                child: Image.asset(
                  'assets/images/GoogleMapTA.webp',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.42,
                color: Colors.black12,
              ),
              Positioned(
                bottom: 0,
                top: MediaQuery.of(context).size.height * 0.32,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: 40,
                        height: 8,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      //route
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Bus icon
                          Container(
                            padding: EdgeInsets.only(left: 50),
                            child: Image.asset(
                              "assets/icon/ico_bus_color.png",
                              width: 40,
                              height: 40,
                            ),
                          ),
                          const SizedBox(
                            height: 0,
                          ),
                          //route line
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 60),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    border: Border.all(
                                      color: Colors.orange,
                                      width: 3,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 190,
                                  height: 4,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.orange, Colors.black],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          //Route name
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 150,
                                child: Text(
                                  con.trip.departure,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                width: 150,
                                child: Text(
                                  con.trip.destination,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Schedule",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 200,
                                height: 100,
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.orange.withOpacity(0.7),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      // offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Image.asset(
                                          "assets/icon/ico_time.png",
                                          width: 22,
                                          height: 22,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          con.trip.departureTime,
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Image.asset(
                                          "assets/icon/ico_schedule_bus_list.png",
                                          width: 21,
                                          height: 21,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          con.trip.departureDate
                                              .toString()
                                              .split(" ")[0],
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ticket",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 100,
                                height: 100,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.orange.withOpacity(0.7),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 21,
                                      left: 8,
                                      child: Container(
                                        width: 40,
                                        alignment: Alignment.center,
                                        child: Text(
                                          con.trip.ticketCount.toString(),
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        alignment: Alignment.center,
                                        color: Colors.transparent,
                                        child: Text(
                                          "/",
                                          style: TextStyle(fontSize: 60),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 21,
                                      right: 8,
                                      child: Container(
                                        width: 40,
                                        alignment: Alignment.center,
                                        child: Text(
                                          con.trip.ticketQuantity.toString(),
                                          style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icon/ico_qr.png",
                              color: Colors.white,
                              width: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              child: GestureDetector(
                                onTap: () => con.goToCheckin(),
                                child: const Text(
                                  "Check-in",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    shadows: [
                                      Shadow(
                                        color: Colors.white,
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
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
              Positioned(
                top: 50,
                left: 30,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.only(left: 8.0),
                  child: IconButton(
                    alignment: Alignment.center,
                    onPressed: () => con.goBack(),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.orange,
                      size: 18,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                right: 30,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // padding: EdgeInsets.only(left: 8.0),
                  child: IconButton(
                      alignment: Alignment.center,
                      onPressed: () {
                        con.openGoogleMap(context);
                      },
                      icon: const Icon(
                        Icons.map_outlined,
                        color: Colors.orange,
                        size: 25,
                      )
                      // con.trip.status != 1
                      //     ? Icon(
                      //         Icons.cancel_outlined,
                      //         color: Colors.red,
                      //         size: 25,
                      //       )
                      //     : Icon(
                      //         // Icons.check_circle_outline,
                      //         Icons.map_outlined,
                      //         color: Colors.green,
                      //         size: 25,
                      //       ),
                      ),
                ),
              ),
              // con.trip.status != 1
              //     ? Positioned(
              //         bottom: 0,
              //         top: MediaQuery.of(context).size.height * 0.32,
              //         left: 0,
              //         right: 0,
              //         child: Container(
              //           padding: EdgeInsets.symmetric(horizontal: 30),
              //           decoration: BoxDecoration(
              //             color: Colors.grey.withOpacity(0.35),
              //             borderRadius: BorderRadius.only(
              //               topLeft: Radius.circular(50),
              //               topRight: Radius.circular(50),
              //             ),
              //           ),
              //         ),
              //       )
              //     :
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
