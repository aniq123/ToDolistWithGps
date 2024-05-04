import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geodesy/geodesy.dart' as dis;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapDemo extends StatefulWidget {
  final LatLng? targetLocation;

  const MapDemo({Key? key, this.targetLocation}) : super(key: key);

  @override
  State<MapDemo> createState() => _MapDemoState();
}

class _MapDemoState extends State<MapDemo> {
  final Completer<GoogleMapController> _completer = Completer();
  Marker? _marker;
  LatLng? currentLocation;
  double radius = 200.0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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

  void _animateMarker(LatLng destination) async {
    if (_marker != null && currentLocation != null) {
      final marker = _marker!;

      // Generate waypoints between current location and target
      List<LatLng> waypoints = [];
      const numberOfWaypoints = 10;

      for (int i = 0; i <= numberOfWaypoints; i++) {
        double fraction = i / numberOfWaypoints;
        double lat = lerpDouble(
            currentLocation!.latitude, destination.latitude, fraction)!;
        double lng = lerpDouble(
            currentLocation!.longitude, destination.longitude, fraction)!;

        waypoints.add(LatLng(lat, lng));
      }

      for (LatLng waypoint in waypoints) {
        double fraction = waypoints.indexOf(waypoint) / waypoints.length;

        Future.delayed(Duration(milliseconds: (1000 * fraction).round()), () {
          if (currentLocation != null) {
            final lat = waypoint.latitude;
            final lng = waypoint.longitude;

            Marker newMarker = marker.copyWith(
              positionParam: LatLng(lat, lng),
            );

            setState(() {
              _marker = newMarker;
            });

            // Check if the current location is near the target location
            dis.Geodesy geodesy = dis.Geodesy();
            var distance = geodesy.distanceBetweenTwoGeoPoints(
              dis.LatLng(lat, lng),
              dis.LatLng(destination.latitude, destination.longitude),
            );

            if (distance <= radius) {
              print('Current location is near the target location.');
              EasyLoading.showToast('You have reached your location');
            }
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentLocation ?? const LatLng(0.0, 0.0),
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
              setState(() {
                _marker = Marker(
                  markerId: const MarkerId('target'),
                  position: point,
                );
                _animateMarker(point); // Start marker animation towards target
              });
              print('Tapped on: $point');
            },
            markers: Set<Marker>.of(_marker != null ? [_marker!] : []),
            circles: {
              if (currentLocation != null)
                Circle(
                  circleId: const CircleId('radius'),
                  center: LatLng(
                      currentLocation!.latitude, currentLocation!.longitude),
                  radius: radius,
                  fillColor:
                      const Color.fromARGB(255, 33, 243, 103).withOpacity(0.3),
                  strokeWidth: 0,
                ),
              if (widget.targetLocation != null)
                Circle(
                  circleId: const CircleId('targetRadius'),
                  center: widget.targetLocation!,
                  radius: radius,
                  fillColor:
                      const Color.fromARGB(255, 243, 145, 33).withOpacity(0.3),
                  strokeWidth: 0,
                ),
            },
          ),
        ]),
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
