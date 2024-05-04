import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_22/Global.dart';
import 'package:flutter_application_22/Model/GeoFancing.dart';
import 'package:flutter_application_22/Screens/ToDo.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geodesy/geodesy.dart' as dis;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GeoFencing extends StatefulWidget {
  const GeoFencing({Key? key}) : super(key: key);

  @override
  State<GeoFencing> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<GeoFencing> {
  late Future<List<GeoFancing>> _futureTasks;

  @override
  void initState() {
    super.initState();
    _futureTasks = fetchData();
  }

  Future<List<GeoFancing>> fetchData() async {
    final dio = Dio();
    try {
      final response =
          await dio.get('$ip/AllGeofence?userid=${loggedInUser!.id}');
      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        var task = data.map((item) => GeoFancing.fromMap(item)).toList();

        setState(() {});
        return task;
      } else {
        print('Failed to load tasks. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<void> deleteTask(int taskId) async {
    final dio = Dio();
    final String apiUrl = '$ip/DeleteTask';

    try {
      final response = await dio.post('$apiUrl?taskId=$taskId');

      if (response.statusCode == 200) {
        print('Task deleted successfully!');
        fetchData();
        setState(() {});
      } else if (response.statusCode == 404) {
        print("Task with ID $taskId not found.");
      } else {
        print("Failed to delete task. Error: ${response.data}");
      }
    } catch (e) {
      print("Failed to delete task. Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Center(child: Text("GeoFencing")),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ToDo(),
              ),
            );
          },
        ),
      ),
      body: FutureBuilder<List<GeoFancing>>(
        future: _futureTasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tasks available.'));
          } else {
            List<GeoFancing> tasks = snapshot.data!;

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                {
                  return GestureDetector(
                    onTap: () {
                      LatLng? latlng = tasks[index].Latitude != null
                          ? LatLng(
                              tasks[index].Longitude!, tasks[index].Latitude!)
                          : LatLng(0.0, 0.0);
                      List<List<double>>? POLYGON = tasks[index].polygone != ""
                          ? List<List<double>>.from(
                              (json.decode(tasks[index].polygone)
                                      as List<dynamic>)
                                  .map(
                                (dynamic point) => List<double>.from((point
                                        as List<dynamic>)
                                    .map((dynamic coord) => coord.toDouble())),
                              ),
                            )
                          : [];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapDemo(
                            targetLocation: latlng,
                            polygonData: POLYGON,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.tealAccent,
                          border: Border.all(
                            width: 1.0,
                            color: Colors.blueAccent,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          title: Text("Title: ${tasks[index].Title}"),
                          subtitle: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                            "Latitude: ${tasks[index].Latitude}"),
                                        const SizedBox(width: 100),
                                        Text(
                                            "Longitude: ${tasks[index].Longitude}")
                                      ],
                                    ),
                                    const Text("Radius: ${300}"),
                                    Text("Friend: ${tasks[index].Friends}"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}

class MapDemo extends StatefulWidget {
  final LatLng? targetLocation;
  final List<List<double>>? polygonData;
  final DateTime? taskdate;
  final DateTime? tasktime;
  final String? taskTitle;

  const MapDemo(
      {Key? key,
      this.targetLocation,
      required this.polygonData,
      this.taskdate,
      this.tasktime,
      this.taskTitle})
      : super(key: key);

  @override
  State<MapDemo> createState() => _MapDemoState();
}

class _MapDemoState extends State<MapDemo> {
  final Completer<GoogleMapController> _completer = Completer();
  final Set<Marker> _markers = {};
  final Set<Polygon> _polygons = {};

  LatLng? currentLocation;
  double radius = 200.0;

  // bool index=true ;

  @override
  void initState() {
    super.initState();
    _setTargetMarker();
    currentLocation = widget.targetLocation;
    _setPolygons(widget.polygonData!);
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();

    try {
      var userLocation = await location.getLocation();
      setState(() {
        currentLocation = userLocation != null
            ? LatLng(
                userLocation.latitude ?? 0.0, userLocation.longitude ?? 0.0)
            : null;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  String checkSectorLocation(String latLong, Set<Polygon> polygons) {
    try {
      RegExp regExp = RegExp(r'(-?\d+\.\d+)');
      Iterable<Match> matches = regExp.allMatches(latLong);

      // Extract numeric values from matches
      List<String> numericValues =
          matches.map((match) => match.group(0)!).toList();

      //final List<String> latLongList = numericValues.split(',');
      final double latitude = double.parse(numericValues[0]);
      final double longitude = double.parse(numericValues[1]);

      for (Polygon polygon in polygons) {
        if (isPointInPolygon(polygon.points, latitude, longitude)) {
          // Use the polygon ID as the sector ID
          return polygon.polygonId.value;
        }
      }
    } catch (e) {
      //
    }

    return 'True';
  }

  bool isPointInPolygon(
      List<LatLng> polygon, double latitude, double longitude) {
    // Count the number of times a ray casted horizontally from the point
    // intersects with the edges of the polygon. If the count is odd,
    // the point is inside the polygon; otherwise, it is outside the polygon.
    bool isInside = false;
    final int polygonLength = polygon.length;

    for (int i = 0, j = polygonLength - 1; i < polygonLength; j = i++) {
      final double piLat = polygon[i].latitude;
      final double piLong = polygon[i].longitude;
      final double pjLat = polygon[j].latitude;
      final double pjLong = polygon[j].longitude;

      // Add a buffer to the latitude to ensure precision
      const double buffer = 1e-10;
      final double latBuffer = latitude + buffer;

      if (((piLong > longitude) != (pjLong > longitude)) &&
          (latBuffer <
              (pjLat - piLat) * (longitude - piLong) / (pjLong - piLong) +
                  piLat)) {
        isInside = !isInside;
      }
    }

    return isInside;
  }

  void _setTargetMarker() {
    if (widget.targetLocation != null) {
      setState(() {
        _markers.add(Marker(
          markerId: const MarkerId('target'),
          position: widget.targetLocation!,
          draggable: true,
          onDragEnd: (newPosition) {
            print('Marker dragged to: $newPosition');
          },
        ));
      });
    }
  }

  void _setPolygons(List<List<double>> polygonPoints) {
    if (polygonPoints.isNotEmpty) {
      List<LatLng> polygonLatLng =
          polygonPoints.map((point) => LatLng(point[0], point[1])).toList();

      setState(() {
        _polygons.add(Polygon(
          polygonId: const PolygonId('polygon'),
          points: polygonLatLng,
          strokeWidth: 2,
          strokeColor: Colors.blue,
          fillColor: Colors.blue.withOpacity(0.3),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLocation ??
                    LatLng(
                        currentLocation!.latitude, currentLocation!.longitude),
                zoom: 14.0,
              ),
              mapType: MapType.normal,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                if (!_completer.isCompleted) {
                  _completer.complete(controller);
                }
              },
              onTap: (LatLng point) {
                _addMarker(point);
              },
              markers: _markers,
              circles: {
                if (currentLocation != null)
                  Circle(
                    circleId: const CircleId('radius'),
                    center: LatLng(
                        currentLocation!.latitude, currentLocation!.longitude),
                    radius: radius,
                    fillColor: const Color.fromARGB(255, 33, 243, 103)
                        .withOpacity(0.3),
                    strokeWidth: 0,
                  ),
                if (widget.targetLocation != null)
                  Circle(
                    circleId: const CircleId('targetRadius'),
                    center: widget.targetLocation!,
                    radius: radius,
                    fillColor: const Color.fromARGB(255, 243, 145, 33)
                        .withOpacity(0.3),
                    strokeWidth: 0,
                  ),
              },
              polygons: _polygons,
            ),
            if (targetLocation != null)
              Positioned(
                top: 16,
                left: 16,
                child: GestureDetector(
                  onTap: () {
                    EasyLoading.showToast('You have reached your location');
                  },
                  child: Text(
                    'Target Location\nLat: ${widget.targetLocation!.latitude}\nLng: ${widget.targetLocation!.longitude}',
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (currentLocation != null) {
              _goToCurrentLocation();
            }
          },
          child: const Icon(Icons.my_location),
        ),
      ),
    );
  }

  Future<void> _goToCurrentLocation() async {
    final GoogleMapController controller = await _completer.future;

    if (widget.targetLocation != null) {
      controller.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(
            widget.targetLocation!.latitude, widget.targetLocation!.longitude),
        14.0,
      ));
    } else if (currentLocation != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation!.latitude, currentLocation!.longitude),
          zoom: 14.0,
        ),
      ));
    }
  }

  void _addMarker(LatLng position) {
    Marker marker = Marker(
      markerId: MarkerId(position.toString()),
      position: position,
      draggable: true,
      onDragEnd: (newPosition) {
        print('Marker dragged to: $newPosition');
      },
    );

    setState(() {
      _markers.add(marker);
    });

    if (widget.targetLocation != null) {
      dis.Geodesy geodesy = dis.Geodesy();
      var distance = geodesy.distanceBetweenTwoGeoPoints(
        dis.LatLng(position.latitude, position.longitude),
        dis.LatLng(
          widget.targetLocation!.latitude,
          widget.targetLocation!.longitude,
        ),
      );
      var currentDateTime = DateTime.now();
      if (distance <= radius)
      // &&
      // widget.taskdate != null &&
      // widget.tasktime != null &&
      // widget.taskdate!.year == currentDateTime.year &&
      // widget.taskdate!.month == currentDateTime.month &&
      // widget.taskdate!.day == currentDateTime.day &&
      // widget.tasktime!.hour == currentDateTime.hour &&
      // widget.tasktime!.minute == currentDateTime.minute
      {
        // var index;
        //  createOrUpdateSharedTaskStatus1(loggedInUserID);

        print('Manually added marker is near the target location.');
        EasyLoading.showToast('You have reached your location');
      }
    }
  }

  void createOrUpdateSharedTaskStatus1(int taskId) {
    Future<void> createOrUpdateSharedTaskStatus(int taskId) async {
      final dio = Dio();

      try {
        final response = await dio.post(
          '$ip/CreateOrUpdateSharedTaskStatus?taskid=$taskId',
        );

        if (response.statusCode == 200) {
          print('ShareTask status updated successfully');
          //  updateNumberOfPendingTasks();
          //showPendingTasksPopup();
          setState(() {});
        } else if (response.statusCode == 201) {
          print('New ShareTask created successfully');
        } else {
          print(
              'Failed to update ShareTask status. Status code: ${response.statusCode}');
        }
      } on DioError catch (e) {
        if (e.response?.statusCode == 404) {
          print('Endpoint not found. Check the URL and server implementation.');
        } else {
          print('Error updating ShareTask status: $e');
        }
      } catch (e) {
        print('Unexpected error: $e');
      }
    }
  }
}
