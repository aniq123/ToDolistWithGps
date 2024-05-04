import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_22/Global.dart';
import 'package:flutter_application_22/Model/taskmodel.dart';
import 'package:flutter_application_22/Screens/Tasks.dart';
import 'package:flutter_application_22/Screens/ToDo.dart';
import 'package:intl/intl.dart';

class CompleteTasks extends StatefulWidget {
  const CompleteTasks({Key? key}) : super(key: key);

  @override
  State<CompleteTasks> createState() => _CompleteTasksState();
}

class _CompleteTasksState extends State<CompleteTasks> {
  // int myIndex = 0;
  // // Color homeColor = Colors.blue;
  // // Color contactsColor = Colors.red;
  // Color completeColor = Colors.blue;

  // void _showOptions(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Center(
  //         child: Container(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               Center(
  //                 child: Container(
  //                   child: ListTile(
  //                     leading: const Icon(Icons.assignment),
  //                     title: const Text('Task Sharing'),
  //                     onTap: () {
  //                       // Handle task sharing option
  //                       Navigator.pop(context); // Close the bottom sheet
  //                       Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (context) => const TaskSharing()),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ),
  //               ListTile(
  //                 leading: const Icon(Icons.share),
  //                 title: const Text('Sharing'),
  //                 onTap: () {
  //                   // Handle sharing option
  //                   Navigator.pop(context); // Close the bottom sheet
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(builder: (context) => const sharing()),
  //                   );
  //                 },
  //               ),
  //               ListTile(
  //                 leading: const Icon(Icons.assignment_turned_in),
  //                 title: const Text('Task'),
  //                 onTap: () {
  //                   Navigator.pop(context); // Close the bottom sheet
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(builder: (context) => const Tasks()),
  //                   );
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // List<Contactmodel> contact = [];
  // bool isLoading = true;
  // @override
  // void initState() {
  //   super.initState();
  //   // getContactsPermission();
  //   fetchData();
  // }

  // Future<List<Contactmodel>> fetchData() async {
  //   final dio = Dio();

  //   try {
  //     final response = await dio.get('$ip/GetAllUsers');

  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = response.data as List<dynamic>;

  //       // Assuming Contactmodel.fromMap() is a factory constructor in Contactmodel
  //       // Update the Contactmodel.fromMap() method accordingly
  //       List<Contactmodel> contactList =
  //           data.map((item) => Contactmodel.fromMap(item)).toList();

  //       //setState(() {
  //       // isLoading = false;
  //       // Assuming contact is a member variable in your widget class
  //       //contact = contactList;
  //       //});

  //       return contactList;
  //     } else {
  //       print('Failed to load tasks. Status code: ${response.statusCode}');
  //       // Return an empty list or throw an exception based on your requirements
  //       return [];
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     // Return an empty list or throw an exception based on your requirements
  //     return [];
  //   }
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Center(child: Text("Completed Tasks")),
  //       backgroundColor: Colors.purple,
  //       leading: IconButton(
  //         icon: const Icon(Icons.arrow_back),
  //         onPressed: () {
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) =>
  //                     const ToDo()), // Replace ToDo() with the actual widget for your ToDo screen
  //           );
  //         },
  //       ),
  //     ),

  // Working of database contacts//
  //   body: Column(
  //     children: [
  //       // if (isLoading)
  //       //   const Center(
  //       //     child: CircularProgressIndicator(),
  //       //   )
  //       // else
  //       Expanded(
  //         child: FutureBuilder<List<Contactmodel>>(
  //           future:
  //               fetchData(), // Assume getData is your asynchronous function
  //           builder: (context, snapshot) {
  //             if (snapshot.connectionState == ConnectionState.waiting) {
  //               // If the Future is still running, show a loading indicator
  //               return const CircularProgressIndicator();
  //             } else if (snapshot.hasError) {
  //               // If the Future throws an error, display the error message
  //               return Text('Error: ${snapshot.error}');
  //             } else {
  //               // If the Future is complete and successful, display the data
  //               List<Contactmodel> contact = snapshot.data ?? [];

  //               return Column(
  //                 children: [
  //                   const SizedBox(
  //                     height: 15.0,
  //                   ),
  //                   const TextField(
  //                       // Your TextField widget remains unchanged
  //                       ),
  //                   Expanded(
  //                     child: ListView.builder(
  //                       itemCount: contact.length,
  //                       itemBuilder: (context, index) {
  //                         Contactmodel apiContact = contact[index];

  //                         return Container(
  //                           margin: const EdgeInsets.all(8.0),
  //                           padding: const EdgeInsets.all(16.0),
  //                           decoration: BoxDecoration(
  //                             color: Colors.white,
  //                             borderRadius: BorderRadius.circular(8.0),
  //                             boxShadow: [
  //                               BoxShadow(
  //                                 color: Colors.grey.withOpacity(0.5),
  //                                 spreadRadius: 2,
  //                                 blurRadius: 5,
  //                                 offset: const Offset(0, 3),
  //                               ),
  //                             ],
  //                           ),
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 'USERID: ${apiContact.UserId ?? 'N/A'}',
  //                                 style: const TextStyle(fontSize: 18),
  //                               ),
  //                               Text(
  //                                 'Name: ${apiContact.UserName ?? 'N/A'}',
  //                                 style: const TextStyle(fontSize: 18),
  //                               ),
  //                               Text(
  //                                 'Phone: ${apiContact.PhoneNumber ?? 'N/A'}',
  //                                 style: const TextStyle(fontSize: 16),
  //                               ),
  //                             ],
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               );
  //             }
  //           },
  //         ),
  //       ),
  //     ],
  //   ),
  //   floatingActionButton: FloatingActionButton(
  //     onPressed: () {
  //       _showOptions(context); // Call the _showOptions function
  //     },
  //     child: const Icon(Icons.add),
  //   ),
  //   bottomNavigationBar: BottomNavigationBar(
  //     backgroundColor: Colors.purple,
  //     onTap: (index) {
  //       setState(() {
  //         myIndex = index;
  //       });
  //       if (index == 0) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => const ToDo()),
  //         );
  //       }
  //       if (index == 1) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => const Contacts()),
  //         );
  //       }
  //       if (index == 2) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => const CompleteTasks()),
  //         );
  //       }
  //     },
  //     currentIndex: myIndex,
  //     items: [
  //       BottomNavigationBarItem(
  //         icon: Container(
  //           //color: homeColor,
  //           child: const Icon(Icons.home),
  //         ),
  //         label: 'ToDo',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Container(
  //           //color: contactsColor,
  //           child: const Icon(Icons.people),
  //         ),
  //         label: 'Contacts',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Container(
  //           color: completeColor,
  //           child: const Icon(Icons.done),
  //         ),
  //         label: 'Complete',
  //       ),
  //     ],
  //     selectedItemColor: Colors.white,
  //   ),
  //  );
//   }
// }

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
        '$ip/CompleteTask?userid=${loggedInUser!.id}',
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
        setState(() {
          
        });
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
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Center(child: Text("Complete Task")),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const ToDo()), // Replace ToDo() with the actual widget for your ToDo screen
            );
          },
        ),
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
                        color: Colors.tealAccent,
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
    );
  }
}
