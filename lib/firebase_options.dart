// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'env/env.dart';
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

  static FirebaseOptions web = FirebaseOptions(
    apiKey: Env.firebaseWebKey,
    appId: '1:631599443704:web:40dbc4aeaea7d577ef950d',
    messagingSenderId: '631599443704',
    projectId: 'nows-app-86813',
    authDomain: 'nows-app-86813.firebaseapp.com',
    databaseURL: 'https://nows-app-86813-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'nows-app-86813.appspot.com',
    measurementId: 'G-V35YMH5LCN',
  );

  static FirebaseOptions android = FirebaseOptions(
    apiKey: Env.firebaseAndroidKey,
    appId: '1:631599443704:android:7391cefb4ba9b333ef950d',
    messagingSenderId: '631599443704',
    projectId: 'nows-app-86813',
    databaseURL: 'https://nows-app-86813-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'nows-app-86813.appspot.com',
  );

  static FirebaseOptions ios = FirebaseOptions(
    apiKey: Env.firebaseIosKey,
    appId: '1:631599443704:ios:2f310ab0b408d345ef950d',
    messagingSenderId: '631599443704',
    projectId: 'nows-app-86813',
    databaseURL: 'https://nows-app-86813-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'nows-app-86813.appspot.com',
    iosClientId: '631599443704-fmra8fhaqc9rsnbkg3e0cufo4bd9qt5t.apps.googleusercontent.com',
    iosBundleId: 'com.example.nowsApp',
  );

  static FirebaseOptions macos = FirebaseOptions(
    apiKey: Env.firebaseMacosKey,
    appId: '1:631599443704:ios:2f310ab0b408d345ef950d',
    messagingSenderId: '631599443704',
    projectId: 'nows-app-86813',
    databaseURL: 'https://nows-app-86813-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'nows-app-86813.appspot.com',
    iosClientId: '631599443704-fmra8fhaqc9rsnbkg3e0cufo4bd9qt5t.apps.googleusercontent.com',
    iosBundleId: 'com.example.nowsApp',
  );
}
