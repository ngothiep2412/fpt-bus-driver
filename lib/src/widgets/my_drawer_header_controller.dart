import 'package:fbus_app_driver/src/models/users.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyDrawerHeaderController extends GetxController {
  var user = UserModel.fromJson(GetStorage().read('driverUser') ?? {}).obs;
}
