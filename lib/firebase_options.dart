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
    apiKey: 'AIzaSyBLyYKoqgW1AGR3JRUQrfC4IVq2paUwARc',
    appId: '1:362912793108:web:8ed18ca0b38d3d9235dd01',
    messagingSenderId: '362912793108',
    projectId: 'year-planner-hst',
    authDomain: 'year-planner-hst.firebaseapp.com',
    databaseURL: 'https://year-planner-hst-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'year-planner-hst.appspot.com',
    measurementId: 'G-MXFS9B63E7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD76UTmmdquYlUvmaud0sNSIWQm3SO9NYg',
    appId: '1:362912793108:android:e552ea3f623668e035dd01',
    messagingSenderId: '362912793108',
    projectId: 'year-planner-hst',
    databaseURL: 'https://year-planner-hst-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'year-planner-hst.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAXFhUDW0u1-mg4jRrbIA53_klAja-yEs8',
    appId: '1:362912793108:ios:39546a2df0ab233c35dd01',
    messagingSenderId: '362912793108',
    projectId: 'year-planner-hst',
    databaseURL: 'https://year-planner-hst-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'year-planner-hst.appspot.com',
    iosClientId: '362912793108-062t1va8h22vqci83erq4hd7sdos7mop.apps.googleusercontent.com',
    iosBundleId: 'com.hesate.year-planner',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAXFhUDW0u1-mg4jRrbIA53_klAja-yEs8',
    appId: '1:362912793108:ios:8b606c1445790dc635dd01',
    messagingSenderId: '362912793108',
    projectId: 'year-planner-hst',
    databaseURL: 'https://year-planner-hst-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'year-planner-hst.appspot.com',
    iosClientId: '362912793108-dn6lpgqd1h5bqr9q6a5amomo29tderfe.apps.googleusercontent.com',
    iosBundleId: 'com.example.yearPlanner',
  );
}