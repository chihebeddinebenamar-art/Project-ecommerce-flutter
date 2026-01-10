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
    apiKey: 'AIzaSyChKWdVQ_vUS87adR_O6cP-L_KXwdK8W70',
    appId: '1:709872677042:web:d4a406512455365cc259ab',
    messagingSenderId: '709872677042',
    projectId: 'ProjectCasaqueFlutter', 
    authDomain: 'ProjectCasaqueFlutter.firebaseapp.com',
    storageBucket: 'ProjectCasaqueFlutter.firebasestorage.app',
    measurementId: 'G-YBBW7QT5V2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBtEJhsqJfOBGiEsPE89_g3PxRxbDaCYKA',
    appId: '1:709872677042:android:2197297402a04eadc259ab',
    messagingSenderId: '709872677042',
    projectId: 'ProjectCasaqueFlutter', 
    storageBucket: 'ProjectCasaqueFlutter.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAOwqlaMTDm4CbFZEbYTEqJDV7BQ2Hp_7A',
    appId: '1:709872677042:ios:a10b89179a89e998c259ab',
    messagingSenderId: '709872677042',
    projectId: 'ProjectCasaqueFlutter',
    storageBucket: 'ProjectCasaqueFlutter.firebasestorage.app',
    iosBundleId: 'com.projectcasaqueflutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAOwqlaMTDm4CbFZEbYTEqJDV7BQ2Hp_7A',
    appId: '1:709872677042:ios:a10b89179a89e998c259ab',
    messagingSenderId: '709872677042',
    projectId: 'ProjectCasaqueFlutter', 
    storageBucket: 'ProjectCasaqueFlutter.firebasestorage.app',
    iosBundleId: 'com.projectcasaqueflutter',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyChKWdVQ_vUS87adR_O6cP-L_KXwdK8W70',
    appId: '1:709872677042:web:0cb36d872ebcb8fdc259ab',
    messagingSenderId: '709872677042',
    projectId: 'ProjectCasaqueFlutter', 
    authDomain: 'ProjectCasaqueFlutter.firebaseapp.com',
    storageBucket: 'ProjectCasaqueFlutter.firebasestorage.app',
    measurementId: 'G-JG3NRPD0KK',
  );

}