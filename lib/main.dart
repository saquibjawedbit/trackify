import 'package:bit_book/Screens/authentication_screen.dart';
import 'package:bit_book/Screens/onboard_screen.dart';
import 'package:flutter/material.dart';

import 'Screens/landing_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bit Book',
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingScreen(),
        '/authentication': (context) => const AuthenticationScreen(),
        '/onboard': (context) => const OnboardScreen(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 52, 86),
          primary: const Color.fromARGB(255, 17, 17, 17),
          secondary: const Color.fromARGB(255, 255, 52, 86),
        ),
        useMaterial3: true,
      ),
    );
  }
}
