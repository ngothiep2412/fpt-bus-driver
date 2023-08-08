import 'package:fbus_app_driver/src/core/const/colors.dart';
import 'package:fbus_app_driver/src/models/trip_model.dart';
import 'package:fbus_app_driver/src/pages/driver/dashboard/list/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:dotted_line/dotted_line.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DashboardController con = Get.put(DashboardController());
  bool isLoading = false;
  double screenHeight = 0;

  double screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Obx(
      () => Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              isLoading = true;
            });
            await con.getTodayTrip();
            setState(() {
              isLoading = false;
            });
          },
          child: isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Container(
                    height: 900,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        const DottedLine(
                          lineThickness: 3,
                          lineLength: double.infinity,
                          dashLength: 15,
                          dashGapLength: 15,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        con.trips.isNotEmpty
                            ? Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 20),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      child: Text(
                                        con.title.value,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    con.trips.length <= 1
                                        ? GestureDetector(
                                            // onTap: () => con.getAllTodayTrip(),
                                            onTap: () => {
                                              Get.toNamed(
                                                  '/dashboard/see_more'),
                                            },
                                            child: const Text(
                                              "See more",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: AppColor.busdetailColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          )
                                        : Container()
                                    // : Icon(
                                    //     Icons.arrow_forward_sharp,
                                    //     size: 22,
                                    //   ),
                                  ],
                                ),
                              )
                            : Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 20),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text("No trip ready for you!"),
                              ),
                        con.trips.isNotEmpty
                            ? Container(
                                height: screenHeight * 0.6,
                                child: ScrollSnapList(
                                  itemBuilder: _listItem,
                                  itemCount: con.trips.length,
                                  itemSize: screenWidth * 0.75,
                                  onItemFocus: (index) {},
                                  dynamicItemSize: true,
                                  scrollDirection: Axis.horizontal,
                                ),
                              )
                            : Container(
                                width: double.infinity,
                                height: screenHeight * 0.6,
                                child:
                                    Image.asset("assets/images/empty_list.png"),
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        const DottedLine(
                          lineThickness: 3,
                          lineLength: double.infinity,
                          dashLength: 15,
                          dashGapLength: 15,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _listItem(BuildContext context, int index) {
    TripModel trip = con.trips[index];
    return GestureDetector(
      onTap: () => con.goToDetail(trip),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
                    Row(
                      children: [
                        Container(
                          height: 120,
                          width: screenWidth * 0.63,
                          margin: EdgeInsets.symmetric(horizontal: 5),
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
                                      trip.departure,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      trip.destination,
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
                                    trip.departureTime,
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
                                    trip.departureDate.toString().split(" ")[0],
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
                              trip.ticketQuantity.toString(),
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
