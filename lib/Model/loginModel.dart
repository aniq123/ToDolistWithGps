// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    dynamic friends;
    dynamic friends1;
    dynamic geofence;
    dynamic sharedGeofence;
    dynamic sharedTasks;
    dynamic tasks;
    dynamic userId;
    dynamic userEmail;
    dynamic userName;
    dynamic userPassword;
    dynamic userPhoneNumber;

    LoginModel({
        required this.friends,
        required this.friends1,
        required this.geofence,
        required this.sharedGeofence,
        required this.sharedTasks,
        required this.tasks,
        required this.userId,
        required this.userEmail,
        required this.userName,
        required this.userPassword,
        required this.userPhoneNumber,
    });

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        friends: List<dynamic>.from(json["Friends"].map((x) => x)),
        friends1: List<dynamic>.from(json["Friends1"].map((x) => x)),
        geofence: List<dynamic>.from(json["Geofence"].map((x) => x)),
        sharedGeofence: List<dynamic>.from(json["SharedGeofence"].map((x) => x)),
        sharedTasks: List<dynamic>.from(json["SharedTasks"].map((x) => x)),
        tasks: List<dynamic>.from(json["Tasks"].map((x) => x)),
        userId: json["UserId"],
        userEmail: json["UserEmail"],
        userName: json["UserName"],
        userPassword: json["UserPassword"],
        userPhoneNumber: json["UserPhoneNumber"],
    );

    Map<String, dynamic> toJson() => {
        "Friends": List<dynamic>.from(friends.map((x) => x)),
        "Friends1": List<dynamic>.from(friends1.map((x) => x)),
        "Geofence": List<dynamic>.from(geofence.map((x) => x)),
        "SharedGeofence": List<dynamic>.from(sharedGeofence.map((x) => x)),
        "SharedTasks": List<dynamic>.from(sharedTasks.map((x) => x)),
        "Tasks": List<dynamic>.from(tasks.map((x) => x)),
        "UserId": userId,
        "UserEmail": userEmail,
        "UserName": userName,
        "UserPassword": userPassword,
        "UserPhoneNumber": userPhoneNumber,
    };
}
