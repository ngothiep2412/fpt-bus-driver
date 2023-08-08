import 'dart:io';
import 'package:fbus_app_driver/src/pages/driver/dashboard/qr/dashboard_qr_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class DashboardQrPage extends StatefulWidget {
  @override
  State<DashboardQrPage> createState() => _DashboardQrPageState();
}

class _DashboardQrPageState extends State<DashboardQrPage> {
  DashboardQrController con = Get.put(DashboardQrController());

  final qrKey = GlobalKey(debugLabel: 'QR');

  //Result after scan
  Barcode? barcode;
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                child: buildQrView(context),
              ),
              Positioned(bottom: 50, child: buildResult(context)),
              Positioned(top: 20, child: buildControlButtons()),
              Positioned(top: 25, left: 25, child: buildBackButton())
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBackButton() => GestureDetector(
        onTap: () => con.goBack(),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 6),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
        ),
      );

  Widget buildControlButtons() => Container(
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
                onPressed: () async {
                  await controller?.toggleFlash();
                  setState(() {});
                },
                icon: FutureBuilder<bool?>(
                  future: controller?.getFlashStatus(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return Icon(
                        snapshot.data! ? Icons.flash_on : Icons.flash_off,
                        color: Colors.white,
                      );
                    } else {
                      return Container();
                    }
                  },
                )),
            IconButton(
                onPressed: () async {
                  await controller?.flipCamera();
                  setState(() {});
                },
                icon: FutureBuilder(
                  future: controller?.getCameraInfo(),
                  builder: ((context, snapshot) {
                    if (snapshot.data != null) {
                      return Icon(
                        Icons.switch_camera,
                        color: Colors.white,
                      );
                    } else {
                      return Container();
                    }
                  }),
                )),
          ],
        ),
      );

  //Qr Result View
  Widget buildResult(context) => GestureDetector(
        onTap: () {
          //Click the result
          con.checkIn(barcode!);
        },
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              barcode == null ? 'Scanning a code' : "Tap a link to Check-in",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.only(top: 15, bottom: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: Colors.white60),
              ),
              child: Text(
                barcode != null ? barcode!.code!.split('/').last : '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  // overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      );

  //Qr View
  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
            cutOutSize: MediaQuery.of(context).size.width * 0.7,
            borderWidth: 12,
            borderLength: 50,
            borderRadius: 20,
            borderColor: Colors.orange),
      );

  void onQRViewCreated(QRViewController controller) {
    setState(() => {this.controller = controller});

    controller.scannedDataStream.listen((barcode) async {
      setState(() => this.barcode = barcode);
    });
  }
}
