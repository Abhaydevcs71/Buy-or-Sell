import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:dialogs/dialogs/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:second_store/constants/constants.dart';
import 'package:second_store/screens/home/home_screen.dart';
import 'package:second_store/screens/home/main_screen.dart';
import 'package:second_store/services/firebase_services.dart';

class LocationScreen extends StatefulWidget {
  static const String id = 'location-screen';

  bool? locationChanging;
  LocationScreen({this.locationChanging});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  FirebaseService _service = FirebaseService();

  bool _loading = true;
  Location location = new Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  late String _address;

  String? countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  late String manualAddress;

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

    _locationData = await location.getLocation();

    // setState(() async {
    //   _locationData = await location.getLocation();
    // });

    final coordinates =
        new Coordinates(_locationData.latitude, _locationData.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      _address = first.addressLine!;
      countryValue = first.countryName;
    });

    return _locationData;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.locationChanging == null) {
      _service.users
          .doc(_service.user?.uid)
          .get()
          .then((DocumentSnapshot document) {
        if (document.exists) {
          Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
          // location already updated
          if (data != null && data!.containsKey('address')) {
            if (document['address'] != null) {
              Navigator.pushReplacementNamed(context, MainScreen.id);
            } else {
              setState(() {
                _loading = false;
              });
            }
          } else {
            setState(() {
              _loading = false;
            });
          }
        }
      });
    } else {
      setState(() {
        _loading = false;
      });
    }

    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      loadingText: 'Fetching location...',
      progressIndicatorColor: Theme.of(context).primaryColor,
    );

    showBottomScreen(context) {
      getLocation().then((location) {
        if (location != null) {
          progressDialog.dismiss();
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
                            decoration: const InputDecoration(
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
                      onTap: () {
                        // save addresses to the firestore
                        progressDialog.show();
                        getLocation().then((value) {
                          if (value != null) {
                            _service.updateUser({
                              'location':
                                  GeoPoint(value.latitude!, value.longitude!),
                              'address': _address,
                            }, context).then((value) {
                              progressDialog.dismiss();
                              Navigator.pushNamed(context, HomeScreen.id);
                            });
                          }
                        });
                      },
                      horizontalTitleGap: 0.0,
                      leading: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                      ),
                      title: const Text(
                        'Use current location',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        location == null ? 'Fetching Location' : _address,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[300],
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 5, bottom: 5, top: 5),
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
                        flagState: CountryFlag.DISABLE,
                        dropdownDecoration:
                            const BoxDecoration(shape: BoxShape.rectangle),
                        defaultCountry: CscCountry.India,
                        onCountryChanged: (value) {
                          setState(() {
                            countryValue = value;
                          });
                        },
                        onStateChanged: (value) {
                          setState(() {
                            stateValue = value;
                          });
                        },
                        onCityChanged: (value) {
                          setState(() {
                            cityValue = value;
                            manualAddress =
                                '$cityValue, $stateValue, $countryValue';
                          });

                          // send this address to the firestore

                          if (value != null) {
                            _service.updateUser({
                              'address': manualAddress,
                              'state': stateValue,
                              'city': cityValue,
                              'country': countryValue,
                            }, context);
                          }
                        },
                      ),
                    ),
                  ],
                );
              });
        } else {
          progressDialog.dismiss();
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Image.asset('assets/images/18-location-pin.gif'),
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
          _loading
              ? CircularProgressIndicator()
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 10),
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
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Theme.of(context).primaryColor),
                                    ),
                                    icon: const Icon(
                                        CupertinoIcons.location_fill),
                                    label: const Padding(
                                      padding:
                                          EdgeInsets.only(top: 15, bottom: 15),
                                      child: Text(
                                        'Around me',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    onPressed: () {
                                      progressDialog.show();
                                      getLocation().then((value) {
                                        if (value != null) {
                                          _service.updateUser({
                                            'address': _address,
                                            'location': GeoPoint(
                                                value.latitude!,
                                                value.longitude!),
                                          }, context);
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
                        progressDialog.show();
                        showBottomScreen(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(width: 2))),
                          child: const Text(
                            'Set location manually',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ),
                    )
                  ],
                )
        ],
      ),
    );
  }
}
