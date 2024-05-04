import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _completer = Completer();
  final CameraPosition _kGoogleplex = const CameraPosition(
    target: LatLng(33.643005, 73.077706),
    zoom: 14.4748,
  );
  List<Marker> _markers = [];
  LatLng? currentLocation;
  String? targetLocation;
  double radius = 200.0;
  LatLng? target;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(minutes: 1), (timer) {
      _getCurrentLocation();
    });
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

      // Check if the current location is within the radius of the target location
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _kGoogleplex,
              mapType: MapType.normal,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                if (!_completer.isCompleted) {
                  _completer.complete(controller);
                }
              },
              onTap: (LatLng point) {
                setState(() {
                  target = point;
                  var lat = target?.latitude;
                  var long = target?.longitude;
                  targetLocation =
                      lat != null && long != null ? "$lat,$long" : null;

                  _markers = [
                    ..._markers, // Copy existing markers
                    Marker(
                      markerId: const MarkerId('target'),
                      position: point,
                    ),
                  ];
                  _getCurrentLocation();
                });
                print('Tapped on: $point');
              },
              markers: Set<Marker>.from(_markers),
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
                if (target != null)
                  Circle(
                    circleId: const CircleId('targetRadius'),
                    center: LatLng(
                        target?.latitude ?? 0.0, target?.longitude ?? 0.0),
                    radius: radius,
                    fillColor: const Color.fromARGB(255, 243, 145, 33)
                        .withOpacity(0.3),
                    strokeWidth: 0,
                  ),
              },
            ),
            Positioned(
              top: 10,
              child: Column(
                children: [
                  Container(
                    color: Colors.amber,
                    height: 50,
                    width: 500,
                    child: Text("Target Location: $targetLocation"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, targetLocation);
                    },
                    child: const Text("Save"),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              child: Container(
                color: Colors.amber,
                height: 50,
                width: 500,
                child: Text(
                    "Current location: ${currentLocation ?? 'Not available'}"),
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
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(currentLocation!.latitude, currentLocation!.longitude),
        zoom: 14.0,
      ),
    ));
  }
}
