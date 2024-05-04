import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class polygone extends StatefulWidget {
  const polygone({super.key});

  @override
  _polygoneState createState() => _polygoneState();
}

// ignore: camel_case_types
class _polygoneState extends State<polygone> {
  final Completer<GoogleMapController> _controller = Completer();
  //zoom Controller
  GoogleMapController? _control;
  late final GoogleMapController _mapController;
  final Set<Polygon> _polygons = {};
  final List<LatLng> _currentPolygon = [];
  bool _isDrawing = false;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _toggleDrawing() {
    setState(() {
      _isDrawing = !_isDrawing;
    });
  }

  final Set<Marker> _markers = {};
  void _addPoint(LatLng point) {
    setState(() {
      _currentPolygon.add(point);
      //Adds Marker on Map
      _markers.add(Marker(
        markerId: MarkerId(_markers.length.toString()),
        position: point,
      ));
    });
  }

  void _removeLastPoint() {
    if (_currentPolygon.isNotEmpty) {
      setState(() {
        _currentPolygon.removeLast();
        final List<Marker> markerList = _markers.toList();
        markerList.removeLast();
        _markers.clear();
        _markers.addAll(markerList);
        _updatePolygons();
      });
    }
  }

  void _updatePolygons() {
    final Polygon newPolygon = Polygon(
      polygonId: PolygonId(_currentPolygon.toString()),
      points: _currentPolygon,
      strokeColor: const Color.fromARGB(255, 74, 216, 192),
      strokeWidth: 1,
      fillColor: const Color.fromARGB(255, 74, 216, 192).withOpacity(0.2),
    );
    setState(() {
      _polygons.add(newPolygon);
      // _currentPolygon.clear();
    });
  }

  Future<void> _savePolygons(Set<Polygon> polygons, context) async {
    // Create the request body as a JSON object

    // final Map<String, dynamic> requestBody = {
    //   'secName': namecont.text,
    //   'threshold': thresholdcont.text,
    //   'description': descriptioncont.text,
    //   'latLongs': _currentPolygon
    // };

    // Send the HTTP request
    //   try {
    //     final Response response =
    //         await Dio().post('$api/SavePolygons', data: requestBody);

    //     // Check if the request was successful
    //     if (response.statusCode == 200) {
    //       // Handle the success response
    //       snackBar(context, "New Sector Has been added Successfully");
    //       //print('Polygons saved successfully: ${response.data}');
    //       //snackBar(context, 'Polygons saved successfully');
    //     } else {
    //       // Handle the error response
    //       snackBar(context, 'Failed to save polygons: ${response.data}');
    //       // print('Failed to save polygons: ${response.data}');
    //     }
    //   } catch (error) {
    //     // Handle any errors that occur during the request
    //     snackBar(context, 'Failed to save polygons:');
    //     //print('Failed to save polygons: $error');
    //   }
    // }

    // Future<void> _fetchPolygons() async {
    //   try {
    //     final response = await Dio().get('$api/GetAllSectors');
    //     //final body = response.data;
    //     final body = response.data;
    //     if (body is List<dynamic>) {
    //       final data = body.map((item) => item as Map<String, dynamic>).toList();
    //       // Now you can access the properties of each item in the list
    //       for (final item in data) {
    //         final secId = item['sec_id'] as int;
    //         final secName = item['sec_name'] as String;
    //         final threshold = item['threshold'] as int;
    //         final description = item['description'] as String;
    //         //final latLongs = item['latLongs'] as List<dynamic>;

    //         var latLngs = (item['latLongs'] as List<dynamic>)
    //             .map((e) => LatLng(
    //                   double.parse(e.split(',')[0]),
    //                   double.parse(e.split(',')[1]),
    //                 ))
    //             .toList();
    //         if (latLngs.isNotEmpty) {
    //           final polygon = Polygon(
    //             visible: true,
    //             consumeTapEvents: _isDrawing == false ? true : false,
    //             onTap: () {
    //               getDialogue(context, "$secName\n$threshold");
    //             },
    //             polygonId: PolygonId(secId.toString()),
    //             points: latLngs,
    //             strokeColor: const Color.fromARGB(255, 74, 216, 192),
    //             strokeWidth: 1,
    //             fillColor:
    //                 const Color.fromARGB(255, 74, 216, 192).withOpacity(0.2),
    //           );
    //           setState(() {
    //             _polygons.add(polygon);
    //           });
    //         }
    //       }
    //     }
    //   } catch (error) {
    //     print('Failed to fetch polygons: $error');
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Sector'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save_as_rounded,
              color: Colors.amber,
            ),
            onPressed: () {
              // Convert the list of LatLng points to a List<List<double>>
              final List<List<double>> coordinates = _currentPolygon
                  .map((latLng) => [latLng.latitude, latLng.longitude])
                  .toList();

              // Convert the List<List<double>> to a JSON string
              final String coordinatesJson = jsonEncode(coordinates);

              // Pop the string value back to the previous screen
              Navigator.pop(context, coordinatesJson);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            //indoorViewEnabled: true,
            //liteModeEnabled: true,
            buildingsEnabled: true,
            //zoomGesturesEnabled: true,
            myLocationEnabled: true,

            zoomControlsEnabled: false,
            // hide location button
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: const CameraPosition(
              target: LatLng(33.643005, 73.077706),
              zoom: 14.4746,
            ),
            markers: _markers,
            polygons: _polygons,
            onTap: (LatLng point) {
              if (_isDrawing) {
                _addPoint(point);
                _updatePolygons();
              }
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _mapController = controller;
              _control = controller;
              // _fetchPolygons();
            },
          ),
          //Zoom Selection Button
          Positioned(
            bottom: 40,
            left: 15,
            child: Container(
                width: 35,
                height: 105,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.amber,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        _control!.animateCamera(CameraUpdate.zoomIn());
                      },
                      padding: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.add, size: 25),
                    ),
                    const Divider(height: 5),
                    MaterialButton(
                      onPressed: () {
                        _control!.animateCamera(CameraUpdate.zoomOut());
                      },
                      padding: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.remove, size: 25),
                    )
                  ],
                )),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 80,
        child: Stack(
          children: [
            Positioned(
                bottom: 20,
                right: 80,
                // child: ButtonWidget(
                //   onPress: _removeLastPoint,
                //   btnText: 'Undo',
                // ),
                child: ElevatedButton(
                    onPressed: _removeLastPoint, child: Text("undo"))),
            Positioned(
                bottom: 20,
                left: 100,
                // child: ButtonWidget(
                //   btnText: _isDrawing ? "Drawing" : "Add New",
                //   onPress: _toggleDrawing,
                // ),
                child: ElevatedButton(
                    onPressed: _toggleDrawing, child: Text("Add New"))),
          ],
        ),
      ),
    );
  }
}
