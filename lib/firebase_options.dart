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
    apiKey: 'AIzaSyDY9KK0wrE0se4yexcCXjqedsUcZayNU2M',
    appId: '1:1071881508823:web:8b88d77e2f4866d5da5d92',
    messagingSenderId: '1071881508823',
    projectId: 'health-and-doctor-appoin-6dbf9',
    authDomain: 'health-and-doctor-appoin-6dbf9.firebaseapp.com',
    storageBucket: 'health-and-doctor-appoin-6dbf9.appspot.com',
    measurementId: 'G-85CJW3J2HN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAWg-O-spVGw4mTYRm0ngIe9fAjDNI_tfA',
    appId: '1:1071881508823:android:a54ad5e37bbbb2eeda5d92',
    messagingSenderId: '1071881508823',
    projectId: 'health-and-doctor-appoin-6dbf9',
    storageBucket: 'health-and-doctor-appoin-6dbf9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC8A40rLiHV4R7PF8e9jJjnjmD_Hy5eCFQ',
    appId: '1:1071881508823:ios:18a6e8ea6e61177ada5d92',
    messagingSenderId: '1071881508823',
    projectId: 'health-and-doctor-appoin-6dbf9',
    storageBucket: 'health-and-doctor-appoin-6dbf9.appspot.com',
    iosClientId: '1071881508823-jj4u6c489t9u4j460otmkjuhbktahnk6.apps.googleusercontent.com',
    iosBundleId: 'com.example.healthAndDoctorAppointment',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC8A40rLiHV4R7PF8e9jJjnjmD_Hy5eCFQ',
    appId: '1:1071881508823:ios:18a6e8ea6e61177ada5d92',
    messagingSenderId: '1071881508823',
    projectId: 'health-and-doctor-appoin-6dbf9',
    storageBucket: 'health-and-doctor-appoin-6dbf9.appspot.com',
    iosClientId: '1071881508823-jj4u6c489t9u4j460otmkjuhbktahnk6.apps.googleusercontent.com',
    iosBundleId: 'com.example.healthAndDoctorAppointment',
  );
}
