import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_22/Global.dart' as glob;
import 'package:flutter_application_22/Model/taskmodel.dart';
import 'package:flutter_application_22/Screens/MapPage.dart';
import 'package:flutter_application_22/Screens/ToDo.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Tasks extends StatefulWidget {
  //  const Tasks( {Key? key}) : super(key: key);
  // const Tasks(Taskmodel? t, {Key? key}) : super(key: key);
  Taskmodel? t;
  Tasks({Key? key, this.t}) : super(key: key);

  // Tasks(Taskmodel? task) {
  //   t = task!;
  //   if(t!=null){
  //     reminderval = t.TaskTitle;
  //   }

  // }

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  TextEditingController RemindsmeCONTROLLER = TextEditingController();
  TextEditingController dateController = TextEditingController();

  TextEditingController timeController = TextEditingController();
  //DateTime? timeController1;
  TextEditingController firstDateController = TextEditingController();
  TextEditingController lastDateController = TextEditingController();
  TextEditingController firstTimeController = TextEditingController();
  //DateTime? firstTimeController1;
  TextEditingController lastTimeController = TextEditingController();
  //DateTime? lastTimeController1;
  TextEditingController repeatIntervalCONTROLLER = TextEditingController();

  Future<bool> task(Taskmodel t) async {
    try {
      //Taskmodel t=Taskmodel(taskId: 0,
      //taskTitle: taskTitle,
      //taskDueTime: taskDueTime,
      // taskBeforeTime: taskBeforeTime, taskRepeat: taskRepeat)
      final response = await http.post(
        Uri.parse('${glob.ip}/SaveOWNTasksData'),
        body: jsonEncode(t.toMap()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Request was successful, handle the response data if needed
        print('Task successful!');
        print('Response: ${response.body}');
        return true; // Indicate successful registration
      } else {
        // Request failed, handle the error
        print('Failed to Save Task. Status code: ${response.statusCode}');
        return false; // Indicate failed registration
      }
    } catch (e) {
      // An error occurred during the request
      print('Error during Task Saving: $e');
      return false; // Indicate failed registration
    }
  }

  List<String> selectedDays = [];

  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2022, 11, 5),
    end: DateTime(2022, 11, 24),
  );
  String repeatValue = 'Daily';
  String repeatInterval = '5 min';
  bool isDateEnabled = false;
  bool isTimeEnabled = false;
  bool isDateInRangeEnabled = false;
  bool isTimeInRangeEnabled = false;

  @override
  void initState() {
    super.initState();
    dateController.text = "";
    timeController.text = "";
    firstDateController.text = "";
    lastDateController.text = "";
    if (widget.t != null) {
      RemindsmeCONTROLLER.text = widget.t!.TaskTitle ?? '';
      dateController.text = widget.t!.TaskDueDate.toString() ?? '';
      timeController.text = widget.t!.TaskDueTime.toString() ?? '';
      firstTimeController.text = widget.t!.FirstTime.toString() ?? '';
      lastTimeController.text = widget.t!.LastTime.toString() ?? '';
      firstDateController.text = widget.t!.Firstdate.toString() ?? '';
      lastDateController.text = widget.t!.Lastdate.toString() ?? '';
      //repeatInterval = widget.t!.TaskRepeat.toString() ?? '';
    }
  }

  void _showRepeatOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Repeat Options',
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16.0),
              ListTile(
                title: const Text('Daily'),
                onTap: () {
                  _setRepeatValue('Daily');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Weekly'),
                onTap: () {
                  _showDaysPicker(context);
                },
              ),
              ListTile(
                title: const Text('Monthly'),
                onTap: () {
                  _setRepeatValue('Monthly');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _setRepeatValue(String value) {
    setState(() {
      repeatValue = value;
    });
  }

  void _showDaysPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Days'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                for (String day in [
                  'Sunday',
                  'Monday',
                  'Tuesday',
                  'Wednesday',
                  'Thursday',
                  'Friday',
                  'Saturday'
                ])
                  ListTile(
                    title: Text(day),
                    tileColor: selectedDays.contains(day)
                        ? Colors.blue.withOpacity(0.5)
                        : null,
                    onTap: () {
                      setState(() {
                        if (selectedDays.contains(day)) {
                          selectedDays.remove(day);
                        } else {
                          selectedDays.add(day);
                        }
                      });
                    },
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToMapPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapPage(),
      ),
    );
  }

  DateTime? pickeddueTimeOfDay;
  DateTime? pickedfirstTimeOfDay;
  DateTime? pickedlastTimeOfDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(52, 255, 214, 1),
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: const Center(child: Text("Task")),
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

        // Other widget properties go here

        body: SingleChildScrollView(
          child: SizedBox(
            child: Column(
              children: [
                // const Padding(padding: EdgeInsets.only(bottom: 50)),

                TextFormField(
                  controller: RemindsmeCONTROLLER,
                  //valueBuilder = reminderval();
                  //initialValue: reminderval,
                  maxLength: 50,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: "Reminds Me To Todo",
                    hintStyle: TextStyle(color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),

                //      const SizedBox(height: 10.0),
                // ignore: avoid_unnecessary_containers
                Row(
                  children: [
                    SizedBox(
                      width: 300,
                      child: GestureDetector(
                        onTap: isDateEnabled
                            ? () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000, 1, 1),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  String formattedDate =
                                      DateFormat("yyyy-MM-dd")
                                          .format(pickedDate);
                                  setState(() {
                                    dateController.text = formattedDate ?? "";
                                  });
                                } else {
                                  print("Not Selected");
                                }
                              }
                            : null,
                        child: SizedBox(
                          width: 1200,
                          child: Container(
                            child: TextFormField(
                              controller: dateController,
                              decoration: const InputDecoration(
                                labelText: 'Date',
                                filled: true,
                                prefixIcon: Icon(Icons.calendar_today),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                ),
                                fillColor: Colors.white,
                                labelStyle: TextStyle(color: Colors.black),
                              ),
                              readOnly: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Text(''),
                    Switch(
                      value: isDateEnabled,
                      onChanged: (value) {
                        setState(() {
                          isDateEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
                //const SizedBox(height: 10.0),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    SizedBox(
                      width: 300,
                      child: SizedBox(
                        width: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: firstDateController,
                                decoration: const InputDecoration(
                                  labelText: 'First Date',
                                  filled: true,
                                  prefixIcon: Icon(Icons.calendar_today),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                  ),
                                  fillColor: Colors.white,
                                  labelStyle: TextStyle(color: Colors.black),
                                ),
                                readOnly: !isDateInRangeEnabled,
                                onTap: isDateInRangeEnabled
                                    ? () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000, 1, 1),
                                          lastDate: DateTime(2100),
                                        );
                                        if (pickedDate != null) {
                                          String formattedDate =
                                              DateFormat("yyyy-MM-dd")
                                                  .format(pickedDate);
                                          setState(() {
                                            firstDateController.text =
                                                formattedDate ?? "";
                                          });
                                        } else {
                                          print("Not Selected");
                                        }
                                      }
                                    : null,
                              ),
                            ),
                            // const SizedBox(width: 10.0),
                            Expanded(
                              child: TextFormField(
                                controller: lastDateController,
                                decoration: const InputDecoration(
                                  labelText: 'Last Date',
                                  filled: true,
                                  prefixIcon: Icon(Icons.calendar_today),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                  ),
                                  fillColor: Colors.white,
                                  labelStyle: TextStyle(color: Colors.black),
                                ),
                                readOnly: !isDateInRangeEnabled,
                                onTap: isDateInRangeEnabled
                                    ? () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000, 1, 1),
                                          lastDate: DateTime(2100),
                                        );
                                        if (pickedDate != null) {
                                          String formattedDate =
                                              DateFormat("yyyy-MM-dd")
                                                  .format(pickedDate);
                                          setState(() {
                                            lastDateController.text =
                                                formattedDate ?? "";
                                          });
                                        } else {
                                          print("Not Selected");
                                        }
                                      }
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Text(''),
                    Switch(
                      value: isDateInRangeEnabled,
                      onChanged: (value) {
                        setState(() {
                          isDateInRangeEnabled = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 300,
                      child: SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: timeController,
                          decoration: const InputDecoration(
                            labelText: 'Time',
                            filled: true,
                            prefixIcon: Icon(Icons.access_time),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                            fillColor: Colors.white,
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          readOnly: !isTimeEnabled,
                          onTap: isTimeEnabled
                              ? () async {
                                  TimeOfDay? pickedTimeOfDay =
                                      await showTimePicker(
                                    context: context,
                                    initialTime:
                                        TimeOfDay.fromDateTime(DateTime.now()),
                                    helpText: 'Select Time',
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: false,
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );

                                  if (pickedTimeOfDay != null) {
                                    // Use the format method for a more readable display
                                    DateTime now = DateTime.now();
                                    DateTime pickedDateTime = DateTime(
                                      now.year,
                                      now.month,
                                      now.day,
                                      pickedTimeOfDay.hour,
                                      pickedTimeOfDay.minute,
                                    );
                                    // Assign picked time directly to the controller
                                    setState(() {
                                      pickeddueTimeOfDay = pickedDateTime;
                                      timeController.text = DateFormat.jm()
                                          .format(pickedDateTime);
                                    });
                                  } else {
                                    print("Not Selected");
                                  }
                                }
                              : null,
                        ),
                      ),
                    ),

///////
                    ///
                    ///
                    ///
                    const Text(''),
                    Switch(
                      value: isTimeEnabled,
                      onChanged: (value) {
                        setState(() {
                          isTimeEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),

                Row(
                  children: [
                    const SizedBox(height: 10.0),
                    SizedBox(
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: firstTimeController,
                              decoration: const InputDecoration(
                                labelText: 'First Time',
                                filled: true,
                                prefixIcon: Icon(Icons.access_time),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                ),
                                fillColor: Colors.white,
                                labelStyle: TextStyle(color: Colors.black),
                              ),
                              readOnly: !isTimeInRangeEnabled,
                              onTap: isTimeInRangeEnabled
                                  ? () async {
                                      TimeOfDay? pickedTimeOfDay =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(
                                            DateTime.now()),
                                        helpText: 'Select Time',
                                        builder: (BuildContext context,
                                            Widget? child) {
                                          return MediaQuery(
                                            data:
                                                MediaQuery.of(context).copyWith(
                                              alwaysUse24HourFormat: false,
                                            ),
                                            child: child!,
                                          );
                                        },
                                      );

                                      if (pickedTimeOfDay != null) {
                                        // Use the format method for a more readable display
                                        DateTime now = DateTime.now();
                                        DateTime pickedDateTime = DateTime(
                                          now.year,
                                          now.month,
                                          now.day,
                                          pickedTimeOfDay.hour,
                                          pickedTimeOfDay.minute,
                                        );

                                        // Assign picked time directly to the controller
                                        setState(() {
                                          pickedfirstTimeOfDay = pickedDateTime;
                                          firstTimeController.text =
                                              DateFormat.jm()
                                                  .format(pickedDateTime);
                                        });
                                      } else {
                                        print("Not Selected");
                                      }
                                    }
                                  : null,
                            ),
                          ),
                          //     const SizedBox(width: 10.0),
                          Expanded(
                            child: TextFormField(
                              controller: lastTimeController,
                              decoration: const InputDecoration(
                                labelText: 'Last Time',
                                filled: true,
                                prefixIcon: Icon(Icons.access_time),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                ),
                                fillColor: Colors.white,
                                labelStyle: TextStyle(color: Colors.black),
                              ),
                              readOnly: !isTimeInRangeEnabled,
                              onTap: isTimeInRangeEnabled
                                  ? () async {
                                      TimeOfDay? pickedTimeOfDay =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(
                                            DateTime.now()),
                                        helpText: 'Select Time',
                                        builder: (BuildContext context,
                                            Widget? child) {
                                          return MediaQuery(
                                            data:
                                                MediaQuery.of(context).copyWith(
                                              alwaysUse24HourFormat: false,
                                            ),
                                            child: child!,
                                          );
                                        },
                                      );

                                      if (pickedTimeOfDay != null) {
                                        // Use the format method for a more readable display
                                        DateTime now = DateTime.now();
                                        DateTime pickedDateTime = DateTime(
                                          now.year,
                                          now.month,
                                          now.day,
                                          pickedTimeOfDay.hour,
                                          pickedTimeOfDay.minute,
                                        );

                                        // Assign picked time directly to the controller
                                        setState(() {
                                          pickedlastTimeOfDay = pickedDateTime;
                                          lastTimeController.text =
                                              DateFormat.jm()
                                                  .format(pickedDateTime);
                                        });
                                      } else {
                                        print("Not Selected");
                                      }
                                    }
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(''),
                    Switch(
                      value: isTimeInRangeEnabled,
                      onChanged: (value) {
                        setState(() {
                          isTimeInRangeEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                GestureDetector(
                  onTap: () {
                    _showRepeatOptions(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.blue, // Customize the color as needed
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Repeat: $repeatValue',
                            style: const TextStyle(color: Colors.white)),
                        const Icon(Icons.arrow_drop_down, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: repeatIntervalCONTROLLER,
                  decoration: InputDecoration(
                    labelText: 'SNOOZE',
                    filled: true,
                    prefixIcon: const Icon(Icons.access_time),
                    suffixIcon: DropdownButton<String>(
                      value: repeatInterval,
                      onChanged: (String? newValue) {
                        setState(() {
                          repeatInterval = newValue!;
                          repeatIntervalCONTROLLER.text = repeatInterval;
                        });
                      },
                      items: <String>['5 min', '10 min', '15 min']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    fillColor: Colors.white,
                    labelStyle: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 10.0),
                GestureDetector(
                    onTap: () async {
     var targetLOC = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapPage(),
      ),
    );

    if (targetLOC != null) {
      List<String> latLngList = targetLOC.split(',');

      glob.latitude = double.tryParse(latLngList[0]) ?? 0.0;
      glob.longitude = double.tryParse(latLngList[1]) ?? 0.0;

      print('Latitude: ${glob.latitude}, Longitude: ${glob.longitude}');
    } else {
      // Handle the case where the user dismissed the MapPage without selecting a location.
      print('User dismissed MapPage without selecting a location.');
    }
                    },
                    child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const Text(
                          'Add Locations',
                          style: TextStyle(fontSize: 18.0),
                        ))),

                const Padding(padding: EdgeInsets.all(20)),
                ElevatedButton(
                  onPressed: () async {
                    // print(loggedInUser.email);
                    // print(loggedInUser!.id);

                    //  else {
                    //   print('Invalid format for latitude and longitude.');
                    // }
                    Taskmodel a = Taskmodel(
                      TaskId: 0,
                      TaskTitle: RemindsmeCONTROLLER.text,

                      createdby: glob.loggedInUser?.id,
                      // TaskDueDate: dateController.text != null ||
                      //         dateController.text == ''
                      //     ? DateTime.parse(dateController.text)
                      //     : null,
                      Firstdate: firstDateController.text != null ||
                              firstDateController.text == ''
                          ? DateTime.parse(firstDateController.text)
                          : null,
                      Lastdate: lastDateController.text != null ||
                              lastDateController.text == ''
                          ? DateTime.parse(lastDateController.text)
                          : null,
                      TaskBeforeTime: repeatIntervalCONTROLLER.text,
                      TaskRepeat: selectedDays.join(','),
                      TasksStatus: 0,
                      TaskDueTime:
                          pickeddueTimeOfDay != "" && pickeddueTimeOfDay != Null
                              ? pickeddueTimeOfDay
                              : null,
                      FirstTime: pickedfirstTimeOfDay != "" &&
                              pickedfirstTimeOfDay != Null
                          ? pickedfirstTimeOfDay
                          : null,
                      LastTime: pickedlastTimeOfDay != "" &&
                              pickedlastTimeOfDay != Null
                          ? pickedlastTimeOfDay
                          : null,
                      TaskLatitude: glob.latitude,
                      TaskLongitude: glob.longitude,
                      complete: false,
                    );
                    // ignore: non_constant_identifier_names
                    bool TaskSave = await task(a);
                    print("TASK SAVED:   $TaskSave");
                    if (TaskSave) {
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ToDo()),
                      );
                    } else {
                      print("Registration Failed");
                    }
                  },
                  //     RemindsmeCONTROLLER.text.toString(),
                  //     dateController.text.toString(),
                  //     timeController.text.toString(),
                  //     firstDateController.text.toString(),
                  //     lastDateController.text.toString(),
                  //     firstTimeController.text.toString(),
                  //     lastTimeController.text.toString(),
                  //     repeatIntervalCONTROLLER.text.toString()
                  // );
                  //Your logic for saving the task

                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ));
  }
}
