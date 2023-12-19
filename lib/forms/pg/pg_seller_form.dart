import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:second_store/forms/pg/user_review_screen.dart';
import 'package:second_store/screens/main_screen.dart';
import 'package:second_store/widgets/image_picker.dart';
import 'package:second_store/widgets/image_viewer.dart';

class PgSellerForm extends StatefulWidget {
  const PgSellerForm({super.key});

  static const String id = 'pg-form';

  @override
  State<PgSellerForm> createState() => _PgSellerFormState();
}

class _PgSellerFormState extends State<PgSellerForm> {
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

  void showConfirmDialogue(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Are you sure you want to save the details?'),
          actions: [
            TextButton(
              onPressed: () {
                addProducts().then((value) =>
                    Navigator.pushReplacementNamed(context, MainScreen.id));
                // Navigator.pushReplacementNamed(context, MainScreen.id); // Close the dialog and navigate to home screen
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  String? countPeople;
  String? countRoom;
  var PG;
  bool val = false;

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
    for (int i = 0; i < _image.length; i++) {
      uploadFile(i);
    }

    //Get current timestamp
    DateTime currentDate = DateTime.now();

    //Get current user
    User? user = FirebaseAuth.instance.currentUser;

    CollectionReference products =
        FirebaseFirestore.instance.collection('products');
    products.add({
      'name': _nameController.text,
      'Description': _descController.text,
      'Price': _priceController.text,
      'adress': _addressController.text,
      'images': imageUrls,
      'Rooms': countRoom,
      'People': countPeople,
      'Category': 'PG',
      'date': currentDate,
      'userId': user?.uid,
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
    // String? countPeople;
    // String? countRoom;

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
                      'Paying Guest',
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
                      hint: const Text('Select the number of persons allowed'),
                      value: countPeople,
                      onChanged: (String? newValue) {
                        setState(() {
                          countPeople = newValue!;
                        });
                      },
                      items: <String>['1', '2', '3', '4', '5', '6', '7', '8']
                          .map<DropdownMenuItem<String>>((String value) {
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
                      hint: const Text('Select the number of Rooms'),
                      value: countPeople,
                      onChanged: (String? newValue) {
                        setState(() {
                          countRoom = newValue!;
                        });
                      },
                      items: <String>['1', '2', '3', '4', '5', '6', '7', '8']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(
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
                        onPressed: () {
                          if (_nameController.text.isEmpty ||
                              _descController.text.isEmpty ||
                              _priceController.text.isEmpty ||
                              _addressController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please fill in all the required fields'),
                              ),
                            );
                          } else {
                            // addProducts().then((value) => Navigator.pushNamed(context, MainScreen.id));
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
