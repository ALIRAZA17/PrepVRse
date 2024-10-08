// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return macos;
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
    apiKey: 'AIzaSyDg-HoZXkKw-vuE5FGQmBoGzJQ8N2wSHaA',
    appId: '1:546418221172:web:448363efcef9b156f93121',
    messagingSenderId: '546418221172',
    projectId: 'prepvrse',
    authDomain: 'prepvrse.firebaseapp.com',
    storageBucket: 'prepvrse.appspot.com',
    measurementId: 'G-GGK5QXGB6M',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBUKkmdCA7O8jz0ZDdtGEAQTNfy3KEMl0o',
    appId: '1:546418221172:android:6c76339ec1a1b7b7f93121',
    messagingSenderId: '546418221172',
    projectId: 'prepvrse',
    storageBucket: 'prepvrse.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAZabuo1GJ3d6l7Ry6upIFaCbr6Sh6Rck4',
    appId: '1:546418221172:ios:a56b6db218c7efccf93121',
    messagingSenderId: '546418221172',
    projectId: 'prepvrse',
    storageBucket: 'prepvrse.appspot.com',
    iosBundleId: 'com.example.prepvrse',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAZabuo1GJ3d6l7Ry6upIFaCbr6Sh6Rck4',
    appId: '1:546418221172:ios:ea8ca77b2e9a0fc0f93121',
    messagingSenderId: '546418221172',
    projectId: 'prepvrse',
    storageBucket: 'prepvrse.appspot.com',
    iosBundleId: 'com.example.prepvrse.RunnerTests',
  );
}
