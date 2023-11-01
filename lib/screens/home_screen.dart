import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:second_store/constants/constants.dart';
import 'package:second_store/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';
  final LocationData? locationData;
  const HomeScreen({super.key, this.locationData});
  //we are getting latilude and longitude here

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String address = 'India';
  Future<String?> getAddress() async {
    final coordinates = new Coordinates(
        widget.locationData?.latitude, widget.locationData?.altitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      address = first.addressLine!;
    });

    return first.addressLine;
  }

  @override
  void initState() {
    getAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0.0,
        title: InkWell(
          onTap: () {},
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                children: [
                  const Icon(
                    CupertinoIcons.location_solid,
                    color: AppColors.blackColor,
                    size: 18,
                  ),
                  Flexible(
                    child: Text(
                      address,
                      style: const TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: AppColors.blackColor,
                    size: 18,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: ElevatedButton(
            child: const Text('Sign Out'),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushReplacementNamed(context, LoginScreen.id);
              });
            }),
      ),
    );
  }
}
