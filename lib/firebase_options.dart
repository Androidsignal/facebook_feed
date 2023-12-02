// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBE5ReHmp1mOn8M1__GRNVXKLYp5RYi5eE',
    appId: '1:220710204627:web:05b207cb1a341820375026',
    messagingSenderId: '220710204627',
    projectId: 'newsfeed-105f5',
    authDomain: 'newsfeed-105f5.firebaseapp.com',
    storageBucket: 'newsfeed-105f5.appspot.com',
    measurementId: 'G-0BF2B4ZXYN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCWXvQjE1ZJIuakbQq9I5vYYYnDtFgHwrs',
    appId: '1:220710204627:android:2e596dba4fc9fe31375026',
    messagingSenderId: '220710204627',
    projectId: 'newsfeed-105f5',
    storageBucket: 'newsfeed-105f5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCKjyFQKSnIPlJVHwtuwcMz5QV-TPGaxOg',
    appId: '1:220710204627:ios:6fc9cb313ce8f5b5375026',
    messagingSenderId: '220710204627',
    projectId: 'newsfeed-105f5',
    storageBucket: 'newsfeed-105f5.appspot.com',
    iosBundleId: 'com.example.newsFeedFlutter',
  );
}