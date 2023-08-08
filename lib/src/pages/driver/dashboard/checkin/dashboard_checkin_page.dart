import 'package:fbus_app_driver/src/pages/driver/dashboard/checkin/dashboard_checkin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardCheckinPage extends StatelessWidget {
  DashboardCheckinController con = Get.put(DashboardCheckinController());

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: h * 0.15,
            padding: EdgeInsets.only(
              top: 20,
            ),
            color: Colors.orange,
            alignment: Alignment.center,
            child: const Text(
              "Check-in Page",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: h * 0.8,
            child: Stack(
              children: [
                Container(
                  color: Colors.orange[100],
                  padding: const EdgeInsets.symmetric(
                    vertical: 35,
                  ),
                  child: Image.asset(
                    "assets/images/qr_bg.png",
                    width: double.infinity,
                    height: h * 0.45,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  top: h * 0.5,
                  width: w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => con.goToQrCode(),
                              child: Container(
                                width: 120,
                                height: 120,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.orange.withOpacity(0.7),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  "assets/icon/ico_qr.png",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 80,
                              child: const Text(
                                "Scan QR Code",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => con.goToStartTrip(),
                              child: Container(
                                width: 120,
                                height: 120,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.orange.withOpacity(0.7),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  "assets/icon/ico_start.png",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 80,
                              child: const Text(
                                "Start Trip",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
