import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Global.dart';
import '../Model/contactsAdding.dart';
import '../Model/contactsmodel.dart';
import 'Contacts.dart';

class Add_Contacts extends StatefulWidget {
  final int Friendof;

  const Add_Contacts({
    Key? key,
    required this.Friendof,
  }) : super(key: key);

  @override
  _Add_ContactsState createState() => _Add_ContactsState();
}

class _Add_ContactsState extends State<Add_Contacts> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController relationTypeController = TextEditingController();

  String _name = "";
  String _phoneNumber = "";
  String _relationshipType = "";
  List<Contactmodel> contact = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<bool> addContact(contactsAdding contact) async {
    try {
      final response = await http.post(
        Uri.parse('$ip/AddFriend'),
        body: jsonEncode(contact.toMap()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Contact added successfully!');
        print('Response: ${response.body}');
        return true;
      } else {
        print('Failed to add contact. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error during contact addition: $e');
      return false;
    }
  }

  Future<List<Contactmodel>> fetchData() async {
    final dio = Dio();

    try {
      final response = await dio.get('$ip/GetAllUsers');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;

        List<Contactmodel> contactList =
            data.map((item) => Contactmodel.fromMap(item)).toList();

        setState(() {
          isLoading = false;
          contact = contactList;
        });

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("Contact Form"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Contacts()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: phoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phoneNumber = value!;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: relationTypeController,
                decoration: const InputDecoration(
                  labelText: 'Relationship Type',
                  hintText: 'Friends or Family',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a relationship type';
                  }
                  return null;
                },
                onSaved: (value) {
                  _relationshipType = value!;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  _submitForm();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Contactmodel existingUser = contact.firstWhere(
        (contact) => contact.PhoneNumber == _phoneNumber,
        orElse: () => Contactmodel(UserId: -1),
      );

      if (existingUser.UserId != -1) {
        int searchingUserId = getCurrentUserId();
        int? existingUserId = existingUser.UserId;

        print('My ID: $searchingUserId');
        print('Existing User ID: $existingUserId');
        contactsAdding b = contactsAdding(
          Friendof: loggedInUser?.id ?? -1,
          Friend: existingUserId,
          Type: relationTypeController.text,
        );

        bool taskSave = await addContact(b);
        print("Task saved: $taskSave");
        if (taskSave) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Contacts()),
          );
        } else {
          print("Contact addition failed");
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('User Not Exists'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      'The user with the phone number $_phoneNumber does not exist in the database.'),
                  const SizedBox(height: 10),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  int getCurrentUserId() {
    return loggedInUser!.id ?? -1;
  }
}
