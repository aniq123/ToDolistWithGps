import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_22/Global.dart';
import 'package:flutter_application_22/Model/sharedtaskmodel.dart';
import 'package:flutter_application_22/Screens/ToDo.dart';

class GeoFancingPending extends StatefulWidget {
  const GeoFancingPending({super.key});

  @override
  State<GeoFancingPending> createState() => _GeoFancingPendingState();
}

class _GeoFancingPendingState extends State<GeoFancingPending> {
  late Future<List<sharedTaskmodel>> _futureTasks;
  int numberOfPendingTasks = 0;

  @override
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

  Future<void> updateSharedGeofencestatus(int taskId) async {
    final dio = Dio();

    try {
      final response = await dio.post(
        '$ip/updateSharedGeofencestatus?taskid=$taskId',
      );

      if (response.statusCode == 200) {
        print('ShareTask status updated successfully');
        updateNumberOfPendingTasks();
        showPendingTasksPopup();
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

  Future<List<sharedTaskmodel>> fetchData() async {
    final dio = Dio();
    try {
      final response = await dio
          .get('$ip/GetPendingSharedGeofence?userid=${loggedInUser!.id}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(52, 255, 214, 1),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Center(child: Text("Pending Task")),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ToDo(),
              ),
            );
          },
        ),
      ),
      body: FutureBuilder<List<sharedTaskmodel>>(
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
                String? GETTaskDueDate = tasks[index].TaskDueDate.toString();
                List<String> dateTimeParts = GETTaskDueDate.split(' ');
                String? dateStr =
                    dateTimeParts.isNotEmpty ? dateTimeParts[0] : "";

                String? GETFirstDate = tasks[index].Firstdate.toString();
                List<String> GETFirstDatePARTS = GETFirstDate.split(' ');
                String? firstdatedate =
                    GETFirstDatePARTS.isNotEmpty ? GETFirstDatePARTS[0] : "";

                String? GETLastDate = tasks[index].Lastdate.toString();
                List<String> GETLastDatePARTS = GETLastDate.split(' ');
                String? lastdatedate =
                    GETLastDatePARTS.isNotEmpty ? GETLastDatePARTS[0] : "";

                String? GETDueTime = tasks[index].TaskDueTime.toString();
                List<String> GETDueTimePARTS = GETDueTime.split(' ');
                String? duetimeTime =
                    GETDueTimePARTS.isNotEmpty && GETDueTimePARTS.length >= 2
                        ? GETDueTimePARTS[1]
                        : "";

                String? GETFirstTime = tasks[index].FirstTime.toString();
                List<String> GETFirstTimePARTS = GETFirstTime.split(' ');
                String? firsttimeTime = GETFirstTimePARTS.isNotEmpty &&
                        GETFirstTimePARTS.length >= 2
                    ? GETFirstTimePARTS[1]
                    : "";

                String? GETLastTime = tasks[index].LastTime.toString();
                List<String> GETLastTimePARTS = GETLastTime.split(' ');
                String? lasttimeTime =
                    GETLastTimePARTS.isNotEmpty && GETLastTimePARTS.length >= 2
                        ? GETLastTimePARTS[1]
                        : "";

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
                        title: Text("Title: ${tasks[index].TaskTitle}"),
                        subtitle: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Due Time: ${duetimeTime ?? ''}",
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "First Date: ${firstdatedate ?? ''} ",
                                      ),
                                      const SizedBox(
                                        width: 100,
                                      ),
                                      Text(
                                        "Last Date: ${lastdatedate ?? ''}",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            updateSharedGeofencestatus(tasks[index].TaskId);
                          },
                          child: const Text('Accept'),
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
    );
    ;
  }
}
