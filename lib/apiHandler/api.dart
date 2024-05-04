//import '../Model/signupmodel.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_22/Global.dart';
import 'package:http/http.dart' as http;

class APIHandler {
  // static String ip = 'http://$IP1/fypwork/api/FYPWORK';
  // Future<int> Registration(String name,String address,String password,String contact,String role)async{
  //   String url='${ip}account/CreateAccount?nic=$nic&name=${name}&contact=${contact}&address=${address}&password=${password}&role=${role}';
  //   print(url);
  //   var response =await http.post(Uri.parse(url));
  //   return response.statusCode;
  // }
  // Future<int> signupAccoint(User u)async{
  //   String url='${ip}account/signup';
  //   print(url);
  //   Map<String,dynamic> jsonstring=u.toJsonString();
  //   String reqbody=jsonEncode(jsonstring);
  //   print(reqbody);
  //   var response =await http.post(
  //     Uri.parse(url),
  //     headers: <String,String>{
  //       'Content-type':'application/json; charset=UTF-8'
  //     },
  //     body:reqbody
  //   );
  //   return response.statusCode;
  // }
  static Future<http.Response> LogIn(
      String UserEmail, String UserPassword) async {
    String url =
        '${ip}account/LogIn?UserEmail=$UserEmail&UserPassword=$UserPassword';
    var response = await http.post(Uri.parse(url));
    return response;
  }
  // moheed Assignment
  // static Future<String?> getdata(String nic, String password)async{
  //   String url= ip+"fluttertask/login?CNIC=$nic&Password=$password";
  //   var respons=await http.get(Uri.parse(url));
  //   if(respons.statusCode!=200){
  //     return null;
  //   }
  //   return respons.body;
  // }
  // static Future<int> createaccount(String nic, String password, String role)async{
  //   String url=ip+"fluttertask/Signup?CNIC=$nic&Password=$password&Status=$role";
  //   var response=await http.post(Uri.parse(url));
  //   return response.statusCode;
  // }
  // static Future<int> addproduct(String name, String price,String stock) async{
  //   String url=ip+"product/addproduct?name=$name&price=$price&stock=$stock";
  //   var response=await http.post(Uri.parse(url));
  //   return response.statusCode;
  // }
  // static Future<String?> getproducts()async{
  //   String url=ip+"product/getproducts";
  //   var response=await http.get(Uri.parse(url));
  //   if(response.statusCode!=200){
  //     return null;
  //   }
  //   return response.body;
  // }

  static Future<bool> registrationApi({required Map data}) async {
    String url = 'http://50529/api/FYPWORK/SignUp';

    try {
      var response = await http.post(Uri.parse(url),
          body: jsonEncode(data),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });

      var jsonDecodes = jsonDecode(response.body);

      if (response.statusCode == 200) {
        debugPrint("Request successful");
        // scaffoldToast(
        //     msg: jsonDecodes['message'],
        //     color: jsonDecodes['status'] == 500 ? Colors.red : Colors.green);

        debugPrint("Status Code: ${response.statusCode}");
        debugPrint("Response Body: ${response.body}");

        return true;
      } else {
        // scaffoldToast(msg: jsonDecodes['message'], color: Colors.red);
        return false;
      }
    } on SocketException {
      // appToast(msg: 'Could not connect to server',color: Colors.red);
      // scaffoldToast(msg: 'Could not connect to server', color: Colors.red);
      return false;
    } on TimeoutException {
      // appToast(msg: 'Connection timed out',color: Colors.red);
      // scaffoldToast(msg: 'Connection timed out', color: Colors.red);
      return false;
    } catch (e) {
      debugPrint("Error occurred: $e");
      // showMsgToast(message: "Error -- $e");
      return false;
    }
  }

  static Future<bool> loginApi({required Map data}) async {
    String url = 'http://:50529/api/FYPWORK/LogIn';

    try {
      var response = await http.post(
        Uri.parse(url),
        body: data,
        // headers: headers,
      );

      var jsonDecodes = jsonDecode(response.body);

      if (response.statusCode == 200) {
        debugPrint("Request successful");
        // scaffoldToast(
        //     msg: jsonDecodes['message'],
        //     color: jsonDecodes['status'] == 500 ? Colors.red : Colors.green);

        debugPrint("Status Code: ${response.statusCode}");
        debugPrint("Response Body: ${response.body}");

        return true;
      } else {
        // scaffoldToast(msg: jsonDecodes['message'], color: Colors.red);
        return false;
      }
    } on SocketException {
      // appToast(msg: 'Could not connect to server',color: Colors.red);
      // scaffoldToast(msg: 'Could not connect to server', color: Colors.red);
      return false;
    } on TimeoutException {
      // appToast(msg: 'Connection timed out',color: Colors.red);
      // scaffoldToast(msg: 'Connection timed out', color: Colors.red);
      return false;
    } catch (e) {
      debugPrint("Error occurred: $e");
      // showMsgToast(message: "Error -- $e");
      return false;
    }
  }

//   Future<http.Response> checkNotification(int uid) async {
//   try {
//     String url = '$ip/NotifyTasks?userid=$uid';
//     return await http.get(Uri.parse(url));
//   } catch (e) {
//     print('Error in checkNotification: $e');
//     throw e; // Rethrow the exception to propagate it
//   }
// }


//   List<Taskmodel> taskmodelListFromJson(String str) {
//     List<dynamic> jsonData = json.decode(str);
//     return List<Taskmodel>.from(jsonData.map((x) => Taskmodel.fromJson(x)));
//   }
Future<http.Response> checkNotification(int uid) async {
    String url = '$ip/NotifyTasks?userid=$uid';
    return http.get(Uri.parse(url));
  } 

 }

