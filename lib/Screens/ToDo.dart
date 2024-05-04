import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_22/Global.dart';
import 'package:flutter_application_22/Model/notification.dart';
import 'package:flutter_application_22/Model/sharedtaskmodel.dart';
import 'package:flutter_application_22/Model/taskmodel.dart';
import 'package:flutter_application_22/Screens/AssignToOtherGeoFance.dart';
import 'package:flutter_application_22/Screens/CompleteTasks.dart';
import 'package:flutter_application_22/Screens/Contacts.dart';
import 'package:flutter_application_22/Screens/GeoFanceing.dart';
import 'package:flutter_application_22/Screens/GeoFancingPending.dart';
import 'package:flutter_application_22/Screens/Registriaction.dart';
import 'package:flutter_application_22/Screens/Sharing.dart';
import 'package:flutter_application_22/Screens/TaskSharing.dart';
import 'package:flutter_application_22/Screens/Tasks.dart';
import 'package:flutter_application_22/Screens/pending.dart';
import 'package:flutter_application_22/Screens/uncompleteTasks.dart';
import 'package:flutter_application_22/apiHandler/api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ToDo extends StatefulWidget {
  const ToDo({Key? key}) : super(key: key);

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  late Future<List<sharedTaskmodel>> _futureTasks;
  int numberOfPendingTasks = 0;
  void initState() {
    super.initState();
    _futureTasks = fetchData();
    updateNumberOfPendingTasks();
  }

  Future<void> updateNumberOfPendingTasks() async {
    final tasks = await fetchData();
    setState(() {
      numberOfPendingTasks = tasks.length;
    });
  }

  Future<void> createOrUpdateSharedTaskStatus(int taskId) async {
    final dio = Dio();

    try {
      final response = await dio.post(
        '$ip/CreateOrUpdateSharedTaskStatus?taskid=$taskId',
      );

      if (response.statusCode == 200) {
        print('ShareTask status updated successfully');
        updateNumberOfPendingTasks();
        //showPendingTasksPopup();
        setState(() {});
      } else if (response.statusCode == 201) {
        print('New ShareTask created successfully');
      } else {
        print(
            'Failed to update ShareTask status. Status code: ${response.statusCode}');
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        print('Endpoint not found. Check the URL and server implementation.');
      } else {
        print('Error updating ShareTask status: $e');
      }
    } catch (e) {
      print('Unexpected error: $e');
    }
  }

  Future<List<sharedTaskmodel>> fetchData() async {
    final dio = Dio();
    try {
      final response =
          await dio.get('$ip/GetPendingSharedTasks?userid=${loggedInUser!.id}');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        var task = data.map((item) => sharedTaskmodel.fromMap(item)).toList();
        return task;
      } else {
        print('Failed to load tasks. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  void showPendingTasksPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pending Tasks'),
          content: Text('You have $numberOfPendingTasks pending tasks.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _logOut(BuildContext context) {
    // Perform any necessary log out operations here

    // Navigate to the RegisterScreen and remove all existing routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Registration()),
      (route) => false,
    );
  }

  int myIndex = 0;
  Color homeColor = Colors.blue;

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Container(
                    child: ListTile(
                      leading: const Icon(Icons.assignment),
                      title: const Text('Task Sharing'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TaskSharing(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Sharing'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const sharing()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.assignment_turned_in),
                  title: const Text('Task'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Tasks()),
                    );
                  },
                ),
                // ListTile(
                //   leading: const Icon(Icons.assignment_turned_in),
                //   title: const Text('Sound'),
                //   onTap: () {
                //     //playSound();
                //     Navigator.pop(context);
                //   },
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<String> dropdownOption = ['Today', 'Yerterday', 'LastWeek'];

  bool isEditing = false;
  List<Taskmodel> tasks = [];
  void showNotificationsDialog([List<NotificationModel>? list]) async {
    // Fetch notifications and build the content
    http.Response response =
        await APIHandler().checkNotification(loggedInUser as int);
    print('Response Status Code: ${response.statusCode}');

    // Parse the response body to get the list of notifications
    List<NotificationModel> notifications = parseNotifications(response.body);

    Widget content = SingleChildScrollView(
      child: Column(
        children: [
          for (var notification in notifications)
            ListTile(
              title: Text(notification.TaskTitle),
              subtitle: Text("Due Date: ${notification.TaskDueTime}"),
              // Add more details as needed
            ),
        ],
      ),
    );

    // Show the dialog
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notifications'),
          content: content,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  List<NotificationModel> parseNotifications(String responseBody) {
    // Initialize an empty list to store notifications
    List<NotificationModel> notifications = [];

    try {
      final List<dynamic> jsonList = json.decode(responseBody);

      // Iterate through the list and create NotificationModel objects
      for (var jsonItem in jsonList) {
        NotificationModel notification = NotificationModel(
          TaskTitle: jsonItem['taskTitle'],
          Firstdate: jsonItem['firstDate'],
          TaskDueTime: jsonItem['due time'],
          // Add more properties as needed
        );
        notifications.add(notification);
      }
    } catch (e) {
      print('Error parsing notifications: $e');
    }

    return notifications;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Center(child: Text("To-Do")),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () async {
              try {
                if (loggedInUser != null) {
                  int? userId = loggedInUser?.id;

                  if (userId != null) {
                    http.Response response =
                        await APIHandler().checkNotification(userId);
                    print('Response Status Code: ${response.statusCode}');

                    if (response.statusCode == 200) {
                      List<NotificationModel> notifications =
                          parseNotifications(response.body);

                      if (notifications.isNotEmpty) {
                        showNotificationsDialog(notifications);
                      } else {
                        print('No notifications available.');
                      }
                    } else {
                      print(
                          'Error: Unable to fetch notifications. Status Code: ${response.statusCode}');
                    }
                  } else {
                    print('Error: User ID is null.');
                  }
                } else {
                  print('Error: Logged-in user is null.');
                }
              } catch (e) {
                print('Error: $e');
              }
            },
          ),
        ],
      ),
      body: const DefaultTabController(
        length: 5,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'All Tasks'),
                Tab(text: 'Today'),
                Tab(text: 'Assigned to Others'),
                Tab(text: 'Assigned to Me'),
                Tab(
                  text: ('Own Task'),
                )
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  AllTaskpage(),
                  TodayTask(),
                  AssignedToOthersPage(),
                  AssignedToMePage(),
                  owntaskDetailPage(),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Center(
                child: Text(
                  loggedInUser!.name ?? 'No Name',
                ),
              ),
            ),
            ListTile(
              title: const Text('To Do'),
              leading: const Icon(Icons.task),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Shared with me"),
              leading: const Icon(Icons.people),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            const ListTile(
              title: Text("-------Tasks Information------"),
            ),
            ListTile(
              leading: Container(
                color: homeColor,
                child: const Icon(Icons.done),
              ),
              title: const Text("Completed Task"),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CompleteTasks()));
              },
            ),
            ListTile(
              leading: Container(
                color: homeColor,
                child: const Icon(Icons.cancel),
              ),
              title: const Text("UNCompleted Task"),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => uncompleteTasks(
                            task: Taskmodel(
                                TaskTitle: "",
                                TaskId: 0,
                                TaskDueTime: null,
                                TaskBeforeTime: '',
                                TaskRepeat: '',
                                complete: false))));
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text("Pending(${numberOfPendingTasks.toString()})"),
              // title: Text("Pending"),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Pending()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title:
                  Text("ShareingPending(${numberOfPendingTasks.toString()})"),
              // title: Text("Pending"),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GeoFancingPending()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(
                  "ShareOutPendingTask(${numberOfPendingTasks.toString()})"),
              // title: Text("Pending"),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AssignToOtherGeoFance()));
              },
            ),
            const Divider(),
            const ListTile(
              title: Text("--------------  Other  -------------"),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Setting"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Log Out"),
              onTap: () {
                Navigator.pop(context); // Close the drawer

                // Perform log out operations and navigate to RegisterScreen
                _logOut(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showOptions(context);
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.purple,
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ToDo()),
            );
          }
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Contacts()),
            );
          }
          if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => GeoFencing()),
            );
          }
        },
        currentIndex: myIndex,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              color: homeColor,
              child: const Icon(Icons.home),
            ),
            label: 'ToDo',
          ),
          BottomNavigationBarItem(
            icon: Container(
              child: const Icon(Icons.people),
            ),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Container(
              child: const Icon(Icons.location_on),
            ),
            label: 'GeoFancing',
          ),
        ],
        selectedItemColor: Colors.white,
      ),
    );
  }
}

