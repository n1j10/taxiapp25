import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taxi/user/Home.dart';
import 'package:taxi/user/Login.dart';

import 'Visitor/Visitor.dart';
import 'driver/login.dart';

Future<void> _fr(RemoteMessage messsage) async {
  //تعمل عندما يكون التطبيق مغلق الاشعار
  if (kDebugMode) {
    print(messsage.messageId);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initOneSignal();
  FirebaseMessaging.onBackgroundMessage(_fr);
  runApp(const MyApp());
}

void initOneSignal() {
  OneSignal.shared.setAppId("90aa34d8-1168-4157-aac3-b9c1c4055e39");
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Welcome Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.cairoTextTheme(),
        useMaterial3: true,
      ),
      home: (FirebaseAuth.instance.currentUser != null)
          ? Homeone(FirebaseAuth.instance.currentUser!.email.toString().trim())
          : WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<Offset>> _slideAnimations;
  late final List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    OneSignal.shared.getDeviceState().then((deviceState) {
      print("User Iسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسس"
          "سسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسسD: ${deviceState?.userId}");
    });
    super.initState();

    _controllers = List.generate(
      3,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this,
      ),
    );

    _slideAnimations = _controllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ));
    }).toList();

    _fadeAnimations = _controllers.map((controller) {
      return CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      );
    }).toList();

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      _controllers[i].forward();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget buildAnimatedButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    required Animation<Offset> slideAnimation,
    required Animation<double> fadeAnimation,
  }) {
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.deepPurple,
            minimumSize: const Size(double.infinity, 50),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: Icon(icon),
          label: Text(
            text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'مرحبًا بك',
                    style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),

                  /// زر 1 - الدخول كمستخدم
                  buildAnimatedButton(
                    text: "الدخول كمستخدم",
                    icon: Icons.person,
                    onPressed: () {
                      Get.to(Loginuser());
                    },
                    slideAnimation: _slideAnimations[0],
                    fadeAnimation: _fadeAnimations[0],
                  ),
                  const SizedBox(height: 16),

                  /// زر 2 - الدخول كسائق
                  buildAnimatedButton(
                    text: "الدخول كسائق",
                    icon: Icons.drive_eta,
                    onPressed: () {
                      Get.to(Logindriver());
                    },
                    slideAnimation: _slideAnimations[1],
                    fadeAnimation: _fadeAnimations[1],
                  ),
                  const SizedBox(height: 16),

                  /// زر 3 - الدخول كزائر ضيف
                  buildAnimatedButton(
                    text: "الدخول كزائر ضيف",
                    icon: Icons.person_outline,
                    onPressed: () {
                      Get.to(Visitor());
                    },
                    slideAnimation: _slideAnimations[2],
                    fadeAnimation: _fadeAnimations[2],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
