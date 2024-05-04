import 'package:flutter/material.dart';
import 'package:flutter_application_22/Screens/ToDo.dart';

class AssignedToOthersPage extends StatefulWidget {
  const AssignedToOthersPage({super.key});

  @override
  State<AssignedToOthersPage> createState() => _AssignedToOthersPageState();
}

class _AssignedToOthersPageState extends State<AssignedToOthersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Center(child: Text("Assign to me")),
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
    );
  }
}
