import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'screens/login.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBQaJW2JSr5gi6cWeJPhg7C9oOidhXbFjg",
            appId: "1:550952267987:web:51396ed4922b95298ce426",
            messagingSenderId: "550952267987",
            projectId: "loginauth-448fc",
            storageBucket: "loginauth-448fc.appspot.com"));
  } else {
    await Firebase.initializeApp();
  }
  var initializationSettingsAndroid =
      const AndroidInitializationSettings("codex_logo");
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payLoad) {});
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payLoad) {
    if (payLoad != null) {
      debugPrint('notification payload: ' + payLoad);
    }
  });
  runApp(const MaterialApp(
    home: Login(),
  ));
}
