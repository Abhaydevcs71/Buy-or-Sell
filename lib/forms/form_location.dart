import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:second_store/screens/gmap.dart';

class FormLocation extends StatefulWidget {
  const FormLocation({super.key});
  static const String id = 'formLocation-screen';

  @override
  State<FormLocation> createState() => _FormLocationState();
}

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

class _FormLocationState extends State<FormLocation> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Location'),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Text(
              locationMessage,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  _getCurrentLocation().then((value) {
                    lat = '${value.latitude}';
                    long = '${value.longitude}';
                    setState(() {
                      locationMessage = 'Latitude: $lat , Longitude: $long';
                    });
                    return (lat, long);
                    _liveLocation();
                  }).then((value) {
                    Navigator.pushNamed(context, MapScreen.id);
                  });

                },
                child: Text('Get current Location'))
          ])),
    );
  }
}