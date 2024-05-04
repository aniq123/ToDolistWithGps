import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_22/Global.dart';
import 'package:flutter_application_22/Model/taskmodel.dart';

class AssignedToMePage extends StatefulWidget {
  const AssignedToMePage({Key? key}) : super(key: key);

  @override
  State<AssignedToMePage> createState() => _AssignedToMePageState();
}

class _AssignedToMePageState extends State<AssignedToMePage> {
  late Future<List<Taskmodel>> _futureTasks;

  @override
  void initState() {
    super.initState();
    _futureTasks = fetchData();
  }

  Future<List<Taskmodel>> fetchData() async {
    final dio = Dio();
    try {
      final response =
          await dio.get('$ip/GetPendingSharedTasks?userid=${loggedInUser!.id}');
      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data.map((item) => Taskmodel.fromJson(item)).toList();
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
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Center(child: Text("Assign to me")),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(builder: (context) => const ToDo()),
        //     );
        //   },
        // ),
      ),
      body: FutureBuilder<List<Taskmodel>>(
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
                    GETDueTimePARTS.isNotEmpty ? GETDueTimePARTS[1] : "";

                String? GETFirstTime = tasks[index].FirstTime.toString();
                List<String> GETFirstTimePARTS = GETFirstTime.split(' ');
                String? firsttimeTime =
                    GETFirstTimePARTS.isNotEmpty ? GETFirstTimePARTS[1] : "";

                String? GETLastTime = tasks[index].LastTime.toString();
                List<String> GETLastTimePARTS = GETLastTime.split(' ');
                String? lasttimeTime =
                    GETLastTimePARTS.isNotEmpty ? GETLastTimePARTS[1] : "";

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
                                  "Due Time:$duetimeTime ",
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
                                Text(
                                  "First Time: ${firsttimeTime ?? ''} ",
                                ),
                                const SizedBox(
                                  width: 95,
                                ),
                                Text(
                                  "Last Time: ${lasttimeTime ?? ''}",
                                ),
                                const SizedBox(
                                  width: 120,
                                ),
                                Text(
                                  tasks[index].TaskLatitude != null &&
                                          tasks[index].TaskLongitude != null
                                      ? "Task Location: ${"Editing Location"}"
                                      : tasks[index].isLocationBeingEdited()
                                          ? "Editing Location"
                                          : "Location not added",
                                ),
                              ],
                            ),
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
    );
  }
}
