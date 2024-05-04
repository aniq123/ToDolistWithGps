// import 'package:flutter_application_22/Global.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:intl/intl.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;


// class Alarm2{
//   String? dayName,time;
//   Alarm2();
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   Future<void> cancelAlarm() async { await flutterLocalNotificationsPlugin.cancel(0);

  
//   print('Alarm canceled');
// }


//     Future<void> scheduleAlarm() async {
//       fnplugin = flutterLocalNotificationsPlugin;
//       var scheduledTime;

//       var now2 = DateTime.now();
//       var formatter = DateFormat('EEEE');
//       dayName = formatter.format(now2);
//       print(dayName);
//     tz.initializeTimeZones();
//     print(tz.local);
//     var now = tz.TZDateTime.now(tz.local);
//     print('current time+$now');
   
//     if(is_snooze==false)
//     {
//       if (now.hour < 3) {
//     scheduledTime = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       3, // Hour (8:00 AM)
//       0, // Minute
//       0, // Second
//     );
//     time = "morn";
//     }
//     else if (now.hour < 8) {
//     scheduledTime = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       8, // Hour (1:00 PM)
//       0,  // Minute
//       0,  // Second
//     );
//     time = "noon";
//   }
//   else if (now.hour < 13) {
//     scheduledTime = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       13, // Hour (6:00 PM)
//       0,  // Minute
//       0,  // Second
//     );
//     time = "even";
//   }
//   else if (now.hour < 17) {
//     scheduledTime = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       17, // Hour (10:00 PM)
//       0,  // Minute
//       0,  // Second
//     );
//     time = "night";
//   }
//   else {
//     // If the current time is past 10 pm, schedule the alarm for the next day
//     scheduledTime = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day + 1,
//       3, // Hour (8:00 AM)
//       0, // Minute
//       0, // Second
//     );
//     time = "morn";
//   }

//     }
//     else if(is_snooze==true)
//     {
//       int hour = now.hour;
//       print('now.hour is $hour');
//       if(now.hour<8 && now.hour>=3)
//         time= "morn";
//       else if(now.hour<13 && now.hour>=8)
//         time= "noon";
//       else if(now.hour<17 && now.hour>=13)
//         time = "even";  
//       else if(now.hour<3 || now.hour>=17)
//         time = "night";        
//       print('this is else case $time');
//       scheduledTime = tz.TZDateTime.from(DateTime.now().add(Duration(seconds: 15)), tz.local);
//     }
    
//     print('scheduled time+$scheduledTime');
    
//     var initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     var initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//     final Future<dynamic> Function(String?)? selectNotificationCallback =
//         (String? payload) async {
     
      
      
//     };

//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'alarm_channel',
//       'Alarm Channel',
//       importance: Importance.high,
//       priority: Priority.high,
//       playSound: true,
//       enableVibration: true,
//       sound: RawResourceAndroidNotificationSound('alarm_sound'),
//       showWhen: false,
//     );

//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await flutterLocalNotificationsPlugin.initialize(
//       InitializationSettings(
//         android: AndroidInitializationSettings('app_icon'),
//       ),
//       onSelectNotification: selectNotificationCallback,
//     );

//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'Alarm',
//       'This is the alarm notification',
//       scheduledTime,
//       platformChannelSpecifics,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       androidAllowWhileIdle: true,
//       matchDateTimeComponents: DateTimeComponents.time,
//       payload: 'Alarm payload',
//     );
 
  

//    Duration timeDifference = scheduledTime.difference(now);
// if (timeDifference.isNegative) {
//   timeDifference = Duration.zero;
// }

// /*
// Future.delayed(timeDifference, () {
//   navigatorKey.currentState!.pushReplacement(
//     MaterialPageRoute(builder: (context) {
//       return AlarmScreen2.Cons1(patient_id, w1, dayName!, time!, navigatorKey);
//     }),
//   );
// });
//     Future.delayed(Duration(seconds: 5), () {
//     navigatorKey.currentState!.pop(); // Close the screen
//   });  */
    
//     print('Alarm scheduled for $scheduledTime');
//   }
// }