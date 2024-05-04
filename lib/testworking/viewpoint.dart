import 'package:flutter/material.dart';

class ViewPoint extends StatefulWidget {
  const ViewPoint({Key? key}) : super(key: key);

  @override
  State<ViewPoint> createState() => _ViewPointState();
}

class _ViewPointState extends State<ViewPoint> {
  late Future<String>? _future; // Change the type here

  @override
  void initState() {
    super.initState();
  // _future = SharedPreferences.getInstance().then((pres) => pres.getString('name'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Shared Prefs"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder<String>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                String? savedName = snapshot.data;
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text('Saved Name: $savedName'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
