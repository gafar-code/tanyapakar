import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanyapakar/main.dart';

class FcmService {
  static late FlutterLocalNotificationsPlugin _localNotif;

  static Future<void> init() async {
    late AndroidInitializationSettings _androidSettings;
    late InitializationSettings _initSettings;

    _localNotif = FlutterLocalNotificationsPlugin();
    _androidSettings = const AndroidInitializationSettings('ic_launcher');
    _initSettings = InitializationSettings(android: _androidSettings);

    _localNotif.initialize(_initSettings, onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse);

    await _localNotif.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();

    FirebaseMessaging.onMessage.listen(_handleMsg);
    FirebaseMessaging.onBackgroundMessage(_handleMsg);
  }

  static Future<void> _handleMsg(RemoteMessage message) async {
    late AndroidNotificationDetails androidChannel;
    late NotificationDetails notifDetail;
    String? title, msg;

    androidChannel = const AndroidNotificationDetails(
      'CHAT',
      "CHAT",
      channelDescription: 'CHAT',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    notifDetail = NotificationDetails(android: androidChannel);

    if (message.notification != null) {
      title = message.notification?.title.toString();
      msg = message.notification?.body.toString();
      router = message.data["router"].toString();
      idKepada = message.data["kepeda"].toString();
      idDari = message.data["dari"].toString();
      idKlasifikasiNotif = message.data["idKlasifikasi"].toString();

      if (idKepada == idPenggunaLogged) {
        /*
        if (mulaiChat == 0) {
          await _flutterLocalNotificationsPlugin.show(
              0, title, msg, platformChannelSpecifics,
              payload: json.encode(message.data));
        }
        */
        await _localNotif.show(
          0,
          title,
          msg,
          notifDetail,
          payload: json.encode(message.data),
        );
      }
    }
  }

  static Future<void> _onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    var sesLogin = await SharedPreferences.getInstance();
    sesLogin.setInt("mulaiChat", 1);

    navigatorKey.currentState!.pushNamed(router!);
  }
}
