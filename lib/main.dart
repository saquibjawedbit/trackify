import 'package:bit_book/Screens/authentication_screen.dart';
import 'package:bit_book/Screens/home_screen.dart';
import 'package:bit_book/Screens/onboard_screen.dart';
import 'package:bit_book/Widgets/buttons/controllers/authentication/user_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'Screens/landing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final UserController userController = Get.put(UserController());
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bit Book',
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingScreen(),
        '/authentication': (context) => const AuthenticationScreen(),
        '/onboard': (context) => const OnboardScreen(),
        '/home': (context) => const HomeScreen(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 52, 86),
          primary: const Color.fromARGB(255, 17, 17, 17),
          secondary: const Color.fromARGB(255, 255, 52, 86),
          onPrimary: const Color.fromARGB(255, 35, 35, 35),
        ),
        useMaterial3: true,
      ),
    );
  }
}
