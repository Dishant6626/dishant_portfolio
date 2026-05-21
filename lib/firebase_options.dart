// ─────────────────────────────────────────────────────────────────────────────
// HOW TO GENERATE THIS FILE:
//
//  1. Install FlutterFire CLI:
//       dart pub global activate flutterfire_cli
//
//  2. Login to Firebase:
//       firebase login
//
//  3. Run in the project root:
//       flutterfire configure
//
//  That command generates this file automatically with your project values.
//  Replace the placeholder strings below with your actual Firebase config.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return web;
    }
  }

  // ── Replace all values below with your Firebase project config ──

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB4i0RC--N6SSWxoEFXJ8hyC8-yAzJH5GE',
    appId: '1:500160268833:web:4c21feda359effa43bf160',
    messagingSenderId: '500160268833',
    projectId: 'dishant-portfolio-bfd92',
    authDomain: 'dishant-portfolio-bfd92.firebaseapp.com',
    storageBucket: 'dishant-portfolio-bfd92.firebasestorage.app',
    measurementId: 'G-XY8WFVRW4E',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    iosBundleId: 'com.dishant.portfolio',
  );
}
