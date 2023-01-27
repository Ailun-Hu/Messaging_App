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
    apiKey: 'AIzaSyBlijgldFZi_osheSKpmxTzJ6hmp3l5B6M',
    appId: '1:386213238065:web:76fde7acf69cb5a4994c10',
    messagingSenderId: '386213238065',
    projectId: 'messagingapp-90f35',
    authDomain: 'messagingapp-90f35.firebaseapp.com',
    storageBucket: 'messagingapp-90f35.appspot.com',
    measurementId: 'G-B7C3JEDVCE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDypz7WOcyUcTu9Gq36gci0VdLuHRBnesg',
    appId: '1:386213238065:android:1c9c3966da169ae1994c10',
    messagingSenderId: '386213238065',
    projectId: 'messagingapp-90f35',
    storageBucket: 'messagingapp-90f35.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCrEXLCpv_He4SGDeC4neoAAyRYWJ_tPzU',
    appId: '1:386213238065:ios:87aaf351470ef415994c10',
    messagingSenderId: '386213238065',
    projectId: 'messagingapp-90f35',
    storageBucket: 'messagingapp-90f35.appspot.com',
    iosClientId: '386213238065-ev21db3nsgkm4mk9np67df3e1m56u66c.apps.googleusercontent.com',
    iosBundleId: 'com.example.messagingApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCrEXLCpv_He4SGDeC4neoAAyRYWJ_tPzU',
    appId: '1:386213238065:ios:87aaf351470ef415994c10',
    messagingSenderId: '386213238065',
    projectId: 'messagingapp-90f35',
    storageBucket: 'messagingapp-90f35.appspot.com',
    iosClientId: '386213238065-ev21db3nsgkm4mk9np67df3e1m56u66c.apps.googleusercontent.com',
    iosBundleId: 'com.example.messagingApp',
  );
}