import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeDriverController extends GetxController {
  final storage = const FlutterSecureStorage();
  void signOut() async {
    GetStorage().erase();
    await storage.deleteAll();
    Get.offNamedUntil('/splash', (route) => false);
  }
}
