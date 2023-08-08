import 'dart:async';
import 'package:fbus_app_driver/src/utils/helper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  final storage = const FlutterSecureStorage();
  Timer? _timer;
  startTimer() {
    _timer = Timer(const Duration(seconds: 3), () async {
      // assets token ??
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken != null) {
        Get.offNamedUntil('/navigation', (route) => false);
      } else {
        //send user to home screen
        Get.offNamedUntil('/', (route) => false);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller with duration and vsync
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Create a Tween animation to specify the range of values for animation
    final tween = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.25),
    );

    // Create the animation with the tween and controller
    _animation = tween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    // Start the animation when the widget is loaded
    _animationController.forward();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Helper.getScreenWidth(context),
        height: Helper.getScreenHeight(context),
        child: Stack(
          children: [
            _splashImage(),
            _logo(),
          ],
        ),
      ),
    );
  }

  Widget _splashImage() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Image.asset(
        Helper.getAssetName("splashIcon.png"),
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _logo() {
    return AnimatedPositioned(
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
      left: 0,
      right: 0,
      top: MediaQuery.of(context).size.height * 0.2,
      child: SlideTransition(
        position: _animation,
        child: Image.asset(
          Helper.getAssetName("fbus.png"),
          width: 280,
        ),
      ),
    );
  }
}
