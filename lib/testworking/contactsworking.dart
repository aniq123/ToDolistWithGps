// //import 'package:dio/dio.dart';
// //import 'package:flutter/material.dart';
// //import 'package:flutter_application_22/Screens/Contacts.dart';
// //import 'package:flutter_application_22/Screens/Sharing.dart';
// //import 'package:flutter_application_22/Screens/TaskSharing.dart';
// //import 'package:flutter_application_22/Screens/Tasks.dart';
// //import 'package:flutter_application_22/Screens/ToDo.dart';

// //import '../Global.dart';
// //import '../Model/contactsmodel.dart';

// //class CompleteTasks extends StatefulWidget {
//   //const CompleteTasks({Key? key}) : super(key: key);

//   @override
//  /// /State<CompleteTasks> createState() => _CompleteTasksState();
// //}

// //class _CompleteTasksState extends State<CompleteTasks> {
//   //int myIndex = 0;
//   // Color homeColor = Colors.blue;
//   // Color contactsColor = Colors.red;
//   ///Color completeColor = Colors.blue;

//   //working of floating action button

//   //void _showOptions(BuildContext context) {
//     showModalBottomSheet(
//   //     context: context,
//   //     builder: (BuildContext context) {
//   //       return Center(
//   //         child: Container(
//   //           child: Column(
//   //             mainAxisSize: MainAxisSize.min,
//   //             children: <Widget>[
//   //               Center(
//   //                 child: Container(
//   //                   child: ListTile(
//   //                     leading: const Icon(Icons.assignment),
//   //                     title: const Text('Task Sharing'),
//   //                     onTap: () {
//   //                       // Handle task sharing option
//   //                       Navigator.pop(context); // Close the bottom sheet
//   //                       Navigator.push(
//   //                         context,
//   //                         MaterialPageRoute(
//   //                             builder: (context) => const TaskSharing()),
//   //                       );
//   //                     },
//   //                   ),
//   //                 ),
//   //               ),
//   //               ListTile(
//   //                 leading: const Icon(Icons.share),
//   //                 title: const Text('Sharing'),
//   //                 onTap: () {
//   //                   // Handle sharing option
//   //                   Navigator.pop(context); // Close the bottom sheet
//   //                   Navigator.push(
//   //                     context,
//   //                     MaterialPageRoute(builder: (context) => const sharing()),
//   //                   );
//   //                 },
//   //               ),
//   //               ListTile(
//   //                 leading: const Icon(Icons.assignment_turned_in),
//   //                 title: const Text('Task'),
//   //                 onTap: () {
//   //                   Navigator.pop(context); // Close the bottom sheet
//   //                   Navigator.push(
//   //                     context,
//   //                     MaterialPageRoute(builder: (context) => const Tasks()),
//   //                   );
//   //                 },
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }

// // working of database contacts//
// //
// //  List<Contactmodel> contact = [];
// //   bool isLoading = true;
// //   @override
// //   void initState() {
// //     super.initState();
// //     // getContactsPermission();
// //     //fetchData();
// //   }

// //   Future<List<Contactmodel>> fetchData() async {
// //     final dio = Dio();

// //     try {
// //       final response = await dio.get('$ip/GetAllUsers');

// //       if (response.statusCode == 200) {
// //         final List<dynamic> data = response.data as List<dynamic>;

// //         // Assuming Contactmodel.fromMap() is a factory constructor in Contactmodel
// //         // Update the Contactmodel.fromMap() method accordingly
// //         List<Contactmodel> contactList =
// //             data.map((item) => Contactmodel.fromMap(item)).toList();

// //         //setState(() {
// //         // isLoading = false;
// //         // Assuming contact is a member variable in your widget class
// //         //contact = contactList;
// //         //});

