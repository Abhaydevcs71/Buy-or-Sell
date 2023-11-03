import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:second_store/constants/constants.dart';
import 'package:second_store/screens/home_screen.dart';

class LocationScreen extends StatefulWidget {
  static const String id = 'location-screen';

  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _loading = false;
  Location location = new Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";

  Future<LocationData?> getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    setState(() async {
      _locationData = await location.getLocation();
    });

    return _locationData;
  }

  @override
  Widget build(BuildContext context) {
    showBottomScreen(context) {
      showModalBottomSheet(
          isScrollControlled: true,
          enableDrag: true,
          context: context,
          builder: (context) {
            return Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                AppBar(
                  automaticallyImplyLeading: false,
                  elevation: 1,
                  backgroundColor: Colors.white,
                  title: Row(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'Location',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        )
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(6)),
                    child: SizedBox(
                      height: 40,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Search your city',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          icon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {},
                  horizontalTitleGap: 0.0,
                  leading: Icon(
                    Icons.my_location,
                    color: Colors.blue,
                  ),
                  title: Text(
                    'Use current location',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Enable Location',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[300],
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, bottom: 5, top: 5),
                    child: Text(
                      'CHOOSE CITY',
                      style: TextStyle(
                        color: Colors.blueGrey[900],
                      ),
                    ),
                  ),
                ),

                // Location picker

                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: CSCPicker(
                    layout: Layout.vertical,
                    dropdownDecoration:
                        const BoxDecoration(shape: BoxShape.rectangle),
                    defaultCountry: CscCountry.India,
                    onCountryChanged: (value) {
                      setState(() {
                        countryValue = value;
                        print(countryValue);
                      });
                    },
                    onStateChanged: (value) {
                      setState(() {
                        stateValue = value!;
                      });
                    },
                    onCityChanged: (value) {
                      setState(() {
                        cityValue = value!;
                        address = '$cityValue, $stateValue, $countryValue';
                      });
                      print(address);
                    },
                  ),
                ),
              ],
            );
          });
    }

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Image.asset('assets/images/locatioon.png'),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Where do want \n to buy/sell products',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'TO enjoy all that we have to offer you\nwe need to know where to look for them',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: _loading
                      ? Center(
                          child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ))
                      : ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).primaryColor),
                          ),
                          icon: const Icon(CupertinoIcons.location_fill),
                          label: const Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            child: Text(
                              'Around me',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _loading = true;
                            });
                            getLocation().then((value) {
                              if (value != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        HomeScreen(
                                      locationData: _locationData,
                                    ),
                                  ),
                                );
                              }
                            });
                          },
                        ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              showBottomScreen(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration:
                    BoxDecoration(border: Border(bottom: BorderSide(width: 2))),
                child: Text(
                  'Set location manually',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
