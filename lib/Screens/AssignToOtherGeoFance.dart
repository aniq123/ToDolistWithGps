import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_22/Global.dart';
import 'package:flutter_application_22/Model/GeoFancing.dart';
import 'package:flutter_application_22/Screens/ToDo.dart';

class AssignToOtherGeoFance extends StatefulWidget {
  const AssignToOtherGeoFance({super.key});

  @override
  State<AssignToOtherGeoFance> createState() => _AssignToOtherGeoFanceState();
}

class _AssignToOtherGeoFanceState extends State<AssignToOtherGeoFance> {
  @override
  late Future<List<GeoFancing>> _futureTasks;

  @override
  void initState() {
    super.initState();
    _futureTasks = fetchData();
  }

  Future<List<GeoFancing>> fetchData() async {
    final dio = Dio();
    try {
      final response =
          await dio.get('$ip/ShareoutGeofence?userid=${loggedInUser!.id}');
      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        var task = data.map((item) => GeoFancing.fromMap(item)).toList();
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
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Center(child: Text("Assign To Other GeoFance Task")),
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
      body: Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: FutureBuilder<List<GeoFancing>>(
            future: _futureTasks,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No tasks available.'));
              } else {
                List<GeoFancing> tasks = snapshot.data!;
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    // String? GETTaskDueDate =
                    //     tasks[index].TaskDueDate.toString();
                    // List<String> dateTimeParts = GETTaskDueDate.split(' ');
                    // String? dateStr =
                    //     dateTimeParts.isNotEmpty ? dateTimeParts[0] : "";

                    // String? GETFirstDate = tasks[index].Firstdate.toString();
                    // List<String> GETFirstDatePARTS = GETFirstDate.split(' ');
                    // String? firstdatedate = GETFirstDatePARTS.isNotEmpty
                    //     ? GETFirstDatePARTS[0]
                    //     : null; // Make it nullable

                    // String? GETLastDate = tasks[index].Lastdate.toString();
                    // List<String> GETLastDatePARTS = GETLastDate.split(' ');
                    // String? lastdatedate = GETLastDatePARTS.isNotEmpty
                    //     ? GETLastDatePARTS[0]
                    //     : null; // Make it nullable

                    // String? GETDueTime = tasks[index].TaskDueTime == null
                    //     ? null
                    //     : "${tasks[index].TaskDueTime!.hour}:${tasks[index].TaskDueTime!.minute}";
                    // // List<String> GETDue+++++++++++++++++++++TimePARTS = GETDueTime.split(' ');
                    // // String? duetimeTime =
                    // //     GETDueTimePARTS.isNotEmpty && GETDueTimePARTS.length >= 2
                    // //         ? GETDueTimePARTS[1]
                    // //         : "";

                    // String? GETFirstTime = tasks[index].FirstTime == null
                    //     ? null
                    //     : "${tasks[index].FirstTime!.hour}:${tasks[index].FirstTime!.minute}";
                    // // List<String> GETFirstTimePARTS = GETFirstTime.split(' ');
                    // // String? firsttimeTime = GETFirstTimePARTS.isNotEmpty &&
                    // //         GETFirstTimePARTS.length >= 2
                    // //     ? GETFirstTimePARTS[1]
                    // //     : "";

                    // String? GETLastTime = tasks[index].LastTime == null
                    //     ? null
                    //     : "${tasks[index].FirstTime!.hour}:${tasks[index].FirstTime!.minute}";
                    // // List<String> GETLastTimePARTS = GETLastTime.split(' ');
                    // // String? lasttimeTime =
                    // //     GETLastTimePARTS.isNotEmpty && GETDueTimePARTS.length >= 2
                    // //         ? GETLastTimePARTS[1]
                    // //         : "";

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
                          color: Colors.yellow,
                          child: ListTile(
                            title: Text("Title:${tasks[index].Title}"),
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
                                          "TaskStatus:${tasks[index]?.Reached == true ? "Reached Location" : "Not Reached"}"),

                                      // Padding(
                                      //   padding: EdgeInsets.only(left: 200),
                                      //   child: GestureDetector(
                                      //     onTap: () {
                                      //       //Navigate to the Uncompleted Tasks screen
                                      //       Navigator.pushReplacement(
                                      //         context,
                                      //         MaterialPageRoute(
                                      //             builder: (context) =>
                                      //                 Tasks()),
                                      //       );

                                      //       setState(() {});
                                      //     },
                                      //     child: Container(
                                      //       width: 100.0,
                                      //       height: 40.0,
                                      //       decoration: BoxDecoration(
                                      //         borderRadius:
                                      //             BorderRadius.circular(15.0),
                                      //         border: Border.all(
                                      //           width: 5.0,
                                      //           color: Colors.blueAccent,
                                      //         ),
                                      //       ),
                                      //       child: const Center(
                                      //         child: Text(
                                      //           'postpond',
                                      //           style: TextStyle(
                                      //             fontSize: 9.0,
                                      //             fontWeight: FontWeight.bold,
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),

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
