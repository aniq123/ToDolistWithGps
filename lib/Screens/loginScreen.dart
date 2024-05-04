import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_22/Screens/ToDo.dart';
import 'package:http/http.dart' as http;

import '../Global.dart';
import '../Model/UserModel.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  Timer? timer;
  void MonitorAcceptnce() {
    timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      // not accepted tak
      // change tak tatu to dicard
    });
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // working on login
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.get(
        Uri.parse('$ip/LogIn?email=$email&pass=$password'),
      );

      if (response.statusCode == 200) {
        // Request was successful, handle the response data if needed
        print('LOGIN successful!');
        print('Response: ${response.body}');
        if (response.body != "Log in failed") {
          loggedInUser = User.fromJson(response.body);
        }
        return true; // Indicate successful registration
      } else {
        // Request failed, handle the error
        print('Failed to LOGIN. Status code: ${response.statusCode}');
        return false; // Indicate failed registration
      }
    } catch (e) {
      // An error occurred during the request
      print('Error during LOGIN: $e');
      return false; // Indicate failed registration
    }
  }

  //var authcontroller = Get.put(AuthController());

  //   bool isObscure=true;

  // Future<void> checkLogin() async {
  //   String Email = emailController.text;
  //   String password = passwordController.text;

  //   if (Email.isEmpty || password.isEmpty) {
  //     print('NO selected');
  //     return ;
  //   }
  //   try{
  //     print(Email+password);
  //     var response=await APIHandler.LogIn(Email, password);
  //     print(response);
  //     if (response !=null) {
  //       print('Data submitted successfully');
  //       print(response);
  //       //if (response.isNotEmpty) {
  //         var responseData = response;
  //         //String userRole = responseData['role'];
  //         //String name=responseData['username'];
  //         //if (userRole == 'Admin') {
  //           showDialog(
  //             context: context,
  //             builder: (BuildContext context) {
  //               return AlertDialog(
  //                 title: Text('Login Successful'),
  //                 //content: Text('You are now logged in as ${responseData['username']} And Role of that person is ${responseData['role']}'),
  //                 actions: <Widget>[
  //                   TextButton(
  //                     onPressed: () {
  //                       Navigator.of(context).pop();
  //                       setState(() {

  //                         Navigator.of(context).pushReplacement(
  //                           MaterialPageRoute(builder: (context){
  //                             return ToDo();
  //                           })
  //                         );
  //                       });
  //                     },
  //                     child: Text('OK'),
  //                   ),
  //                 ],
  //               );
  //             },
  //           );
  //         }

  //       else {
  //         showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: Text('Login Failed'),
  //               content: Text('Invalid username or password. Please try again.'),
  //               actions: <Widget>[
  //                 TextButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Text('OK'),
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //       }
  //     }
  //   catch (e) {
  //     print('Error submitting form: $e');
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(52, 255, 214, 1),
        body: SizedBox(
          child: Center(
            child: Container(
              width: 300,
              height: 600,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black), // Add a border here
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "IT'S GOOD TO HAVE YOU BACK",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Your Email Address',
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey,
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Your Password',
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey,
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  ElevatedButton(
                    onPressed: () async {
                      bool LOGINSuccessful = await login(
                        emailController.text.toString(),
                        passwordController.text.toString(),
                      );

                      if (LOGINSuccessful) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const ToDo()),
                        );
                      } else {
                        print("Registration Failed");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Set button color
                    ),
                    child: const Text("Log In"),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
