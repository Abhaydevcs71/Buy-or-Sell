import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:second_store/screens/location_screen.dart';
import 'package:second_store/screens/sellitems/homescreen/home_screen.dart';
import 'package:second_store/services/firebase_services.dart';

class ProfileForm extends StatefulWidget {
  static const String id = 'profile-screen';

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  TextEditingController _firstName = TextEditingController();
  TextEditingController _secondName = TextEditingController();
  TextEditingController _date = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  FirebaseService _service = FirebaseService();
  String? gender;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String imgUrl = '';
  String pic = '';

  @override
  Widget build(BuildContext context) {
    // check if the user has already completed the profile
    //skips the page

    _service.users
        .doc(_service.user?.uid)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('firstName')) {
          if (document['firstName'] != null) {
            Navigator.pushReplacementNamed(context, HomeScreen.id);
          }
        }
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.green[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profile Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(110),
                    child: CircleAvatar(
                      radius: 110,
                      child: pic == ''
                          ? Image.network(
                              'https://w7.pngwing.com/pngs/87/237/png-transparent-male-avatar-boy-face-man-user-flat-classy-users-icon.png',
                              width: 220,
                              height: 220,
                              //color: Colors.blueGrey,
                            )
                          : Image.file(
                              File(pic),
                              width: 220,
                              height: 220,
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: IconButton(
                      iconSize: 40,
                      onPressed: () async {
                        ImagePicker profilePic = ImagePicker();
                        XFile? file = await profilePic.pickImage(
                            source: ImageSource.gallery);
                        print('${file?.path}');
                        setState(() {
                          pic = file!.path;
                        });

                        if (file == null) return;

                        String imgName =
                            DateTime.now().millisecondsSinceEpoch.toString();

                        // reference to storage

                        Reference referenceRoot =
                            FirebaseStorage.instance.ref();
                        Reference referenceDir =
                            referenceRoot.child('profiles');

                        //reference for the image

                        //Reference referencePicUpload = referenceDir.child('pic_name');
                        Reference referencePicUpload =
                            referenceDir.child(imgName);

                        try {
                          //store the pic
                          await referencePicUpload.putFile(File(file.path));
                          imgUrl = await referencePicUpload.getDownloadURL();
                        } catch (e) {}
                      },
                      icon: Icon(Icons.photo_camera),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _firstName,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25)),
                          fillColor: Colors.white70,
                          filled: true,
                          hintText: 'First Name',
                          focusColor: Colors.green),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _secondName,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)),
                        fillColor: Colors.white70,
                        filled: true,
                        hintText: 'Second Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your second name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(right: 120, left: 120),
                      child: DropdownButtonFormField<String>(
                        style: TextStyle(fontSize: 20),
                        alignment: Alignment.center,
                        dropdownColor: Colors.white,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          fillColor: Colors.white70,
                          filled: true,
                        ),
                        hint: const Text('Gender'),
                        value: gender,
                        onChanged: (String? newValue) {
                          setState(() {
                            gender = newValue!;
                          });
                        },
                        items: <String>['Man', 'Woman']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Select your gender';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(right: 80, left: 80),
                      child: TextFormField(
                        style: TextStyle(fontSize: 20),
                        controller: _date,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            fillColor: Colors.white70,
                            filled: true,
                            hintText: 'DOB',
                            suffixIcon: Icon(Icons.calendar_month),
                            focusColor: Colors.green),
                        readOnly: true,
                        onTap: () async {
                          DateTime? _picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1990),
                            lastDate: DateTime(2025),
                          );
                          if (_picked != null) {
                            setState(() {
                              _date.text = _picked.toString().split(" ")[0];
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Select your DOB';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _service.updateUser({
                        'firstName': _firstName.text,
                        'secondName': _secondName.text,
                        'gender': gender,
                        'dob': _date.text.toString(),
                        'profile': imgUrl,
                      }, context).then((value) {
                        Navigator.pushReplacementNamed(
                            context, LocationScreen.id);
                      });
                    }
                  },
                  child: Text(
                    'NEXT',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.teal)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
