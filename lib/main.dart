import 'package:f_star/controllers/authentication_controller.dart';
import 'package:f_star/screens/authentication/forgot_password_screen.dart';
import 'package:f_star/screens/authentication/login_screen.dart';
import 'package:f_star/screens/authentication/signup_screen.dart';
import 'package:f_star/screens/get_started_screen.dart';
import 'package:f_star/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthenticationController>(
      AuthenticationController(),
      permanent: true,
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: "./.env");
  runApp(const MyApp());
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          // If we have user data, they're logged in
          if (snapshot.hasData && snapshot.data != null) {
            return const HomeScreen();
          } else {
            return const GetStartedScreen();
          }
        },
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'F* Attendance Tracker',
      initialBinding: InitialBinding(),
      home: const AuthWrapper(),
      defaultTransition: Transition.fade,
      getPages: [
        GetPage(
          name: '/',
          page: () => const GetStartedScreen(),
          transition: Transition.fade,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: '/signup',
          page: () => const SignupScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: '/forgot-password',
          page: () => const ForgotPasswordScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: '/home',
          page: () => const HomeScreen(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ],
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(255, 125, 246, 255),
          onPrimary: Color.fromARGB(255, 15, 23, 23),
          secondary: Color.fromARGB(255, 38, 56, 59),
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          surface: Color.fromARGB(255, 23, 15, 15),
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 15, 23, 23),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 56, 84, 87),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 56, 84, 87),
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: const Color.fromARGB(255, 28, 38, 41),
          labelStyle:
              const TextStyle(color: Color.fromARGB(255, 153, 186, 189)),
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 153, 186, 189),
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
          headlineLarge: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
          titleSmall: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
          labelMedium: TextStyle(color: Colors.white),
          labelSmall: TextStyle(
            color: Color.fromARGB(255, 153, 186, 189),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        useMaterial3: true,
      ),
    );
  }
}