class AllTaskpage extends StatefulWidget {
  const AllTaskpage({Key? key}) : super(key: key);

  @override
  State<AllTaskpage> createState() => _AllTaskpageState();
}

class _AllTaskpageState extends State<AllTaskpage> {
  late Future<List<Taskmodel>> _futureTasks;

  @override
  void initState() {
    super.initState();
    _futureTasks = fetchData();
  }

  Future<void> UpdateSharedTaskStatus(int taskId) async {
    final dio = Dio();

    try {
      final response = await dio.post(
        '$ip/UpdateSharedTaskStatus?taskid=$taskId',
      );

      if (response.statusCode == 200) {
        print('ShareTask status updated successfully');
        setState(() {});
      }
    } catch (e) {
      print('Unexpected error: $e');
    }
  }

  Future<List<Taskmodel>> fetchData() async {
    final dio = Dio();
    try {
      final response = await dio.get(
        '$ip/AllTasks?userid=${loggedInUser!.id}',
      );
      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        var task = data.map((item) => Taskmodel.fromMap(item)).toList();
        // Sort tasks based on TaskDueDate
        tasks.sort((a, b) {
          String aDateStr = DateFormat('yyyy-MM-dd').format(a.Firstdate!);
          String bDateStr = DateFormat('yyyy-MM-dd').format(b.Firstdate!);
          DateTime aDate = DateFormat('yyyy-MM-dd').parse(aDateStr);
          DateTime bDate = DateFormat('yyyy-MM-dd').parse(bDateStr);
          return aDate.compareTo(bDate);
        });
        setState(() {});
        return task;
      } else {
        print('Failed to load tasks. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  String? convertTo12HourFormat(String timeStr) {
    List<String> timeParts = timeStr.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    // Convert to 12-hour format with AM/PM
    String period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12 == 0 ? 12 : hour % 12;

    // Formatted time string
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text(
            "All Tasks",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          //Spacer(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: FutureBuilder<List<Taskmodel>>(
              future: _futureTasks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No tasks available.'));
                } else {
                  List<Taskmodel> tasks = snapshot.data!;
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      String? GETTaskDueDate =
                          tasks[index].TaskDueDate.toString();
                      List<String> dateTimeParts = GETTaskDueDate.split(' ');
                      String? dateStr =
                          dateTimeParts.isNotEmpty ? dateTimeParts[0] : "";

                      String? GETFirstDate = tasks[index].Firstdate.toString();
                      List<String> GETFirstDatePARTS = GETFirstDate.split(' ');
                      String? firstdatedate = GETFirstDatePARTS.isNotEmpty
                          ? GETFirstDatePARTS[0]
                          : null; // Make it nullable

                      String? GETLastDate = tasks[index].Lastdate.toString();
                      List<String> GETLastDatePARTS = GETLastDate.split(' ');
                      String? lastdatedate = GETLastDatePARTS.isNotEmpty
                          ? GETLastDatePARTS[0]
                          : null; // Make it nullable

                      String? GETDueTime = tasks[index].TaskDueTime == null
                          ? null
                          : "${tasks[index].TaskDueTime!.hour}:${tasks[index].TaskDueTime!.minute}";

                      String? GETFirstTime = tasks[index].FirstTime == null
                          ? null
                          : "${tasks[index].FirstTime!.hour}:${tasks[index].FirstTime!.minute}";

                      String? GETLastTime = tasks[index].LastTime == null
                          ? null
                          : "${tasks[index].FirstTime!.hour}:${tasks[index].FirstTime!.minute}";

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: tasks[index].TasksStatus == 0
                                ? Colors.white
                                : Colors.green[300],
                            border: Border.all(
                              width: 1.0,
                              color: Colors.blueAccent,
                              //taskstatu[index].taskstatus=1
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            title: Text("Title:${tasks[index].TaskTitle}"),
                            subtitle: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Due Time: ${GETDueTime != null ? convertTo12HourFormat(GETDueTime) : '---'}",
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "First Date: ${firstdatedate ?? '---'} ",
                                          ),
                                          const SizedBox(
                                            width: 100,
                                          ),
                                          Text(
                                            "Last Date: ${lastdatedate ?? '---'}",
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "FIRST Time: ${GETFirstTime != null ? convertTo12HourFormat(GETFirstTime) : '---'}",
                                      ),
                                      Text(
                                        "LAST Time: ${GETLastTime != null ? convertTo12HourFormat(GETLastTime) : '---'}",
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          if (tasks[index].TaskLatitude !=
                                                  null &&
                                              tasks[index].TaskLongitude !=
                                                  null) {
                                            // Location exists, navigate to MapDemo
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => MapDemo(
                                                  polygonData: [],
                                                  taskdate:
                                                      tasks[index].Firstdate,
                                                  tasktime:
                                                      tasks[index].TaskDueTime,
                                                  targetLocation: LatLng(
                                                    tasks[index].TaskLatitude!,
                                                    tasks[index].TaskLongitude!,
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            // Location doesn't exist, handle this case or do nothing
                                            print('Location doesn\'t exist');
                                          }
                                        },
                                        child: Text(
                                          tasks[index].TaskLatitude != null &&
                                                  tasks[index].TaskLongitude !=
                                                      null
                                              ? "Editing Location"
                                              : tasks[index]
                                                      .isLocationBeingEdited()
                                                  ? "Editing Location"
                                                  : "Location not added",
                                        ),
                                      ),

                                      // Add more properties as needed
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            // Update task status to 0
                                            setState(() {
                                              tasks[index].complete = false;
                                            });
                                          },
                                          child: Container(
                                            width: 100.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              border: Border.all(
                                                width: 5.0,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Uncompleted Tasks',
                                                style: TextStyle(
                                                  fontSize: 9.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            // Update task status to 1
                                            setState(() {
                                              print(tasks[index].TasksStatus);
                                              UpdateSharedTaskStatus(
                                                  tasks[index].TaskId);
                                              fetchData();
                                              print(tasks[index].TasksStatus);
                                            });
                                          },
                                          child: Container(
                                            width: 110.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              border: Border.all(
                                                width: 5.0,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                (tasks[index].TasksStatus == 0)
                                                    ? 'own Task'
                                                    : 'Shared Task with me',
                                                style: const TextStyle(
                                                  fontSize: 9.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Add more ListTile customization as needed
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TodayTask extends StatefulWidget {
  const TodayTask({super.key});

  @override
  State<TodayTask> createState() => _TodayTaskState();
}

class _TodayTaskState extends State<TodayTask> {
  late Future<List<Taskmodel>> todayTasks;
  Future<List<Taskmodel>> getTodayTasks(int userId, String dateString) async {
    final dio = Dio();
    try {
      // Format the DateTime to a string in a format expected by the server
      String formattedDateString = dateString;

      final response = await dio.get(
        '$ip/GetTodayTasks?userid=$userId&dateString=$formattedDateString',
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the tasks from the JSON
        // List<dynamic> data = json.decode(response.body);
        // List<Task> todayTasks = data.map((task) => Task.fromJson(task)).toList();
        final data = response.data as List<dynamic>;
        print('Today Tasks: $data');
        var todayTasks = data.map((item) => Taskmodel.fromMap(item)).toList();
        return todayTasks;
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load today tasks');
      }
    } catch (e) {
      // Handle any errors that occurred during the HTTP request
      print('Error: $e');
      throw Exception('Failed to load today tasks');
    }
  }

  late Future<List<Taskmodel>> _futureTasks;
  @override
  void initState() {
    super.initState();
    // _futureTasks = fetchData();
    // Replace the user ID and date with actual values
    DateTime today = DateTime.now();
    int? id = loggedInUser!.id;
    print(id);

    String formattedDate = DateFormat('yyyy-MM-dd').format(today);

    todayTasks = getTodayTasks(id!, formattedDate);
  }

  Future<void> UpdateSharedTaskStatus(int taskId) async {
    final dio = Dio();

    try {
      final response = await dio.post(
        '$ip/UpdateSharedTaskStatus?taskid=$taskId',
      );

      if (response.statusCode == 200) {
        print('ShareTask status updated successfully');
        setState(() {});
      } else if (response.statusCode == 201) {
        print('New ShareTask created successfully');
        setState(() {});
      } else {
        print(
            'Failed to update ShareTask status. Status code: ${response.statusCode}');
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        print('Endpoint not found. Check the URL and server implementation.');
      } else {
        print('Error updating ShareTask status: $e');
      }
    } catch (e) {
      print('Unexpected error: $e');
    }
  }

  Future<void> deleteTask(int taskId) async {
    print(taskId);
    final dio = Dio();
    final String apiUrl = '$ip/DeleteTask';

    try {
      final response = await dio.post('$apiUrl?taskId=$taskId');

      if (response.statusCode == 200) {
        // Task deleted successfully
        print('Task deleted successfully!');

        setState(() {});
        // return "Task deleted successfully!";
      } else if (response.statusCode == 404) {
        // Task not found
        print("Task with ID $taskId not found.");
        // return "Task with ID $taskId not found.";
      } else {
        // Other error
        print("Failed to delete task. Error: ${response.data}");
        // return "Failed to delete task. Error: ${response.data}";
      }
    } catch (e) {
      // Handle network or other errors
      print("Failed to delete task. Error: $e");
      // return "Failed to delete task. Error: $e";
    }
  }
  // Future<void> fetchData() async {
  //   final dio = Dio();
  //   try {
  //     final response = await dio.get(
  //       '$ip/AllTasks?userid=${loggedInUser!.id}',
  //     );
  //     if (response.statusCode == 200) {
  //       final data = response.data as List<dynamic>;
  //       print(data);
  //       // var task = data.map((item) => Taskmodel.fromMap(item)).toList();
  //       // return task;
  //     } else {
  //       print('Failed to load tasks. Status code: ${response.statusCode}');
  //       // return [];
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     // return [];
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    String? convertTo12HourFormat(String timeStr) {
      List<String> timeParts = timeStr.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      // Convert to 12-hour format with AM/PM
      String period = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12 == 0 ? 12 : hour % 12;

      // Formatted time string
      return '$hour:$minute $period';
    }

    return Scaffold(
        body: Column(children: [
      const Text(
        "Today Tasks",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.65,
        child: FutureBuilder<List<Taskmodel>>(
          future: todayTasks,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No tasks available.'));
            } else {
              List<Taskmodel> tasks = snapshot.data!;
              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  String? GETTaskDueDate = tasks[index].TaskDueDate.toString();
                  List<String> dateTimeParts = GETTaskDueDate.split(' ');
                  String? dateStr =
                      dateTimeParts.isNotEmpty ? dateTimeParts[0] : "";

                  String? GETFirstDate = tasks[index].Firstdate.toString();
                  List<String> GETFirstDatePARTS = GETFirstDate.split(' ');
                  String? firstdatedate = GETFirstDatePARTS.isNotEmpty
                      ? GETFirstDatePARTS[0]
                      : null; // Make it nullable

                  String? GETLastDate = tasks[index].Lastdate.toString();
                  List<String> GETLastDatePARTS = GETLastDate.split(' ');
                  String? lastdatedate = GETLastDatePARTS.isNotEmpty
                      ? GETLastDatePARTS[0]
                      : null; // Make it nullable

                  String? GETDueTime = tasks[index].TaskDueTime == null
                      ? null
                      : "${tasks[index].TaskDueTime!.hour}:${tasks[index].TaskDueTime!.minute}";
                  // List<String> GETDue+++++++++++++++++++++TimePARTS = GETDueTime.split(' ');
                  // String? duetimeTime =
                  //     GETDueTimePARTS.isNotEmpty && GETDueTimePARTS.length >= 2
                  //         ? GETDueTimePARTS[1]
                  //         : "";

                  String? GETFirstTime = tasks[index].FirstTime == null
                      ? null
                      : "${tasks[index].FirstTime!.hour}:${tasks[index].FirstTime!.minute}";
                  // List<String> GETFirstTimePARTS = GETFirstTime.split(' ');
                  // String? firsttimeTime = GETFirstTimePARTS.isNotEmpty &&
                  //         GETFirstTimePARTS.length >= 2
                  //     ? GETFirstTimePARTS[1]
                  //     : "";

                  String? GETLastTime = tasks[index].LastTime == null
                      ? null
                      : "${tasks[index].FirstTime!.hour}:${tasks[index].FirstTime!.minute}";
                  // List<String> GETLastTimePARTS = GETLastTime.split(' ');
                  // String? lasttimeTime =
                  //     GETLastTimePARTS.isNotEmpty && GETDueTimePARTS.length >= 2
                  //         ? GETLastTimePARTS[1]
                  //         : "";

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: tasks[index].TasksStatus == 0
                            ? Colors.white
                            : Colors.green[300],
                        border: Border.all(
                          width: 1.0,
                          color: Colors.blueAccent,
                          //taskstatu[index].taskstatus=1
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text("Title:${tasks[index].TaskTitle}"),
                        subtitle: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Due Time: ${GETDueTime != null ? convertTo12HourFormat(GETDueTime) : '---'}",
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "First Date: ${firstdatedate ?? '---'} ",
                                      ),
                                      const SizedBox(
                                        width: 100,
                                      ),
                                      Text(
                                        "Last Date: ${lastdatedate ?? '---'}",
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "FIRST Time: ${GETFirstTime != null ? convertTo12HourFormat(GETFirstTime) : '---'}",
                                  ),

                                  Text(
                                    "LAST Time: ${GETLastTime != null ? convertTo12HourFormat(GETLastTime) : '---'}",
                                  ),

                                  // Text(
                                  //   tasks[index].TaskLatitude != null &&
                                  //           tasks[index].TaskLongitude != null
                                  //       ? "Task Location: ${"Editing Location"}"
                                  //       : tasks[index].isLocationBeingEdited()
                                  //           ? "Editing Location"
                                  //           : "Location not added",
                                  // ),

                                  // Add more properties as needed
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     // Navigate to the Uncompleted Tasks screen
                                    //     Navigator.pushReplacement(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //         builder: (context) => uncompleteTasks(
                                    //           task: tasks[index], // Pass the task to the UncompleteTasks screen
                                    //         ),
                                    //       ),
                                    //     );

                                    // Update task status to 0
                                    //     setState(() {
                                    //       tasks[index].complete = false;
                                    //     });
                                    //   },
                                    //   child: Container(
                                    //     width: 100.0,
                                    //     height: 40.0,
                                    //     decoration: BoxDecoration(
                                    //       borderRadius: BorderRadius.circular(15.0),
                                    //       border: Border.all(
                                    //         width: 5.0,
                                    //         color: Colors.blueAccent,
                                    //       ),
                                    //     ),
                                    //     child: Center(
                                    //       child: Text(
                                    //         'Uncompleted Tasks',
                                    //         style: TextStyle(
                                    //           fontSize: 9.0,
                                    //           fontWeight: FontWeight.bold,
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    // const SizedBox(
                                    //   height: 10,
                                    // ),
                                    GestureDetector(
                                      onTap: () {
                                        // Navigate to the Completed Tasks screen
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => const CompleteTasks(),
                                        //   ),
                                        // );
                                        UpdateSharedTaskStatus(
                                            tasks[index].TaskId);
                                        // Update task status to 1
                                        // setState(() {
                                        //   UpdateSharedTaskStatus(
                                        //       tasks[index].TaskId);
                                        // });
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 30.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          border: Border.all(
                                            width: 5.0,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Completed Tasks',
                                            style: TextStyle(
                                              fontSize: 9.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        //Navigate to the Uncompleted Tasks screen
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Tasks(t: tasks[index])),
                                        );

                                        setState(() {});
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 30.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          border: Border.all(
                                            width: 5.0,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Edit Again',
                                            style: TextStyle(
                                              fontSize: 9.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // const SizedBox(
                                    //   height: 2,
                                    // ),
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     //Navigate to the Uncompleted Tasks screen
                                    //     //   Navigator.pushReplacement(
                                    //     //     context,
                                    //     //    MaterialPageRoute(
                                    //     //      builder: (context) => Tasks(tasks)

                                    //     //     ),
                                    //     //  );
                                    //     deleteTask(tasks[index].TaskId);
                                    //     setState(() {});
                                    //   },
                                    //   child: Container(
                                    //     width:100,
                                    //     height: 30.0,
                                    //     decoration: BoxDecoration(
                                    //       borderRadius:
                                    //           BorderRadius.circular(15.0),
                                    //       border: Border.all(
                                    //         width: 5.0,
                                    //         color: Colors.blueAccent,
                                    //       ),
                                    //     ),
                                    //     child: const Center(
                                    //       child: Text(
                                    //         'Delete',
                                    //         style: TextStyle(
                                    //           fontSize: 9.0,
                                    //           fontWeight: FontWeight.bold,
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),

                              // Add more ListTile customization as needed
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    ]));
  }
}

List<sharedTaskmodel> tasks = [];
bool isEditing = false;

class AssignedToOthersPage extends StatefulWidget {
  const AssignedToOthersPage({Key? key}) : super(key: key);

  @override
  _AssignedToOthersPageState createState() => _AssignedToOthersPageState();
}

class _AssignedToOthersPageState extends State<AssignedToOthersPage> {
  @override
  late Future<List<sharedTaskmodel>> _futureTasks;

  @override
  void initState() {
    super.initState();
    _futureTasks = fetchData();
  }

  Future<List<sharedTaskmodel>> fetchData() async {
    final dio = Dio();
    try {
      final response =
          await dio.get('$ip/ShareoutTasks?userid=${loggedInUser!.id}');
      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        var task = data.map((item) => sharedTaskmodel.fromMap(item)).toList();
        return task;
        // ignore: dead_code
        setState(() {});
      } else {
        print('Failed to load tasks. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    String? convertTo12HourFormat(String timeStr) {
      List<String> timeParts = timeStr.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      // Convert to 12-hour format with AM/PM
      String period = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12 == 0 ? 12 : hour % 12;

      // Formatted time string
      return '$hour:$minute $period';
    }

    return Scaffold(
      body: Column(children: [
        const Text(
          "Assigned To Others Tasks",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: FutureBuilder<List<sharedTaskmodel>>(
            future: _futureTasks,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No tasks available.'));
              } else {
                List<sharedTaskmodel> tasks = snapshot.data!;
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    String? GETTaskDueDate =
                        tasks[index].TaskDueDate.toString();
                    List<String> dateTimeParts = GETTaskDueDate.split(' ');
                    String? dateStr =
                        dateTimeParts.isNotEmpty ? dateTimeParts[0] : "";

                    String? GETFirstDate = tasks[index].Firstdate.toString();
                    List<String> GETFirstDatePARTS = GETFirstDate.split(' ');
                    String? firstdatedate = GETFirstDatePARTS.isNotEmpty
                        ? GETFirstDatePARTS[0]
                        : null; // Make it nullable

                    String? GETLastDate = tasks[index].Lastdate.toString();
                    List<String> GETLastDatePARTS = GETLastDate.split(' ');
                    String? lastdatedate = GETLastDatePARTS.isNotEmpty
                        ? GETLastDatePARTS[0]
                        : null; // Make it nullable

                    String? GETDueTime = tasks[index].TaskDueTime == null
                        ? null
                        : "${tasks[index].TaskDueTime!.hour}:${tasks[index].TaskDueTime!.minute}";
                    // List<String> GETDue+++++++++++++++++++++TimePARTS = GETDueTime.split(' ');
                    // String? duetimeTime =
                    //     GETDueTimePARTS.isNotEmpty && GETDueTimePARTS.length >= 2
                    //         ? GETDueTimePARTS[1]
                    //         : "";

                    String? GETFirstTime = tasks[index].FirstTime == null
                        ? null
                        : "${tasks[index].FirstTime!.hour}:${tasks[index].FirstTime!.minute}";
                    // List<String> GETFirstTimePARTS = GETFirstTime.split(' ');
                    // String? firsttimeTime = GETFirstTimePARTS.isNotEmpty &&
                    //         GETFirstTimePARTS.length >= 2
                    //     ? GETFirstTimePARTS[1]
                    //     : "";

                    String? GETLastTime = tasks[index].LastTime == null
                        ? null
                        : "${tasks[index].FirstTime!.hour}:${tasks[index].FirstTime!.minute}";
                    // List<String> GETLastTimePARTS = GETLastTime.split(' ');
                    // String? lasttimeTime =
                    //     GETLastTimePARTS.isNotEmpty && GETDueTimePARTS.length >= 2
                    //         ? GETLastTimePARTS[1]
                    //         : "";

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.0,
                            color: Colors.blueAccent,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Container(
                          color: Colors.orange,
                          child: ListTile(
                            title: Text("Title:${tasks[index].TaskTitle}"),
                            subtitle: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                          "TaskStatus:${tasks[index]?.ShareTaskStatus == true ? "accepted" : "Reject"}"),

                                      Padding(
                                        padding: EdgeInsets.only(left: 200),
                                        child: GestureDetector(
                                          onTap: () {
                                            //Navigate to the Uncompleted Tasks screen
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Tasks()),
                                            );

                                            setState(() {});
                                          },
                                          child: Container(
                                            width: 100.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              border: Border.all(
                                                width: 5.0,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'postpond',
                                                style: TextStyle(
                                                  fontSize: 9.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      //  Column(
                                      //    children: [
                                      //      Text(
                                      //        "First Date: ${firstdatedate ?? ''} ",
                                      //      ),
                                      //      const SizedBox(
                                      //        width: 100,
                                      //      ),
                                      //      Text(
                                      //        "Last Date: ${lastdatedate ?? ''}",
                                      //      ),
                                      //    ],
                                      //  ),
                                      //  Text(
                                      //    "First Time: ${firsttimeTime ?? ''} ",
                                      //  ),
                                      //  const SizedBox(
                                      //    width: 95,
                                      //  ),

                                      //  Text(
                                      //    "Repeat:${tasks[index].UserId ?? ''} ",
                                      //  ),

                                      //  const SizedBox(
                                      //    width: 120,
                                      //  ),

                                      //  Text(
                                      //    tasks[index].TaskLatitude != null &&
                                      //            tasks[index].TaskLongitude != null
                                      //        ? "Task Location: ${"Editing Location"}"
                                      //        : tasks[index].isLocationBeingEdited()
                                      //            ? "Editing Location"
                                      //           : "Location not added",
                                      // ),

                                      // //Add more properties as needed
                                    ],
                                  ),

                                  // Padding(
                                  //   padding: const EdgeInsets.all(20.0),
                                  //   child: Column(
                                  //     children: [
                                  //       GestureDetector(
                                  //         onTap: () {
                                  //           // Navigate to the Uncompleted Tasks screen
                                  //           // Navigator.pushReplacement(
                                  //           //   context,
                                  //           //   // MaterialPageRoute(
                                  //           //   //     builder: (context) =>
                                  //           //   //         // uncompleteTasks(
                                  //           //   //         //   //task: tasks[index],
                                  //           //   //         // )
                                  //           //   //         ),
                                  //           // );
                                  //           setState(() {
                                  //             tasks.removeAt(index);
                                  //           });
                                  //         },
                                  //         child: Container(
                                  //           width: 100.0,
                                  //           height: 40.0,
                                  //           decoration: BoxDecoration(
                                  //             borderRadius: BorderRadius.circular(
                                  //                 15.0), // Set circular border
                                  //             border: Border.all(
                                  //               width: 5.0,
                                  //               color: Colors.blueAccent,
                                  //             ),
                                  //           ),
                                  //           child: const Center(
                                  //             child: Text(
                                  //               'Uncompleted Tasks',
                                  //               style: TextStyle(
                                  //                 fontSize: 9.0,
                                  //                 fontWeight: FontWeight.bold,
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //       const SizedBox(
                                  //         height: 10,
                                  //       ),
                                  //       GestureDetector(
                                  //         onTap: () {
                                  //           // Navigate to the Completed Tasks screen
                                  //           Navigator.push(
                                  //             context,
                                  //             MaterialPageRoute(
                                  //                 builder: (context) =>
                                  //                     const CompleteTasks()),
                                  //           );
                                  //           setState(() {
                                  //             tasks.removeAt(index);
                                  //           });
                                  //         },
                                  //         child: Container(
                                  //           width: 100.0,
                                  //           height: 40.0,
                                  //           decoration: BoxDecoration(
                                  //             borderRadius: BorderRadius.circular(
                                  //                 15.0), // Set circular border
                                  //             border: Border.all(
                                  //               width: 5.0,
                                  //               color: Colors.blueAccent,
                                  //             ),
                                  //           ),
                                  //           child: const Center(
                                  //             child: Text(
                                  //               'Completed Tasks',
                                  //               style: TextStyle(
                                  //                 fontSize: 9.0,
                                  //                 fontWeight: FontWeight.bold,
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // Add more ListTile customization as needed
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ]),
    );
  }
}

class AssignedToMePage extends StatefulWidget {
  const AssignedToMePage({Key? key}) : super(key: key);

  @override
  _AssignedToMePageState createState() => _AssignedToMePageState();
}

class _AssignedToMePageState extends State<AssignedToMePage> {
  List<sharedTaskmodel> tasks = [];
  late final Taskmodel task;
  @override
  late Future<List<sharedTaskmodel>> _futureTasks;

  @override
  void initState() {
    super.initState();
    _futureTasks = fetchData();
    //_futureTasks = fetchData1();
  }

  Future<List<sharedTaskmodel>> fetchData() async {
    final dio = Dio();
    try {
      final response =
          await dio.get('$ip/ShareinTasks?userid=${loggedInUser!.id}');
      if (response.statusCode == 200) {
        // Assuming the response data is a List<dynamic>
        final List<dynamic> data = response.data as List<dynamic>;

        // Mapping each item in the list to a sharedTaskmodel object

        var task = data.map((item) => sharedTaskmodel.fromMap(item)).toList();
        return task;
      } else {
        print('Failed to load tasks. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
  // Future<List<sharedTaskmodel>> fetchData1() async {
  //   final dio = Dio();
  //   try {
  //     final response =
  //         await dio.get('$ip/updateTaksstaus?userid=${loggedInUser!.id}');
  //     if (response.statusCode == 200) {
  //       // Assuming the response data is a List<dynamic>
  //       final List<dynamic> data = response.data as List<dynamic>;

  //       // Mapping each item in the list to a sharedTaskmodel object
  //       var task = data
  //           .map((item) =>
  //               sharedTaskmodel.fromJson(item as Map<String, dynamic>))
  //           .toList();
  //       return task;
  //     } else {
  //       print('Failed to load tasks. Status code: ${response.statusCode}');
  //       return [];
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     return [];
  //   }
  // }
  Future<void> deleteTask(int taskId) async {
    print(taskId);
    final dio = Dio();
    final String apiUrl = '$ip/DeleteTask';

    try {
      final response = await dio.post('$apiUrl?taskId=$taskId');

      if (response.statusCode == 200) {
        // Task deleted successfully
        print('Task deleted successfully!');
        fetchData();
        setState(() {});
        // return "Task deleted successfully!";
      } else if (response.statusCode == 404) {
        // Task not found
        print("Task with ID $taskId not found.");
        // return "Task with ID $taskId not found.";
      } else {
        // Other error
        print("Failed to delete task. Error: ${response.data}");
        // return "Failed to delete task. Error: ${response.data}";
      }
    } catch (e) {
      // Handle network or other errors
      print("Failed to delete task. Error: $e");
      // return "Failed to delete task. Error: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    String? convertTo12HourFormat(String timeStr) {
      List<String> timeParts = timeStr.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      // Convert to 12-hour format with AM/PM
      String period = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12 == 0 ? 12 : hour % 12;

      // Formatted time string
      return '$hour:$minute $period';
    }

    return Scaffold(
      body: Column(children: [
        Text(
          "Assigned To Me Tasks",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        //Spacer(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: FutureBuilder<List<sharedTaskmodel>>(
            future: _futureTasks,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No tasks available.'));
              } else {
                List<sharedTaskmodel> tasks = snapshot.data!;
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    String? GETTaskDueDate =
                        tasks[index].TaskDueDate.toString();
                    List<String> dateTimeParts = GETTaskDueDate.split(' ');
                    String? dateStr =
                        dateTimeParts.isNotEmpty ? dateTimeParts[0] : "";

                    String? GETFirstDate = tasks[index].Firstdate.toString();
                    List<String> GETFirstDatePARTS = GETFirstDate.split(' ');
                    String? firstdatedate = GETFirstDatePARTS.isNotEmpty
                        ? GETFirstDatePARTS[0]
                        : "";

                    String? GETLastDate = tasks[index].Lastdate.toString();
                    List<String> GETLastDatePARTS = GETLastDate.split(' ');
                    String? lastdatedate =
                        GETLastDatePARTS.isNotEmpty ? GETLastDatePARTS[0] : "";

                    String? GETDueTime = tasks[index].TaskDueTime == null
                        ? null
                        : "${tasks[index].TaskDueTime!.hour}:${tasks[index].TaskDueTime!.minute}";
                    // List<String> GETDue+++++++++++++++++++++TimePARTS = GETDueTime.split(' ');
                    // String? duetimeTime =
                    //     GETDueTimePARTS.isNotEmpty && GETDueTimePARTS.length >= 2
                    //         ? GETDueTimePARTS[1]
                    //         : "";

                    String? GETFirstTime = tasks[index].FirstTime == null
                        ? null
                        : "${tasks[index].FirstTime!.hour}:${tasks[index].FirstTime!.minute}";
                    // List<String> GETFirstTimePARTS = GETFirstTime.split(' ');
                    // String? firsttimeTime = GETFirstTimePARTS.isNotEmpty &&
                    //         GETFirstTimePARTS.length >= 2
                    //     ? GETFirstTimePARTS[1]
                    //     : "";

                    String? GETLastTime = tasks[index].LastTime == null
                        ? null
                        : "${tasks[index].FirstTime!.hour}:${tasks[index].FirstTime!.minute}";
                    // List<String> GETLastTimePARTS = GETLastTime.split(' ');
                    // String? lasttimeTime =
                    //     GETLastTimePARTS.isNotEmpty && GETDueTimePARTS.length >= 2
                    //         ? GETLastTimePARTS[1]
                    //         : "";s
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.0,
                              color: Colors.blueAccent,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            color: Colors.green,
                            child: ListTile(
                              title: Text("Title:${tasks[index].TaskTitle}"),
                              subtitle: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Due Time: ${GETDueTime != null ? convertTo12HourFormat(GETDueTime) : ''}",
                                        ),
                                        // Text(
                                        //   "Due DATE:$GETTaskDueDate ",
                                        // ),
                                        Column(
                                          children: [
                                            Text(
                                              "First Date: ${firstdatedate ?? '---'} ",
                                            ),
                                            const SizedBox(
                                              width: 100,
                                            ),
                                            Text(
                                              "Last Date: ${lastdatedate ?? '---'}",
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "First Time: ${GETFirstTime ?? '---'} ",
                                        ),
                                        const SizedBox(
                                          width: 95,
                                        ),
                                        Text(
                                          "Last Time: ${GETLastTime ?? '---'}",
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            if (tasks[index].TaskLatitude !=
                                                    null &&
                                                tasks[index].TaskLongitude !=
                                                    null) {
                                              // Location exists, navigate to MapDemo
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => MapDemo(
                                                    polygonData: [],
                                                    taskdate:
                                                        tasks[index].Firstdate,
                                                    tasktime: tasks[index]
                                                        .TaskDueTime,
                                                    targetLocation: LatLng(
                                                      tasks[index]
                                                          .TaskLatitude!,
                                                      tasks[index]
                                                          .TaskLongitude!,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              // Location doesn't exist, handle this case or do nothing
                                              print('Location doesn\'t exist');
                                            }
                                          },
                                          child: Text(
                                            tasks[index].TaskLatitude != null &&
                                                    tasks[index]
                                                            .TaskLongitude !=
                                                        null
                                                ? "Editing Location"
                                                : tasks[index]
                                                        .isLocationBeingEdited()
                                                    ? "Editing Location"
                                                    : "Location not added",
                                          ),
                                        ),

                                        // const SizedBox(
                                        //   width: 120,
                                        // ),

                                        // Text(
                                        //   tasks[index].TaskLatitude != null &&
                                        //           tasks[index].TaskLongitude != null
                                        //       ? "Task Location: ${"Editing Location"}"
                                        //       : tasks[index].isLocationBeingEdited()
                                        //           ? "Editing Location"
                                        //           : "Location not added",
                                        // ),

                                        // //Add more properties as needed
                                      ],
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(20.0),
                                      //     child: Column(children: [
                                      //       GestureDetector(
                                      //         onTap: () {
                                      //           //Navigate to the Uncompleted Tasks screen
                                      //           Navigator.pushReplacement(
                                      //             context,
                                      //             MaterialPageRoute(
                                      //                 builder: (context) =>
                                      //                     Tasks(t: task[])),
                                      //           );

                                      //           setState(() {});
                                      //         },
                                      //         child: Container(
                                      //           width: 100.0,
                                      //           height: 40.0,
                                      //           decoration: BoxDecoration(
                                      //             borderRadius:
                                      //                 BorderRadius.circular(15.0),
                                      //             border: Border.all(
                                      //               width: 5.0,
                                      //               color: Colors.blueAccent,
                                      //             ),
                                      //           ),
                                      //           child: const Center(
                                      //             child: Text(
                                      //               'Edit Again',
                                      //               style: TextStyle(
                                      //                 fontSize: 9.0,
                                      //                 fontWeight: FontWeight.bold,
                                      //               ),
                                      //             ),
                                      //           ),
                                      //         ),
                                    ),
                                    //       const SizedBox(
                                    //         height: 2,
                                    //       ),
                                    GestureDetector(
                                      onTap: () {
                                        //Navigate to the Uncompleted Tasks screen
                                        //   Navigator.pushReplacement(
                                        //     context,
                                        //    MaterialPageRoute(
                                        //      builder: (context) => Tasks(tasks)

                                        //     ),
                                        //  );
                                        deleteTask(tasks[index].TaskId);
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: 100.0,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          border: Border.all(
                                            width: 5.0,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(
                                              fontSize: 9.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(20.0),
                                    //   child: Column(
                                    //     children: [
                                    //       GestureDetector(
                                    //         onTap: () {
                                    //           // Navigate to the Uncompleted Tasks screen
                                    //           // Navigator.pushReplacement(
                                    //           //   context,
                                    //           //   // MaterialPageRoute(
                                    //           //   //     builder: (context) =>
                                    //           //   //         // uncompleteTasks(
                                    //           //   //         //   //task: tasks[index],
                                    //           //   //         // )
                                    //           //   //         ),
                                    //           // );
                                    //           setState(() {
                                    //             tasks.removeAt(index);
                                    //           });
                                    //         },
                                    //         child: Container(
                                    //           width: 100.0,
                                    //           height: 40.0,
                                    //           decoration: BoxDecoration(
                                    //             borderRadius: BorderRadius.circular(
                                    //                 15.0), // Set circular border
                                    //             border: Border.all(
                                    //               width: 5.0,
                                    //               color: Colors.blueAccent,
                                    //             ),
                                    //           ),
                                    //           child: const Center(
                                    //             child: Text(
                                    //               'Uncompleted Tasks',
                                    //               style: TextStyle(
                                    //                 fontSize: 9.0,
                                    //                 fontWeight: FontWeight.bold,
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //       const SizedBox(
                                    //         height: 10,
                                    //       ),
                                    //       GestureDetector(
                                    //         onTap: () {
                                    //           // Navigate to the Completed Tasks screen
                                    //           Navigator.push(
                                    //             context,
                                    //             MaterialPageRoute(
                                    //                 builder: (context) =>
                                    //                     const CompleteTasks()),
                                    //           );
                                    //           setState(() {
                                    //             tasks.removeAt(index);
                                    //           });
                                    //         },
                                    //         child: Container(
                                    //           width: 100.0,
                                    //           height: 40.0,
                                    //           decoration: BoxDecoration(
                                    //             borderRadius: BorderRadius.circular(
                                    //                 15.0), // Set circular border
                                    //             border: Border.all(
                                    //               width: 5.0,
                                    //               color: Colors.blueAccent,
                                    //             ),
                                    //           ),
                                    //           child: const Center(
                                    //             child: Text(
                                    //               'Completed Tasks',
                                    //               style: TextStyle(
                                    //                 fontSize: 9.0,
                                    //                 fontWeight: FontWeight.bold,
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    // Add more ListTile customization as needed
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ));
                  },
                );
              }
            },
          ),
        ),
      ]),
    );
  }
}

class AllTasksDetailPage extends StatelessWidget {
  const AllTasksDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Assigned to Me other'),
    );
  }
}

class owntaskDetailPage extends StatefulWidget {
  const owntaskDetailPage({super.key});

  @override
  State<owntaskDetailPage> createState() => _owntaskDetailPageState();
}

class _owntaskDetailPageState extends State<owntaskDetailPage> {
  late Future<List<Taskmodel>> _futureTasks;

  @override
  void initState() {
    super.initState();
    _futureTasks = fetchData();
  }

  Future<List<Taskmodel>> fetchData() async {
    final dio = Dio();
    try {
      final response = await dio.get(
        '$ip/OWNTasks?userid=${loggedInUser!.id}',
      );
      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        var task = data.map((item) => Taskmodel.fromMap(item)).toList();
        // Sort tasks based on TaskDueDate
        tasks.sort((a, b) {
          String aDateStr = DateFormat('yyyy-MM-dd').format(a.Firstdate!);
          String bDateStr = DateFormat('yyyy-MM-dd').format(b.Firstdate!);
          DateTime aDate = DateFormat('yyyy-MM-dd').parse(aDateStr);
          DateTime bDate = DateFormat('yyyy-MM-dd').parse(bDateStr);
          return aDate.compareTo(bDate);
        });
        setState(() {});
        return task;
      } else {
        print('Failed to load tasks. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<void> deleteTask(int taskId) async {
    print(taskId);
    final dio = Dio();
    final String apiUrl = '$ip/DeleteTask';

    try {
      final response = await dio.post('$apiUrl?taskId=$taskId');

      if (response.statusCode == 200) {
        // Task deleted successfully
        print('Task deleted successfully!');
        fetchData();
        setState(() {});
        // return "Task deleted successfully!";
      } else if (response.statusCode == 404) {
        // Task not found
        print("Task with ID $taskId not found.");
        // return "Task with ID $taskId not found.";
      } else {
        // Other error
        print("Failed to delete task. Error: ${response.data}");
        // return "Failed to delete task. Error: ${response.data}";
      }
    } catch (e) {
      // Handle network or other errors
      print("Failed to delete task. Error: $e");
      // return "Failed to delete task. Error: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    String? convertTo12HourFormat(String timeStr) {
      List<String> timeParts = timeStr.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      // Convert to 12-hour format with AM/PM
      String period = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12 == 0 ? 12 : hour % 12;

      // Formatted time string
      return '$hour:$minute $period';
    }

    return Scaffold(
      body: Column(children: [
        Text(
          "Own Tasks",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        //Spacer(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: FutureBuilder<List<Taskmodel>>(
            future: _futureTasks,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No tasks available.'));
              } else {
                List<Taskmodel> tasks = snapshot.data!;
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    String? GETTaskDueDate =
                        tasks[index].TaskDueDate.toString();
                    List<String> dateTimeParts = GETTaskDueDate.split(' ');
                    String? dateStr =
                        dateTimeParts.isNotEmpty ? dateTimeParts[0] : "";

                    String? GETFirstDate = tasks[index].Firstdate.toString();
                    List<String> GETFirstDatePARTS = GETFirstDate.split(' ');
                    String? firstdatedate = GETFirstDatePARTS.isNotEmpty
                        ? GETFirstDatePARTS[0]
                        : null; // Make it nullable

                    String? GETLastDate = tasks[index].Lastdate.toString();
                    List<String> GETLastDatePARTS = GETLastDate.split(' ');
                    String? lastdatedate = GETLastDatePARTS.isNotEmpty
                        ? GETLastDatePARTS[0]
                        : null; // Make it nullable

                    String? GETDueTime = tasks[index].TaskDueTime == null
                        ? null
                        : "${tasks[index].TaskDueTime!.hour}:${tasks[index].TaskDueTime!.minute}";
                    // List<String> GETDue+++++++++++++++++++++TimePARTS = GETDueTime.split(' ');
                    // String? duetimeTime =
                    //     GETDueTimePARTS.isNotEmpty && GETDueTimePARTS.length >= 2
                    //         ? GETDueTimePARTS[1]
                    //         : "";

                    String? GETFirstTime = tasks[index].FirstTime == null
                        ? null
                        : "${tasks[index].FirstTime!.hour}:${tasks[index].FirstTime!.minute}";
                    // List<String> GETFirstTimePARTS = GETFirstTime.split(' ');
                    // String? firsttimeTime = GETFirstTimePARTS.isNotEmpty &&
                    //         GETFirstTimePARTS.length >= 2
                    //     ? GETFirstTimePARTS[1]
                    //     : "";

                    String? GETLastTime = tasks[index].LastTime == null
                        ? null
                        : "${tasks[index].FirstTime!.hour}:${tasks[index].FirstTime!.minute}";
                    // List<String> GETLastTimePARTS = GETLastTime.split(' ');
                    // String? lasttimeTime =
                    //     GETLastTimePARTS.isNotEmpty && GETDueTimePARTS.length >= 2
                    //         ? GETLastTimePARTS[1]
                    //         : "";

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 1.0,
                              color: Colors.blueAccent,

                              //taskstatu[index].taskstatus=1
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                              title: Text("Title:${tasks[index].TaskTitle}"),
                              subtitle: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Due Time: ${GETDueTime != null ? convertTo12HourFormat(GETDueTime) : '---'}",
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "First Date: ${firstdatedate ?? '---'} ",
                                            ),
                                            const SizedBox(
                                              width: 100,
                                            ),
                                            Text(
                                              "Last Date: ${lastdatedate ?? '---'}",
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "FIRST Time: ${GETFirstTime != null ? convertTo12HourFormat(GETFirstTime) : '---'}",
                                        ),

                                        Text(
                                          "LAST Time: ${GETLastTime != null ? convertTo12HourFormat(GETLastTime) : '---'}",
                                        ),

                                        // Text(
                                        //   tasks[index].TaskLatitude != null &&
                                        //           tasks[index].TaskLongitude != null
                                        //       ? "Task Location: ${"Editing Location"}"
                                        //       : tasks[index].isLocationBeingEdited()
                                        //           ? "Editing Location"
                                        //           : "Location not added",
                                        // ),

                                        // Add more properties as needed
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(children: [
                                        GestureDetector(
                                          onTap: () {
                                            //Navigate to the Uncompleted Tasks screen
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Tasks(t: tasks[index])),
                                            );

                                            setState(() {});
                                          },
                                          child: Container(
                                            width: 100.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              border: Border.all(
                                                width: 5.0,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Edit Again',
                                                style: TextStyle(
                                                  fontSize: 9.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            //Navigate to the Uncompleted Tasks screen
                                            //   Navigator.pushReplacement(
                                            //     context,
                                            //    MaterialPageRoute(
                                            //      builder: (context) => Tasks(tasks)

                                            //     ),
                                            //  );
                                            deleteTask(tasks[index].TaskId);
                                            setState(() {});
                                          },
                                          child: Container(
                                            width: 100.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              border: Border.all(
                                                width: 5.0,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                  fontSize: 9.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // GestureDetector(
                                        //   onTap: () {
                                        //     // Navigate to the Uncompleted Tasks screen
                                        //     Navigator.pushReplacement(
                                        //       context,
                                        //       MaterialPageRoute(
                                        //         builder: (context) => uncompleteTasks(
                                        //           task: tasks[index], // Pass the task to the UncompleteTasks screen
                                        //         ),
                                        //       ),
                                        //     );

                                        // Update task status to 0
                                        //     setState(() {
                                        //       tasks[index].complete = false;
                                        //     });
                                        //   },
                                        //   child: Container(
                                        //     width: 100.0,
                                        //     height: 40.0,
                                        //     decoration: BoxDecoration(
                                        //       borderRadius: BorderRadius.circular(15.0),
                                        //       border: Border.all(
                                        //         width: 5.0,
                                        //         color: Colors.blueAccent,
                                        //       ),
                                        //     ),
                                        //     child: Center(
                                        //       child: Text(
                                        //         'Uncompleted Tasks',
                                        //         style: TextStyle(
                                        //           fontSize: 9.0,
                                        //           fontWeight: FontWeight.bold,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                        // const SizedBox(
                                        //   height: 10,
                                        // ),
                                        //                                   GestureDetector(
                                        //                                     onTap: () {
                                        //                                       // Navigate to the Completed Tasks screen
                                        //                                       // Navigator.push(
                                        //                                       //   context,
                                        //                                       //   MaterialPageRoute(
                                        //                                       //     builder: (context) => const CompleteTasks(),
                                        //                                       //   ),
                                        //                                       // );

                                        //                                       // Update task status to 1

                                        //                                       setState(() {
                                        //                                         print(tasks[index].TasksStatus);
                                        //                                         UpdateSharedTaskStatus(
                                        //                                             tasks[index].TaskId);
                                        //                                         fetchData();
                                        //                                         print(tasks[index].TasksStatus);
                                        //                                       });
                                        //                                     },
                                        //                                     child: Container(
                                        //                                       width: 100.0,
                                        //                                       height: 40.0,
                                        //                                       decoration: BoxDecoration(
                                        //                                         borderRadius:
                                        //                                             BorderRadius.circular(15.0),
                                        //                                         border: Border.all(
                                        //                                           width: 5.0,
                                        //                                           color: Colors.blueAccent,
                                        //                                         ),
                                        //                                       ),
                                        //                                       child: Center(
                                        //   child: Text(
                                        //     (tasks[index].TasksStatus == 0)
                                        //       ? 'Not Complete'
                                        //       : 'Completed',
                                        //     style: TextStyle(
                                        //       fontSize: 9.0,
                                        //       fontWeight: FontWeight.bold,
                                        //     ),
                                        //   ),
                                        // ),
                                      ]),
                                    ),
                                  ],
                                ),
                              ))),
                    );
                  },
                );
              }
            },
          ),
        ),
      ]),
    );
  }
}
