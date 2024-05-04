import 'package:flutter/material.dart';
import 'package:flutter_application_22/testworking/viewpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';

class sharedprefs extends StatefulWidget {
  const sharedprefs({super.key});

  @override
  State<sharedprefs> createState() => _sharedprefsState();
}

class _sharedprefsState extends State<sharedprefs> {
   var nameController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Shared prefs")),
      
      ),
      body:  Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(

              hintText: "Enter Name",
              border: OutlineInputBorder(
                //color:Colors.black,
              )
            ),
         ),

        const SizedBox(height: 10.0,),
        ElevatedButton( onPressed: ()async {
          //Save the entered name of prefs0-
          SharedPreferences prefs=await SharedPreferences.getInstance();
          prefs.setString('name', nameController.text);
          Navigator.push(context,
          MaterialPageRoute(builder: (context)=>const ViewPoint()));
        }, child: const Text("Save"))
        ]  
          ),
    );
        
      
  }
}