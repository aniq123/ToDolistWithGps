// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;

// class AlarmScreen extends StatefulWidget {
//   const AlarmScreen({super.key});

//   @override
//   _AlarmScreenState createState() => _AlarmScreenState();
// }

// class _AlarmScreenState extends State<AlarmScreen> {
//   FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
//   AudioPlayer? audioPlayer;
//   DateTime? alarmTime;

//   @override
//   void initState() {
//     super.initState();
//     initializeNotifications();
//     initializeAudioPlayer();
//     // Set the desired alarm time (in this example, set to 30 seconds from now)
//     alarmTime = DateTime.now().add(const Duration(seconds: 30));
//     scheduleAlarm();
//   }

//   void initializeNotifications() {
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');

//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//     );
//     flutterLocalNotificationsPlugin!.initialize(initializationSettings);
//   }

//   void initializeAudioPlayer() {
//     audioPlayer = AudioPlayer();
//     audioPlayer!.setSourceAsset(
//         'assets/audio/SoundHelix-Song-1.mp3'); // Adjust the file path accordingly
//     audioPlayer!.setReleaseMode(ReleaseMode.stop);
//   }

//   void playAlarm() async {
//     //await audioPlayer!.play(Uri.file('assets/audio/SoundHelix-Song-1.mp3').toString(), isLocal: true);
//   }
//   Future<void> scheduleAlarm() async {
//     await flutterLocalNotificationsPlugin!.zonedSchedule(
//       0,
//       'Alarm',
//       'Time to wake up!',
//       tz.TZDateTime.now(tz.getLocation('UTC+05:00'))
//           .add(const Duration(seconds: 10)),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'alarm_channel_id',
//           'Alarm notifications',
//           //'Channel for playing alarm sounds',
//           importance: Importance.max,
//           priority: Priority.high,
//           playSound: true,
//           sound: RawResourceAndroidNotificationSound('alarm_sound'),
//         ),
//       ),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Alarm Screen'),
//       ),
//       body: Center(
//         child: Text('Alarm will play at: ${alarmTime!.toLocal()}'),
//       ),
//     );
//   }
// }
