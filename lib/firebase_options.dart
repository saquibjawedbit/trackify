// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBZTt6sXrNAl_Mi8P24koLIAP5kMFgw-tA',
    appId: '1:31679741662:web:230c8be33b74c726318c4f',
    messagingSenderId: '31679741662',
    projectId: 'bitbook-8ba1e',
    authDomain: 'bitbook-8ba1e.firebaseapp.com',
    storageBucket: 'bitbook-8ba1e.appspot.com',
    measurementId: 'G-7GQWHP1Z9N',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAlI4X_KHLY-ZzdEc1cHSTidiFUNPZOxFI',
    appId: '1:31679741662:android:606973cf201a66d4318c4f',
    messagingSenderId: '31679741662',
    projectId: 'bitbook-8ba1e',
    storageBucket: 'bitbook-8ba1e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA1JYfKcfZHjAkEb0F9F54CGMEfnK8yeUc',
    appId: '1:31679741662:ios:6cd754f3f68f9b1e318c4f',
    messagingSenderId: '31679741662',
    projectId: 'bitbook-8ba1e',
    storageBucket: 'bitbook-8ba1e.appspot.com',
    iosBundleId: 'com.example.bitBook',
  );
}
