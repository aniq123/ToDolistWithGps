import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_22/Global.dart';
import 'package:flutter_application_22/Model/contactsgetting.dart';
import 'package:flutter_application_22/Screens/Add_Contacts.dart';
import 'package:flutter_application_22/Screens/GeoFanceing.dart';
import 'package:flutter_application_22/Screens/Sharing.dart';
import 'package:flutter_application_22/Screens/ToDo.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  int myIndex = 0;
  Color friendsColor = Colors.blue;

  bool get isLoading => true;

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
                      leading: const Icon(Icons.contact_page),
                      title: const Text('Add Contacts'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Add_Contacts(
                              Friendof: loggedInUser?.id ?? -1,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('Add into Friends'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const sharing()),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  List<FriendDetails> friendDetailsList = [];
  @override
  void initState() {
    super.initState();
    // Fetch friend details from the API when the widget initializes
    fetchFriendDetails();
  }

  Future<List<FriendDetails>> fetchFriendDetails() async {
    final dio = Dio();

    try {
      final response =
          await dio.get('$ip/GetFriends?userid=${loggedInUser!.id}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;

        List<FriendDetails> contactList =
            data.map((item) => FriendDetails.fromMap(item)).toList();

        return contactList;
      } else {
        print('Failed to load tasks. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  // Function to toggle the selection of a contact
  void toggleContactSelection(FriendDetails contact) {
    List<FriendDetails> selectedContacts = [];
    setState(() {
      if (contact.isSelected) {
        selectedContacts.remove(contact);
      } else {
        selectedContacts.add(contact);
      }
      contact.isSelected = !contact.isSelected;
    });

    // Add this line to send the selected contacts back to the previous screen
    Navigator.pop(context, selectedContacts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Contacts")),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<FriendDetails>>(
              future: fetchFriendDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<FriendDetails> contact = snapshot.data ?? [];

                  return Column(
                    children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      const TextField(
                        decoration: InputDecoration(
                          label: Text("Search"),
                          hintStyle: TextStyle(color: Colors.green),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: contact.length,
                          itemBuilder: (context, index) {
                            FriendDetails friendDetails = contact[index];

                            return Container(
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text(
                                  //   'USERID: ${friendDetails.FriendId ?? 'N/A'}',
                                  //   style: const TextStyle(fontSize: 18),
                                  // ),
                                  Text(
                                    'Name: ${friendDetails.FriendName ?? 'N/A'}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    'Phone: ${friendDetails.FriendPhoneNumber ?? 'N/A'}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ToDo()),
            );
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Contacts()),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GeoFencing()),
            );
          }
        },
        currentIndex: myIndex,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              child: const Icon(Icons.home),
            ),
            label: 'ToDo',
          ),
          BottomNavigationBarItem(
            icon: Container(
              color: friendsColor,
              child: const Icon(Icons.people),
            ),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Container(
              child: const Icon(Icons.location_on),
            ),
            label: 'GeoFance',
          ),
        ],
        selectedItemColor: Colors.white,
      ),
    );
  }
}
