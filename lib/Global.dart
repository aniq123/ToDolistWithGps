import 'package:flutter_application_22/Model/UserModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//'$ip/AllTasks?userid=$loggedInUser.id',

User? loggedInUser;
User? loggedInUserID;
LatLng? targetLocation;
int? existingUserId;
//String IP1 = "192.168.149.182";
String IP1 = "192.168.72.182";

String ip = 'http://$IP1/fypwork/api/FYPWORK';
var fnplugin;
var is_snooze = true;
//String? reminderval;

double? latitude;
double? longitude;
double? latitude1;
double? longitude1;
String? taskTitle;

String? selectedContacts;


  // List<String> timeParts = VARIABLE.split(' ');
  //   int DATE = int.tryParse(timeParts[0]) ?? 0;
  //   int TIME = int.tryParse(timeParts[1]) ?? 0;


