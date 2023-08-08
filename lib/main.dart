import 'package:fbus_app_driver/src/models/users.dart';
import 'package:fbus_app_driver/src/pages/driver/dashboard/checkin/dashboard_checkin_page.dart';
import 'package:fbus_app_driver/src/pages/driver/dashboard/detail/dashboard_detail_page.dart';
import 'package:fbus_app_driver/src/pages/driver/dashboard/loadMore/load_more_page.dart';
import 'package:fbus_app_driver/src/pages/driver/dashboard/qr/dashboard_qr_page.dart';
import 'package:fbus_app_driver/src/pages/driver/dashboard/start/dashboard_start_trip_page.dart';
import 'package:fbus_app_driver/src/pages/driver/home/home_page.dart';
import 'package:fbus_app_driver/src/pages/driver/profile/update/update_profile_page.dart';
import 'package:fbus_app_driver/src/pages/landingPage/landing_page.dart';
import 'package:fbus_app_driver/src/pages/loginByDriver/login.dart';
import 'package:fbus_app_driver/src/pages/onboard/intro_page.dart';
import 'package:fbus_app_driver/src/pages/sentOtp/sent_otp_page.dart';
import 'package:fbus_app_driver/src/pages/splashScreen/splash_screen.dart';
import 'package:fbus_app_driver/src/providers/push_notifications_provider.dart';
import 'package:fbus_app_driver/src/utils/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'src/core/const/colors.dart';

PushNotificationsProvider pushNotificationsProvider =
    PushNotificationsProvider();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Recibiendo notificacion en segundo plano ${message.messageId}');
  // pushNotificationsProvider.showNotification(message);
}

const storage = FlutterSecureStorage();

Future<void> initializeFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // Initialize Firebase and wait for it to complete
  await Firebase.initializeApp(
    name: 'f-bus-driver',
    options: FirebaseConfig.currentPlatform,
  );

  // Get the Firebase Messaging token and write it to storage
  final token = await FirebaseMessaging.instance.getToken();
  await storage.write(key: 'firebaseToken', value: token);
  print('getToken: $token');

  // Set the onBackgroundMessage handler and initialize push notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  pushNotificationsProvider.initPushNotifications();
}

UserModel userModel = UserModel.fromJson(GetStorage().read("driverUser") ?? {});

void main() async {
  await initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<int> _onBoardFuture;
  @override
  void initState() {
    _onBoardFuture = _loadData();
    pushNotificationsProvider.onMessageListener(context);
    super.initState();
  }

  Future<void> _init() async {
    // Retrieve the accessToken from storage
    String? accessToken = await storage.read(key: 'accessToken');

    // If accessToken is not found, do something (e.g. show an error)
    if (accessToken == null) {
      return;
    }

    // Otherwise, store the accessToken value and continue with initialization
    Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
    int expirationTimestamp = decodedToken['exp'] * 1000;
    if (DateTime.now().millisecondsSinceEpoch > expirationTimestamp) {
      signOut();
    }
    // Perform any other initialization tasks here...
  }

  void signOut() async {
    GetStorage().remove('user');
    await storage.deleteAll();
    Get.offNamedUntil('/splash', (route) => false);
  }

  // Load data from SharedPreferences to get key: onBoard
  Future<int> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('onBoard') ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return FutureBuilder<int>(
      future: _onBoardFuture,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          bool isViewed = snapshot.data == null ? false : snapshot.data == 0;
          String initialRoute;
          initialRoute = isViewed
              ? userModel.id != null
                  ? '/home-driver'
                  : '/splash'
              : '/intro';
          return GetMaterialApp(
            // themeMode: Get.find<ThemeController>().isDarkMode
            //     ? ThemeMode.dark
            //     : ThemeMode.light,
            title: 'F-BUS',
            debugShowCheckedModeBanner: false,
            initialRoute: initialRoute,
            getPages: [
              GetPage(name: '/', page: () => LandingPage()),
              GetPage(name: '/intro', page: () => IntroPage()),
              GetPage(name: '/splash', page: () => SplashScreen()),
              GetPage(name: '/login-by-driver', page: () => LoginPage()),
              GetPage(name: '/sent-otp', page: () => SendOTPPage()),
              GetPage(name: '/home-driver', page: () => HomaeDriverPage()),
              GetPage(name: '/dashboard-qr', page: () => DashboardQrPage()),
              GetPage(name: '/dashboard/see_more', page: () => LoadMorePage()),
              GetPage(
                  name: '/dashboard-detail', page: () => DashboardDetailPage()),
              GetPage(name: '/profile/update', page: () => UpdateProfilePage()),
              GetPage(
                  name: '/dashboard-checkin',
                  page: () => DashboardCheckinPage()),
              GetPage(
                  name: '/dashboard-start-trip',
                  page: () => DashboardStartTripPage()),
            ],
            theme: ThemeData(
                fontFamily: "Metropolis",
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      AppColor.orange,
                    ),
                    shape: MaterialStateProperty.all(
                      const StadiumBorder(),
                    ),
                    elevation: MaterialStateProperty.all(0),
                  ),
                ),
                textButtonTheme: TextButtonThemeData(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(
                      AppColor.orange,
                    ),
                  ),
                ),
                primaryColor: AppColor.orange,
                colorScheme: const ColorScheme(
                  primary: AppColor.orange,
                  secondary: Colors.amberAccent,
                  brightness: Brightness.light,
                  onBackground: Colors.grey,
                  onPrimary: Colors.white,
                  surface: Colors.grey,
                  onSurface: Colors.grey,
                  error: Colors.grey,
                  onError: Colors.grey,
                  onSecondary: Colors.grey,
                  background: Colors.grey,
                )),
            navigatorKey: Get.key,
          );
        } else {
          // While data is loading, display a loading indicator
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
