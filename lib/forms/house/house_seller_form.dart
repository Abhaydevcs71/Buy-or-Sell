import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:dialogs/dialogs/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/services/base.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:second_store/forms/pg/user_review_screen.dart';
import 'package:second_store/screens/gmap.dart';
import 'package:second_store/screens/location_screen.dart';
import 'package:second_store/screens/main_screen.dart';
import 'package:second_store/screens/sellitems/homescreen/home_screen.dart';
import 'package:second_store/widgets/image_picker.dart';
import 'package:second_store/widgets/image_viewer.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:uuid/uuid.dart';

class HouseSellerForm extends StatefulWidget {
  const HouseSellerForm({super.key});

  static const String id = 'house-form';

  @override
  State<HouseSellerForm> createState() => _HouseSellerFormState();
}

class _HouseSellerFormState extends State<HouseSellerForm> {
  final _formKey = GlobalKey<FormState>();
  FirebaseStorage storage = FirebaseStorage.instance;
  var _nameController = TextEditingController();
  var _descController = TextEditingController();
  var _priceController = TextEditingController();
  var _addressController = TextEditingController();
  bool isUploadImage = false;
  bool imageSelected = false;
  final List<File> _image = [];
  final List<String> imageUrls = [];
  bool uploading = false;
  var uuid = Uuid();

  void showConfirmDialogue(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
              Text('Adding products'),
            ],
          ),
        );
      },
    );

    try {
      // Call addProducts
      await addProducts();
      print(location);

      // Close the progress indicator dialog
      Navigator.of(context).pop();

      // Navigate to home screen
      Navigator.pushReplacementNamed(context, MainScreen.id);
    } catch (e) {
      // Handle error, if any
      print('Error adding products: $e');

      // Close the progress indicator dialog
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add products. Please try again.'),
        ),
      );
    }
  }

  String? bhk;

  String? parking;

  bool val = false;
  late LatLng loc;

  Future uploadFile(int i) async {
    if (_image.isEmpty) return;
    final fileName = _image[i].path.split('/').last;
    final destination = 'files/$fileName';

    try {
      final ref =
          FirebaseStorage.instance.ref(destination).child('file/$fileName');
      String downloadUrl = await (await ref.putFile(
              _image[i],
              SettableMetadata(
                contentType: "image/png",
              )))
          .ref
          .getDownloadURL();
      imageUrls.add(downloadUrl);
    } catch (e) {
      print('error occured');
    }
  }

  Future<void> addProducts() async {
    List<Future<void>> uploadTasks = [];
    for (int i = 0; i < _image.length; i++) {
      uploadTasks.add(uploadFile(i));
    }
    await Future.wait(uploadTasks);

    //Get current timestamp
    DateTime currentDate = DateTime.now();

    //Get user
    User? user = FirebaseAuth.instance.currentUser;

    //Generate and get product id
    var docId = uuid.v4();

    CollectionReference products =
        FirebaseFirestore.instance.collection('products');
    await products.add({
      'name': _nameController.text,
      'Description': _descController.text,
      'Price': _priceController.text,
      'adress': _addressController.text,
      'images': imageUrls,
      'Category': 'House',
      'bhk': bhk,
      'parking': parking,
      'location': "${loc.latitude} ${loc.longitude}",
      'date': currentDate,
      'userId': user?.uid,
      'docId': docId
    });
  }

  validate() {
    if (_formKey.currentState!.validate()) {
      log('validated');
      val = true;
    }
  }

  chooseImage() async {
    List<XFile?> pickedFile = await ImagePicker().pickMultiImage();
    for (int i = 0; i < pickedFile.length; i++) {
      setState(() {
        _image.add(File(pickedFile[i]!.path));
      });
    }
    setState(() {
      imageSelected = true;
    });
  }

  chooseCamera() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _image.add(File(pickedFile!.path));
    });
    setState(() {
      imageSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0.0,
        title: const Text(
          "Add some details",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey.shade400,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      'House',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name your Ad',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Required Field';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _descController,
                      minLines: 3,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                        hintText: 'Tell something about this place',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Required Field';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                      hint:
                          const Text('Select the number of BHK in this house'),
                      value: bhk,
                      onChanged: (String? newValue) {
                        setState(() {
                          bhk = newValue!;
                        });
                      },
                      items: <String>[
                        '1-BHK',
                        '2-BHK',
                        '3-BHK',
                        '4-BHK',
                        '5-BHK',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                      hint: const Text('Parking facility'),
                      value: parking,
                      onChanged: (String? newValue) {
                        setState(() {
                          parking = newValue!;
                        });
                      },
                      items: <String>['available', 'not available']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Price',
                          prefixText: 'INR\t'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Required Field';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _addressController,
                      minLines: 3,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Address',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Required Field';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    //location part
                    InkWell(
                        onTap: () async {
                          final result =
                              await Navigator.pushNamed(context, MapScreen.id);
                          if (result != null) {
                            setState(() {
                              loc = result as LatLng;
                            });
                            debugPrint("datdtatd" + loc.latitude.toString());
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[400],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ]),
                          child: Text(
                            'Location',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),

                    InkWell(
                      onTap: () {
                        if (!imageSelected)
                          setState(() {
                            isUploadImage = true;
                          });
                        if (imageSelected)
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ImageViewer(images: _image);
                              });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[400],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ]),
                        child: Text(
                          !imageSelected ? 'Upload images' : 'View Images',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 90,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Stack(
        children: [
          Row(
            children: [
              if (isUploadImage) ...[
                Spacer(),
                SizedBox(
                  height: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              isUploadImage = false;
                            });
                            chooseCamera();
                          },
                          child: Icon(
                            Icons.camera,
                            size: 30,
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Camera')
                    ],
                  ),
                ),
                Spacer(),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isUploadImage = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[400],
                        foregroundColor: Colors.black,
                        shadowColor: const Color.fromARGB(255, 109, 106, 105),
                        elevation: 5,
                        padding: EdgeInsets.all(2),
                        fixedSize: const Size(25, 5)),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                      ),
                    )),
                Spacer(),
                SizedBox(
                  height: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              isUploadImage = false;
                            });
                            chooseImage();
                          },
                          child: Icon(
                            Icons.image,
                            size: 30,
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Gallery')
                    ],
                  ),
                ),
                Spacer(),
              ],
              if (!isUploadImage)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_nameController.text.isEmpty ||
                              _descController.text.isEmpty ||
                              _priceController.text.isEmpty ||
                              _addressController.text.isEmpty ||
                              pressed == false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please fill in all the required fields'),
                              ),
                            );
                          } else {
                            showConfirmDialogue(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal[400],
                            foregroundColor: Colors.black,
                            shadowColor:
                                const Color.fromARGB(255, 109, 106, 105),
                            elevation: 5,
                            fixedSize: const Size(60, 40)),
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
