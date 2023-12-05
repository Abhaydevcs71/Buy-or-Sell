import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final List<File> _image = [];

  List<String> urlsList=[];
  bool uploading = false;
  double val = 0;

  chooseImage() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile!.path));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: [
          AppBar(
            elevation: 1,
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text(
              'Upload Images',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Column(
            children: [
              Stack(
                children: [
                  if (_image != null)
                    Positioned(
                      right: 30,
                      child: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                           // _image = null;
                          });
                        },
                      ),
                    ),
                  SingleChildScrollView(
                    child: Stack(
                      children: [
                        Container(
                          width:MediaQuery.of(context).size.width,
                          height:MediaQuery.of(context).size.width ,
                          padding: EdgeInsets.all(4),
                          child: GridView.builder(
                            itemCount: _image.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            itemBuilder: (context, index) {
                              return index == 0
                                  ? Center(
                                      child: IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          !uploading ? chooseImage() : null;
                                        },
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: FileImage(_image[index - 1]),
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ),
                        uploading
                            ? Center(
                                child: Column(
                                  children: [
                                    const Text('Uploading...'),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50, top: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Save'),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  chooseImage();
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
                        offset: Offset(0, 3), // changes position of the shadow
                      ),
                    ],
                  ),
                  child: const Text(
                    'Upload ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
