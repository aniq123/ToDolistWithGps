import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_22/Global.dart';
import 'package:flutter_application_22/Model/taskmodel.dart';
import 'package:flutter_application_22/Screens/loginScreen.dart';
import 'package:flutter_application_22/apiHandler/api.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
  initLoading();
  lookForNotification();
}

initLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

// final player = AudioPlayer();
// void playSound() async {
//   // final duration = await player.setUrl(// Load a URL
//   //     'assets:assets/SoundHelix.mp3');
//   // await player.play();
// }

void lookForNotification() {
  Timer.periodic(const Duration(seconds: 45), (timer) async {
    try {
      if (loggedInUser != null) {
        http.Response response =
            await APIHandler().checkNotification(loggedInUser!.id ?? 0);
        if (response.statusCode == 200) {
          List tasks = jsonDecode(response.body);
          int numberOfTasks = tasks.length;

          if (numberOfTasks > 0) {
            for (int i = 0; i < numberOfTasks; i++) {
              Map<String, dynamic> task = tasks[i];
              taskTitle = task["TaskTitle"] ?? "No Title";
              // You can now use `numberOfTasks` and `taskTitle` as needed.
              print('Task $i - Title: $taskTitle');
            }
            // playSound();
            EasyLoading.show(
                status:
                    'You have $numberOfTasks tasks /n Task Title: $taskTitle',
                dismissOnTap: true);
          }
          print('Received notification data ========================');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  });
}

// void lookForNotification() {
//   Timer.periodic(Duration(seconds: 4), (timer) async {
// print('Before casting: ${loggedInUser?.runtimeType}');
//     int? userId = loggedInUser?.id;
//     print('After casting: ${userId?.runtimeType}');
// print(userId);
// http.Response response = await APIHandler().checkNotification(userId!);

//     if (response.statusCode == 200) {
//       List<Taskmodel> tasks = taskmodelListFromJson(response.body);

//       // TODO: Display the tasks or perform any other actions here
//       for (var task in tasks) {
//         print("Task Title: ${task.TaskTitle}");
//         print("Task Due Date: ${task.Firstdate}");
//         print("Task Due Time: ${task.TaskDueTime}");
//         // Add your logic to display or process each task
//       }
//     }
//   });
// }

List<Taskmodel> taskmodelListFromJson(String str) {
  List<dynamic> jsonData = json.decode(str);
  return List<Taskmodel>.from(jsonData.map((x) => Taskmodel.fromJson(x)));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //lookForNotification();
    return MaterialApp(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const loginScreen(),
      // home: const AlarmScreen(),
    );
  }
}
