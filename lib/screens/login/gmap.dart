import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);
  static const String id = 'map-screen';

  @override
  State<MapScreen> createState() => _MapScreenState();
}

LatLng location = LatLng(37.422131, -122.084801);
bool pressed = false;

String locationMessage = 'Current location of the user';
late String lat;
late String long;

// Getting current location
Future<Position> _getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location service are disabled');
  }
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permission are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permission are permanently denied');
  }

  return await Geolocator.getCurrentPosition();
}

class _MapScreenState extends State<MapScreen> {
  var initialLocation = LatLng(9.956530371540934, 76.30119109423303);
  late GoogleMapController mapController;

  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      lat = position.latitude.toString();
      long = position.longitude.toString();
      setState(() {
        locationMessage = 'Latitude: $lat , Longitude: $long';
      });
    });
  }

  floatingButton() {
    _getCurrentLocation().then((value) {
      setState(() {
        initialLocation = LatLng(value.latitude, value.longitude);
        mapController.animateCamera(
          CameraUpdate.newLatLngZoom(initialLocation, 14),
        );
      });
      _liveLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Location'),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: initialLocation,
                  zoom: 14,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId("marker1"),
                    position: initialLocation,
                    draggable: true,
                    onDragEnd: (value) {
                      setState(() {
                        location = value;
                      });
                    },
                  ),
                },
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 150,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(fixedSize: const Size(150, 50)),
              child: Text('Save Location'),
              onPressed: () async {
                pressed = true;
                await floatingButton();
                try {
                  Navigator.pop(context, location);
                } catch (e) {
                  print('errorrrr: $e');
                  Navigator.pop(context, location);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Failed to add location. Please try again.'),
                    ),
                  );
                }
              },
            ),
          ),
          Positioned(
            bottom: 40,
            left: 40,
            child: FloatingActionButton(
                onPressed: () {
                  floatingButton();
                },
                child: Icon(Icons.map_outlined)),
          )
        ],
      ),
    );
  }
}
