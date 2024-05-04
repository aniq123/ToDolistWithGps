import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_22/Global.dart' as glob;
import 'package:flutter_application_22/Model/taskmodel.dart';
import 'package:flutter_application_22/Screens/MapPage.dart';
import 'package:flutter_application_22/Screens/ToDo.dart';
import 'package:flutter_custom_selector/flutter_custom_selector.dart' as sector;
import 'package:intl/intl.dart';

import '../Global.dart';
import '../Model/contactsgetting.dart';

class TaskSharing extends StatefulWidget {
  const TaskSharing({super.key});

  @override
  State<TaskSharing> createState() => _TaskSharingState();
}

Future<bool> task(Taskmodel t) async {
  try {
    //Taskmodel t=Taskmodel(taskId: 0,
    //taskTitle: taskTitle,
    //taskDueTime: taskDueTime,
    // taskBeforeTime: taskBeforeTime, taskRepeat: taskRepeat)
    FormData data = FormData.fromMap(t.toMap());
    final response = await Dio().post(
      '${glob.ip}/SaveTasksData',
      data: data,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      glob.latitude = null;
      glob.longitude = null;
      // Request was successful, handle the response data if needed
      print('Task successful!');
      print('Response: ${response.data}');
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

class _TaskSharingState extends State<TaskSharing> {
  @override
  void initState() {
    super.initState();
    dateController.text = "";
    timeController.text = "";
  }

  TextEditingController RemindsmeCONTROLLER = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController firstDateController = TextEditingController();
  TextEditingController lastDateController = TextEditingController();
  TextEditingController firstTimeController = TextEditingController();
  TextEditingController lastTimeController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController repeatIntervalCONTROLLER = TextEditingController();
  TextEditingController friendscontroller = TextEditingController();
  //String repeatValue = 'Daily'; // Default value for the repeat dropdown
  String repeatInterval =
      '5 min'; // Default value for the repeat interval dropdown
  String repeatValue = 'Daily';
  bool isDateEnabled = false;
  bool isDateInRangeEnabled = false;
  bool isTimeEnabled = false;
  bool isTimeInRangeEnabled = false;
  List<String> selectedDays = [];
  List<FriendDetails> selectedContacts = [];
  Map<String, String> namesToNumbers = {};
  final String _searchQuery = '';
  final List<String> _searchResults = [];

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

  DateTime? pickeddueTimeOfDay;
  DateTime? pickedfirstTimeOfDay;
  DateTime? pickedlastTimeOfDay;
  List<FriendDetails>? contactList = [];
  Future<List<FriendDetails>> fetchFriendDetails() async {
    contactList!.clear();
    final dio = Dio();

    try {
      final response =
          await dio.get('$ip/GetFriends?userid=${loggedInUser!.id}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;

        contactList = data.map((item) => FriendDetails.fromMap(item)).toList();
        print(contactList);
        return contactList!;
      } else {
        print('Failed to load tasks. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  List<String>? officers;
  Map<String, int>? officerIds;
  List<int>? selectedOfficersIds = [];

  Future<Map<String, int>> fetchOfficersWithIds() async {
    try {
      final response =
          await Dio().get('$ip/GetFriends?userid=${loggedInUser!.id}');

      if (response.statusCode == 200) {
        final List<dynamic> officersJson = response.data as List<dynamic>;

        final Map<String, int> officers = {};
        officersJson.forEach((officer) {
          if (officer is Map<String, dynamic>) {
            final int? friendId = officer['FriendId'] as int?;
            final String? friendName = officer['FriendName'] as String?;

            if (friendId != null && friendName != null) {
              officers[friendName] = friendId;
            }
          }
        });
        print(officers);
        return officers;
      } else {
        throw Exception('Failed to fetch officers');
      }
    } catch (e) {
      throw Exception('Error decoding JSON: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(52, 255, 214, 1),
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: const Center(child: Text("Task Sharing")),
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
        body: SingleChildScrollView(
            child: SizedBox(
          child: Column(
            children: [
              // const Padding(padding: EdgeInsets.only(bottom: 50)),
              TextFormField(
                controller: RemindsmeCONTROLLER,
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
                                    DateFormat("yyyy-MM-dd").format(pickedDate);
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
              const SizedBox(
                height: 5.0,
              ),
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
                    height: 5,
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
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
                                    timeController.text =
                                        DateFormat.jm().format(pickedDateTime);
                                  });
                                } else {
                                  print("Not Selected");
                                }
                              }
                            : null,
                      ),
                    ),
                  ),

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
                height: 5,
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

              const SizedBox(
                height: 5.0,
              ),
              // Repeat dropdown
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
              const SizedBox(
                height: 5.0,
              ),
              // Repeat interval dropdown
              TextField(
                controller: TextEditingController(text: repeatInterval),
                decoration: InputDecoration(
                  labelText: 'Repeat Interval',
                  filled: true,
                  prefixIcon: const Icon(Icons.access_time),
                  suffixIcon: DropdownButton<String>(
                    value: repeatInterval,
                    onChanged: (String? newValue) {
                      setState(() {
                        repeatInterval = newValue!;
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

              const SizedBox(
                height: 5.0,
              ),
              // TextFormField(
              //   controller: friendscontroller,
              //   decoration: const InputDecoration(
              //     labelText: 'Shared with people',
              //     filled: true,
              //     fillColor: Colors.white,
              //     prefixIcon: Icon(Icons.assignment_ind_sharp),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //     ),
              //   ),
              //   onTap: () async {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const Contacts(),
              //       ),
              //     ).then((value) {
              //       // Handle the selected contacts returned from the Contacts screen
              //       if (value != null && value is List<FriendDetails>) {
              //         setState(() {
              //           selectedContacts = value;
              //         });
              //       }
              //     });
              //   },
              // ),

              FutureBuilder<Map<String, int>>(
                future: fetchOfficersWithIds(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    officerIds = snapshot.data;
                    officers = officerIds!.keys.toList();
                    return sector.CustomMultiSelectField<dynamic>(
                      // Change the type to dynamic
                      title: 'Contacts',
                      items: officers!,
                      onSelectionDone: (List<dynamic>? selectedValues) {
                        if (selectedValues != null) {
                          // Handle multiple selections here
                          selectedOfficersIds = selectedValues
                              .map((value) => officerIds![value.toString()]!)
                              .toList();

                          setState(() {});
                          print("Selected Officer IDs: $selectedOfficersIds");
                        }
                      },
                      itemAsString: (item) => item.toString(),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Error fetching officers data');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              // FutureBuilder<List<FriendDetails>>(
              //   future: fetchFriendDetails(),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       // While the future is still running, show a loading indicator or placeholder.
              //       return const CircularProgressIndicator(); // You can replace this with your loading widget.
              //     } else if (snapshot.hasError) {
              //       // If there's an error, handle it here.
              //       return Text('Error: ${snapshot.error}');
              //     } else {
              //       // If the Future is complete, use the result to populate the SearchField.
              //       List<FriendDetails> friendDetails = snapshot.data ?? [];

              //       return SearchField(
              //         suggestions: friendDetails
              //             .map(
              //               (friend) => SearchFieldListItem(
              //                 friend.FriendId.toString(),
              //                 child: Align(
              //                   alignment: Alignment.centerRight,
              //                   child: Padding(
              //                     padding: const EdgeInsets.symmetric(
              //                         horizontal: 16.0),
              //                     child: Text(
              //                       friend.FriendName,
              //                       style: const TextStyle(color: Colors.red),
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             )
              //             .toList(),
              //         controller: friendscontroller,
              //       );
              //     }
              //   },
              // ),

              // TextFormField(
              //   controller: friendscontroller,
              //   onChanged: (name) async {
              //     // Call the API to fetch friend details
              //     List<FriendDetails> friendDetails =
              //         await fetchFriendDetails();

              //     // Filter the friend details based on the entered name
              //     List<FriendDetails> filteredFriends = friendDetails
              //         .where((friend) => friend.FriendId.toString()
              //             .contains(name.toLowerCase()))
              //         .toList();

              //     // If there is only one match, update the UI with the phone number
              //     if (filteredFriends.length == 1) {
              //       setState(() {
              //         friendscontroller.value =
              //             friendscontroller.value.copyWith(
              //           text: filteredFriends[0].FriendPhoneNumber,
              //         );
              //       });
              //     } else {
              //       // If there are multiple matches or no matches, you can handle it accordingly
              //       // For example, you might want to display a suggestion list or clear the phone number
              //     }
              //   },
              //   decoration: const InputDecoration(
              //     labelText: 'Shared with people',
              //     filled: true,
              //     fillColor: Colors.white,
              //     prefixIcon: Icon(Icons.assignment_ind_sharp),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //     ),
              //   ),
              // ),

              const SizedBox(
                height: 10.0,
              ),
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

                      print(
                          'Latitude: ${glob.latitude}, Longitude: ${glob.longitude}');
                    } else {
                      // Handle the case where the user dismissed the MapPage without selecting a location.
                      print(
                          'User dismissed MapPage without selecting a location.');
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

              const Padding(padding: EdgeInsets.all(3)),
              ElevatedButton(
                onPressed: () async {
                  if (RemindsmeCONTROLLER.text != "" &&
                      glob.loggedInUser?.id != "") {
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
                      TasksStatus: 1,
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
                      //TaskLatitude: glob.latitude,
                      // TaskLongitude: glob.longitude,
                      Friends: selectedOfficersIds,
                      complete: false,
                    );
                    bool TaskSave = await task(a);
                    print("tASK SAVED:   $TaskSave");
                    if (TaskSave) {
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ToDo()),
                      );
                    } else {
                      print("Registration Failed");
                    }
                    // Your logic for saving the task
                  } else {}
                },
                child: const Text('Save'),
              ),
            ],
          ),
        )));
  }
}
