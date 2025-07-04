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
/// ////old
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
        return windows;
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
    apiKey: 'AIzaSyBGqRLt3nhQt1s8J8e1o6UD22ask0Iyq78',
    appId: '1:528108078256:web:c98a4d6f0702a4ae71e775',
    messagingSenderId: '528108078256',
    projectId: 'ecommerce-774200031',
    authDomain: 'ecommerce-774200031.firebaseapp.com',
    storageBucket: 'ecommerce-774200031.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBesFFDSGkNK99L40PykcSJ6k2QtDvuPQ8',
    appId: '1:528108078256:android:de52638429dcbe3271e775',
    messagingSenderId: '528108078256',
    projectId: 'ecommerce-774200031',
    storageBucket: 'ecommerce-774200031.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCr9wR7zGyOy8P-vNcb89m8KR-99hD4bIk',
    appId: '1:528108078256:ios:481d4fc47f69ec7571e775',
    messagingSenderId: '528108078256',
    projectId: 'ecommerce-774200031',
    storageBucket: 'ecommerce-774200031.appspot.com',
    iosBundleId: 'com.example.ecommerce',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCr9wR7zGyOy8P-vNcb89m8KR-99hD4bIk',
    appId: '1:528108078256:ios:481d4fc47f69ec7571e775',
    messagingSenderId: '528108078256',
    projectId: 'ecommerce-774200031',
    storageBucket: 'ecommerce-774200031.appspot.com',
    iosBundleId: 'com.example.ecommerce',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBGqRLt3nhQt1s8J8e1o6UD22ask0Iyq78',
    appId: '1:528108078256:web:95c40e5edb33cc9771e775',
    messagingSenderId: '528108078256',
    projectId: 'ecommerce-774200031',
    authDomain: 'ecommerce-774200031.firebaseapp.com',
    storageBucket: 'ecommerce-774200031.appspot.com',
  );
}
