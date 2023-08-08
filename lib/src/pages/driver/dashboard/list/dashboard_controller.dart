import 'package:fbus_app_driver/src/models/response_api.dart';
import 'package:fbus_app_driver/src/models/trip_model.dart';
import 'package:fbus_app_driver/src/models/users.dart';
import 'package:fbus_app_driver/src/providers/trips_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DashboardController extends GetxController {
  TripsProviders tripsProviders = TripsProviders();
  final storage = const FlutterSecureStorage();

  UserModel driverUser =
      UserModel.fromJson(GetStorage().read('driverUser') ?? {});

  List<TripModel> trips = <TripModel>[].obs;
  var title = ''.obs;

  DashboardController() {
    print('Trip in storage : ${GetStorage().read('todayTrips')}');
    getTodayTrip();
  }

  getTodayTrip() async {
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken != null) {
      var tripList = await tripsProviders.getAllTodayTrip(accessToken);
      if (GetStorage().read('todayTrips') == null) {
        GetStorage().write('todayTrips', tripList);
        print('Trip in storage : ${GetStorage().read('todayTrips')}');
      }
      trips.clear();
      if (tripList.where((trip) => trip.status == 1).isNotEmpty &&
          tripList
              .where((trip) => DateTime.parse(
                      "${DateTime.now().toString().split(' ')[0]} ${trip.departureTime}")
                  .isAfter(DateTime.now()))
              .isNotEmpty) {
        trips.add(tripList.firstWhere((trip) =>
            trip.status == 1 &&
            DateTime.parse(
                    "${DateTime.now().toString().split(' ')[0]} ${trip.departureTime}")
                .isAfter(DateTime.now())));
      }
      title.value = 'Ready for the next trip';
    }
  }

  void getAllTodayTrip() async {
    // if(GetStorage().read('todayTrips').length)
    // Error since the list obj in STORAGE is not being correctly converted to a List<TripModel> object.
    // List<TripModel> tripList = GetStorage().read('todayTrips');

    // Convert List<dynamic> to List<TripModel>
    // map each item -> convert each item into TripModel -> add to the list (.toList)
    List<TripModel> tripList = List<TripModel>.from(GetStorage()
        .read('todayTrips')
        .map((item) => TripModel.fromJson(item))
        .toList());

    if (tripList.length > 1) {
      trips.clear();
      trips.addAll(tripList.where((trip) => trip.status == 1));
    }
    title.value = "Today's trip schedule";
  }

  void goToQrPage() {
    Get.toNamed('/dashboard-qr');
  }

  void goToDetail(TripModel trip) async {
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken != null) {
      ResponseApi responseApi =
          await tripsProviders.getTripDetail(accessToken, trip.id);
      final dataTrip = responseApi.data;
      String routeId = dataTrip[0]['route_id'];
      if (GetStorage().hasData('routeId')) {
        GetStorage().remove('routeId');
      }
      if (GetStorage().hasData('tripId')) {
        GetStorage().remove('tripId');
      }
      GetStorage().write('routeId', routeId);
      GetStorage().write('tripId', trip.id);
    }
    Get.toNamed('/dashboard-detail', arguments: {'trip': trip.toJson()});
  }
}
