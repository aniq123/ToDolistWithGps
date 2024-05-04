import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_22/Global.dart';
import 'package:flutter_application_22/Global.dart' as glob;
import 'package:flutter_application_22/Model/GeoFancing.dart';
import 'package:flutter_application_22/Model/contactsgetting.dart';
import 'package:flutter_application_22/Screens/MapPage.dart';
import 'package:flutter_application_22/Screens/ToDo.dart';
import 'package:flutter_application_22/Screens/ploygone.dart';
import 'package:http/http.dart' as http;
import 'package:searchfield/searchfield.dart';

class sharing extends StatefulWidget {
  const sharing({Key? key}) : super(key: key);

  @override
  State<sharing> createState() => _sharingState();
}

class _sharingState extends State<sharing> {
  TextEditingController RemindsmeCONTROLLER = TextEditingController();
  TextEditingController friendscontroller = TextEditingController();
  var polygons;
  Future<bool> task(GeoFancing t) async {
    try {
      final response = await http.post(
        Uri.parse('${glob.ip}/SavegeofanceData'),
        body: jsonEncode(t.toMap()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        glob.latitude = null;
        glob.longitude = null;
        print('Task successful!');
        print('Response: ${response.body}');
        return true;
      } else {
        print('Failed to Save Task. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error during Task Saving: $e');
      return false;
    }
  }

  List<FriendDetails>? contactList = [];

  Future<List<FriendDetails>> fetchFriendDetails() async {
    contactList!.clear();
    final dio = Dio();

    try {
      final response =
          await dio.get('${glob.ip}/GetFriends?userid=${loggedInUser!.id}');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(52, 255, 214, 1),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Center(child: Text("Sharing")),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ToDo()),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
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
                const SizedBox(
                  height: 10.0,
                ),
                FutureBuilder<List<FriendDetails>>(
                  future: fetchFriendDetails(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<FriendDetails> friendDetails = snapshot.data ?? [];

                      return Container(
                        child: SearchField(
                          suggestions: friendDetails
                              .map(
                                (friend) => SearchFieldListItem(
                                  friend.FriendId.toString(),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Text(
                                        friend.FriendName,
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          controller: friendscontroller,
                        ),
                      );
                    }
                  },
                ),
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
                      'Add First Locations',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () async {
                    polygons = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const polygone(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Text(
                      'Add Second Location',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // if ((glob.latitude != "") &&
                    //     (glob.longitude != "") &&
                    //     (glob.latitude != null) &&
                    //     (glob.longitude != null)) {
                    GeoFancing a = GeoFancing(
                      Gid: 0,
                      Title: RemindsmeCONTROLLER.text,
                      createdby: glob.loggedInUser?.id,
                      Latitude: glob.longitude,
                      Longitude: glob.latitude,
                      Friends: int.parse(friendscontroller.text),
                      ShareGeofenceStatus: true,
                      Radius: 300,
                      GeofenceStatus: 1,
                      //complete: false,
                      UserId: int.parse(friendscontroller.text),
                      polygone: polygons,
                      Reached: false,
                    );
                    bool TaskSave = await task(a);
                    print("Task saved: $TaskSave");
                    if (TaskSave) {
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ToDo()),
                      );
                    } else {
                      print("Task save failed");
                    }
                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       content: Text("Please select map."),
                    //     ),
                    //   );
                    // }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