// //         return contactList;
// //       } else {
// //         print('Failed to load tasks. Status code: ${response.statusCode}');
// //         // Return an empty list or throw an exception based on your requirements
// //         return [];
// //       }
// //     } catch (e) {
// //       print('Error: $e');
// //       // Return an empty list or throw an exception based on your requirements
// //       return [];
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Center(child: Text("Completed Tasks")),
// //         backgroundColor: Colors.purple,
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back),
// //           onPressed: () {
// //             Navigator.pushReplacement(
// //               context,
// //               MaterialPageRoute(
// //                   builder: (context) =>
// //                       const ToDo()), // Replace ToDo() with the actual widget for your ToDo screen
// //             );
// //           },
// //         ),
// //       ),
// //       body: Column(
// //         children: [
// //           // if (isLoading)
// //           //   const Center(
// //           //     child: CircularProgressIndicator(),
// //           //   )
// //           // else
// //           Expanded(
// //             child: FutureBuilder<List<Contactmodel>>(
// //               future:
// //                   fetchData(), // Assume getData is your asynchronous function
// //               builder: (context, snapshot) {
// //                 if (snapshot.connectionState == ConnectionState.waiting) {
// //                   // If the Future is still running, show a loading indicator
// //                   return const CircularProgressIndicator();
// //                 } else if (snapshot.hasError) {
// //                   // If the Future throws an error, display the error message
// //                   return Text('Error: ${snapshot.error}');
// //                 } else {
// //                   // If the Future is complete and successful, display the data
// //                   List<Contactmodel> contact = snapshot.data ?? [];

// //                   return Column(
// //                     children: [
// //                       const SizedBox(
// //                         height: 15.0,
// //                       ),
// //                       const TextField(
// //                           // Your TextField widget remains unchanged
// //                           ),
// //                       Expanded(
// //                         child: ListView.builder(
// //                           itemCount: contact.length,
// //                           itemBuilder: (context, index) {
// //                             Contactmodel apiContact = contact[index];

// //                             return Container(
// //                               margin: const EdgeInsets.all(8.0),
// //                               padding: const EdgeInsets.all(16.0),
// //                               decoration: BoxDecoration(
// //                                 color: Colors.white,
// //                                 borderRadius: BorderRadius.circular(8.0),
// //                                 boxShadow: [
// //                                   BoxShadow(
// //                                     color: Colors.grey.withOpacity(0.5),
// //                                     spreadRadius: 2,
// //                                     blurRadius: 5,
// //                                     offset: const Offset(0, 3),
// //                                   ),
// //                                 ],
// //                               ),
// //                               child: Column(
// //                                 crossAxisAlignment: CrossAxisAlignment.start,
// //                                 children: [
// //                                   Text(
// //                                     'USERID: ${apiContact.UserId ?? 'N/A'}',
// //                                     style: const TextStyle(fontSize: 18),
// //                                   ),
// //                                   Text(
// //                                     'Name: ${apiContact.UserName ?? 'N/A'}',
// //                                     style: const TextStyle(fontSize: 18),
// //                                   ),
// //                                   Text(
// //                                     'Phone: ${apiContact.PhoneNumber ?? 'N/A'}',
// //                                     style: const TextStyle(fontSize: 16),
// //                                   ),
// //                                 ],
// //                               ),
// //                             );
// //                           },
// //                         ),
// //                       ),
// //                     ],
// //                   );
// //                 }
// //               },
// //             ),
// //           ),
// //         ],
// //       ),


