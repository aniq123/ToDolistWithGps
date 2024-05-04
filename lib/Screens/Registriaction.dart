import 'package:flutter/material.dart';
import 'package:flutter_application_22/Global.dart';
import 'package:flutter_application_22/Screens/loginScreen.dart';
import 'package:http/http.dart' as http;

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  var fullNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneNumberController = TextEditingController();

  Future<bool> register(
      String name, String email, String password, String phoneNumber) async {
    try {
      //Taskmodel t=Taskmodel(taskId: 0, taskTitle: taskTitle, taskDueTime: taskDueTime, taskBeforeTime: taskBeforeTime, taskRepeat: taskRepeat)
      final response = await http.post(
        Uri.parse('$ip/SignUp'),
        body: {
          'UserEmail': name,
          'UserName': email,
          'UserPassword': password,
          'UserPhoneNumber': phoneNumber,
        },
      );

      if (response.statusCode == 200) {
        // Request was successful, handle the response data if needed
        print('Registration successful!');
        print('Response: ${response.body}');
        return true; // Indicate successful registration
      } else {
        // Request failed, handle the error
        print('Failed to register. Status code: ${response.statusCode}');
        return false; // Indicate failed registration
      }
    } catch (e) {
      // An error occurred during the request
      print('Error during registration: $e');
      return false; // Indicate failed registration
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(52, 255, 214, 1),
      body: Center(
        child: Container(
          width: 300,
          height: 600,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "We Are So Glad You Are Here",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),
              const Text(
                "Let's Work Together To Ensure Your Tasks Are Completed",
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 15.0),
              SizedBox(
                width: 500.0,
                height: 50.0,
                child: TextField(
                  controller: fullNameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Your Full Name ',
                    labelText: 'Full Name ',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey,
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              SizedBox(
                width: 500.0,
                height: 50.0,
                child: TextField(
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
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 500.0,
                height: 50.0,
                child: TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Your password',
                    labelText: 'password',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey,
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const SizedBox(
                width: 500.0,
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 500.0,
                height: 50.0,
                child: TextField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter Your Phone Number',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey,
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),

              ElevatedButton(
                onPressed: () async {
                  bool registrationSuccessful = await register(
                    emailController.text.toString(),
                    fullNameController.text.toString(),
                    passwordController.text.toString(),
                    phoneNumberController.text.toString(),
                  );

                  if (registrationSuccessful) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const loginScreen()),
                    );
                  } else {
                    print("Registration Failed");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey, // Set button color
                ),
                child: const Text("Registration"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const loginScreen()),
                  );
                },
                child: const Text("Login"),
              )

              // ... (your existing widgets)
            ],
          ),
        ),
      ),
    );
  }
}
