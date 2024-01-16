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
    apiKey: 'AIzaSyAlzOHrE1CNW_8hfklLF2_2KeMNibUDkYM',
    appId: '1:957393903315:web:13734f8d9ae99f9868be26',
    messagingSenderId: '957393903315',
    projectId: 'flash-chat-64b76',
    authDomain: 'flash-chat-64b76.firebaseapp.com',
    storageBucket: 'flash-chat-64b76.appspot.com',
    measurementId: 'G-BPQ35NFZJV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCrUJ74h8j8w5AmRKpYb0y0GKN-C9oDBRg',
    appId: '1:957393903315:android:d1fb4daf0d09313468be26',
    messagingSenderId: '957393903315',
    projectId: 'flash-chat-64b76',
    storageBucket: 'flash-chat-64b76.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBRWVovfUooAcpgrX0Bf3DzmGIqIsqdls8',
    appId: '1:957393903315:ios:a0ac993925c3b66068be26',
    messagingSenderId: '957393903315',
    projectId: 'flash-chat-64b76',
    storageBucket: 'flash-chat-64b76.appspot.com',
    iosBundleId: 'com.example.flashChat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBRWVovfUooAcpgrX0Bf3DzmGIqIsqdls8',
    appId: '1:957393903315:ios:a5b68b5105557b0c68be26',
    messagingSenderId: '957393903315',
    projectId: 'flash-chat-64b76',
    storageBucket: 'flash-chat-64b76.appspot.com',
    iosBundleId: 'com.example.flashChat.RunnerTests',
  );
}
