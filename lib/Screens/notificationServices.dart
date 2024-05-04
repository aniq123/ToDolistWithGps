import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsServices {
  




  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initLocalNotification() async {
    var androidInitializationSettings =
    const AndroidInitializationSettings('@mipmap/logo');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initlization = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initlization,
        onDidReceiveNotificationResponse: (payload) {});
  }

  Future<void> showNotifications({required String title , required String dis}) async {
    print("======= ===== ==== Show Notification");
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        'High Important Notification',
        importance: Importance.max);

    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(channel.id, channel.name,
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    DarwinNotificationDetails darwinNotificationDetails =
    const DarwinNotificationDetails(
        presentAlert: true, presentSound: true, presentBadge: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        Random.secure().nextInt(10000),
      title,
        dis,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'my_foreground',
            'MY FOREGROUND SERVICE',
            // icon: 'ic_bg_service_small',
            ongoing: true,
          ),
        ),
      );
    });
  }



}