//contacts list from mobile working

      // body: Column(
      //   children: [
      //     if (isLoading)
      //       const Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     else
      //       Expanded(
      //         child: Column(
      //           children: [
      //             const SizedBox(
      //               height: 15.0,
      //             ),
      //             TextField(
      //               decoration: InputDecoration(
      //                 filled: true,
      //                 fillColor: Colors.white,
      //                 border: OutlineInputBorder(
      //                   borderRadius: BorderRadius.circular(8.0),
      //                   borderSide: const BorderSide(color: Colors.black),
      //                 ),
      //                 icon: const Icon(Icons.search),
      //                 hintText: 'Search',
      //                 labelStyle: const TextStyle(color: Colors.black),
      //               ),
      //             ),
      //             Expanded(
      //               child: Builder(builder: (context) {
      //                 return ListView.builder(
      //                   itemCount: contacts.length,
      //                   itemBuilder: (context, index) {
      //                     Contact deviceContact = contacts[index];
      //                     bool isContactInApi = contact.any(
      //                       (apiContact) =>
      //                           apiContact.PhoneNumber ==
      //                           deviceContact.phones!.first.value,
      //                     );

      //                     return ListTile(
      //                       leading: Container(
      //                         height: 40,
      //                         width: 40,
      //                         alignment: Alignment.center,
      //                         decoration: BoxDecoration(
      //                           boxShadow: [
      //                             BoxShadow(
      //                               blurRadius: 7,
      //                               color:
      //                                   const Color.fromARGB(193, 112, 14, 88)
      //                                       .withOpacity(0.1),
      //                               offset: const Offset(-3, -3),
      //                             ),
      //                             BoxShadow(
      //                               blurRadius: 7,
      //                               color: const Color.fromARGB(255, 36, 91, 52)
      //                                   .withOpacity(0.7),
      //                               offset: const Offset(-3, -3),
      //                             ),
      //                           ],
      //                           borderRadius: BorderRadius.circular(6),
      //                           color: isContactInApi
      //                               ? Colors.green
      //                               : const Color.fromARGB(255, 123, 8, 8),
      //                         ),
      //                       ),
      //                       title: Text(
      //                         deviceContact.displayName ?? 'N/A',
      //                         maxLines: 1,
      //                         overflow: TextOverflow.ellipsis,
      //                         style: const TextStyle(
      //                           fontSize: 16,
      //                           color: Colors.black,
      //                           fontFamily: "poppins",
      //                           fontWeight: FontWeight.w500,
      //                         ),
      //                       ),
      //                       subtitle: Text(
      //                         deviceContact.phones!.isNotEmpty
      //                             ? deviceContact.phones!.first.value ?? 'N/A'
      //                             : 'N/A',
      //                         maxLines: 1,
      //                         overflow: TextOverflow.ellipsis,
      //                         style: const TextStyle(
      //                           fontSize: 16,
      //                           color: Colors.black,
      //                           fontFamily: "poppins",
      //                           fontWeight: FontWeight.w400,
      //                         ),
      //                       ),
      //                       tileColor: isContactInApi ? Colors.green : null,
      //                       horizontalTitleGap: 12,
      //                     );
      //                   },
      //                 );
      //               }),
      //             ),
      //           ],
      //         ),
      //       ),
      //   ],
      // ),

// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () {
// //           _showOptions(context); // Call the _showOptions function
// //         },
// //         child: const Icon(Icons.add),
// //       ),
// //       bottomNavigationBar: BottomNavigationBar(
// //         backgroundColor: Colors.purple,
// //         onTap: (index) {
// //           setState(() {
// //             myIndex = index;
// //           });
// //           if (index == 0) {
// //             Navigator.push(
// //               context,
// //               MaterialPageRoute(builder: (context) => const ToDo()),
// //             );
// //           }
// //           if (index == 1) {
// //             Navigator.push(
// //               context,
// //               MaterialPageRoute(builder: (context) => const Contacts()),
// //             );
// //           }
// //           if (index == 2) {
// //             Navigator.push(
// //               context,
// //               MaterialPageRoute(builder: (context) => const CompleteTasks()),
// //             );
// //           }
// //         },
// //         currentIndex: myIndex,
// //         items: [
// //           BottomNavigationBarItem(
// //             icon: Container(
// //               //color: homeColor,
// //               child: const Icon(Icons.home),
// //             ),
// //             label: 'ToDo',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Container(
// //               //color: contactsColor,
// //               child: const Icon(Icons.people),
// //             ),
// //             label: 'Contacts',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Container(
// //               color: completeColor,
// //               child: const Icon(Icons.done),
// //             ),
// //             label: 'Complete',
// //           ),
// //         ],
// //         selectedItemColor: Colors.white,
// //       ),
// //     );
// //   }
// // }
//    // );))))))