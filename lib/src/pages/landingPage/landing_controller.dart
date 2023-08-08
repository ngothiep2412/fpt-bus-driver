import 'package:fbus_app_driver/src/providers/users_provider.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LandingController extends GetxController {
  UsersProviders usersProviders = UsersProviders();
  final storage = const FlutterSecureStorage();

  void goToLoginByDriverPage() {
    Get.toNamed('/login-by-driver');
  }

  void goToHomePage() {
    Get.offNamedUntil('/splash', (route) => false);
  }
}
