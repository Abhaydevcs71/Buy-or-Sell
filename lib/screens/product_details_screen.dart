import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

import 'package:second_store/screens/chat_conversation.dart';
import 'package:second_store/screens/sellitems/homescreen/home_screen.dart';
import 'package:second_store/screens/sellitems/homescreen/product_display/product_list.dart';
import 'package:second_store/services/firebase_services.dart';
import 'package:second_store/services/search_services.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String id = 'product-details-screen';

  ProductDetailsScreen({this.adId});

  var adId;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  // DocumentReference documentId =
  //     FirebaseFirestore.instance.collection("products").doc();

  var documentId;
  bool _loading = true;
  List<String> images = [];
  FirebaseService _service = FirebaseService();
  //final _format = NumberFormat('##,##,##0');
  var _name;
  var _description;
  var _price;
  var _adress;
  var _bhk;
  var _parking;
  var _date;
  var _sellerId;
  var _id;
  var _category;
  var _people;
  var _bathroom;
  var _gender;
  var _food;

  var _singleRoomPrice;
  var _doubleRoomPrice;
  var _familyRoomPrice;
  var _wifi;
  var _cleaning;
  var _phoneNumber;
  var _loc;

  @override
  void initState() {
    super.initState();
    // Load product details including images when the screen is opened
    loadProductDetails();
  }

  Future<void> loadProductDetails() async {
    try {
      var snapshot =
          await _service.products.where('docId', isEqualTo: widget.adId).get();
      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.first.data() as Map<String,
            dynamic>; // Access the first document in the snapshot

        // Update the state with the loaded data
        setState(() {
          _loading = false;

          images = List<String>.from(data['images']);
          _name = data['name'];
          _adress = data['adress'];
          _bhk = data['bhk'];
          _description = data['Description'];
          _parking = data['parking'];
          _date = (data['date'] as Timestamp).toDate();

          _price = data['Price'];
          _sellerId = data['userId'];
          _id = data['docId'];
          _category = data['Category'];
          _people = data['People'];
          _bathroom = data['bathroom'];
          _gender = data['gender'];
          _food = data['food'];

          _familyRoomPrice = data['familyRoomPrice'];
          _doubleRoomPrice = data['doubleRoomPrice'];
          _singleRoomPrice = data['singleRoomPrice'];
          _wifi = data['internet'];
          _cleaning = data['cleaningservice'];
          _phoneNumber = data['phoneNumber'];
          documentId = snapshot.docs.first.reference;
        });
      }
    } catch (error) {
      print('Error loading product details: $error');
      // Handle error here
    }
  }

  void openGoogleMaps() async {
    try {
      // Open Google Maps with the specified location
      String googleMapsUrl =
          'https://www.google.com/maps/search/?api=1&query=$_loc';
      await launch(googleMapsUrl);
    } catch (e) {
      print('Error opening Google Maps: $e');
    }
  }

  createChatRoom() {
    List<String> users = [
      _sellerId, // seller
      _service.user!.uid, // buyer
    ];

    String chatRoomId = '$_sellerId.${_service.user!.uid}.${_id}';

//print (chatRoomId);

    Map<String, dynamic> chatData = {
      'users': users,
      'chatRoomId': chatRoomId,
      'lastChat': null,
      'lastChatTime': DateTime.now().microsecondsSinceEpoch,
      'read': false,
      'image': images[0],
      'adtitle': _name
    };
    _service.createChatRoom(
      chatData: chatData,
    );

//open chat screen

    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ChatConversation(
          chatRoomId: chatRoomId,
          name1: '',
          profile: '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (_sellerId == _service.user!.uid)
            IconButton(
                onPressed: () async {
                  FirebaseFirestore.instance
                      .collection('products')
                      .doc(documentId.id)
                      .delete();
                  print(documentId.id);
                  await Future.delayed(Duration(seconds: 2), () {
                    Center(
                      child: CircularProgressIndicator(),
                    );
                  });
                  // Duration(seconds: 2);
                  // Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, HomeScreen.id);
                },
                icon: Icon(Icons.delete))
        ],
        backgroundColor: Colors.teal,
        title: Text(_name.toString()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: _loading
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor),
                              ),
                              SizedBox(height: 10),
                              Text('Loading images'),
                            ],
                          ),
                        )
                      : Container(
                          height: 330,
                          color: Colors.transparent,
                          child: FanCarouselImageSlider(
                            imagesLink: images,
                            initalPageIndex: 0,
                            isClickable: true,
                            userCanDrag: true,
                            isAssets: false,
                            autoPlay: true,
                            imageFitMode: BoxFit.cover,
                            sliderHeight: 300,
                            showIndicator: true,
                            sliderWidth: double.infinity,
                            indicatorActiveColor: Colors.teal,
                            indicatorDeactiveColor: Colors.blueGrey,
                            autoPlayInterval: const Duration(seconds: 4),
                            // currentItemShadow: [
                            //   BoxShadow(color: Colors.transparent)
                            // ],
                          ),
                        ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 130,
                  width: double.infinity,
                  // color: Colors.grey[350],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          _name.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 40),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          '₹ ${_price.toString()}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.grey[100],
                  width: double.infinity,
                  child: Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Description: ${_description.toString()}',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.normal),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Address: ${_adress.toString()}',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_date != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                  'Posted On: ${DateFormat.yMd().add_jm().format(_date)}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal)),
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Parking: ${_parking.toString()}',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_category.toString() == 'House' ||
                              _category.toString() == 'Apartment')
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                'BHK: ${_bhk.toString()}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_category.toString() == 'PG' ||
                              _category.toString() ==
                                  'Hostel') //create a column for addiing two text widgets by checking with one if condition
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Number of people in a room: ${_people.toString()}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Bathroom facility: ${_bathroom.toString()}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ]),
                          SizedBox(
                            height: 10,
                          ),
                          if (_category.toString() == 'Hostel')
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                'Only for: ${_gender.toString()}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_category.toString() == 'Hostel' ||
                              _category.toString() == 'Hotel')
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                'Food facility: ${_food.toString()}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_category.toString() ==
                              'Hotel') //create a column for addiing two text widgets by checking with one if condition
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Price of Single Room: ${_singleRoomPrice.toString()}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Price of Double Room: ${_doubleRoomPrice.toString()}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Price of Family Room: ${_familyRoomPrice.toString()}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Internet facility: ${_wifi.toString()}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Room cleaning facility: ${_cleaning.toString()}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  'Phone Number: ${_phoneNumber.toString()}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: ElevatedButton.icon(
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.teal),
                                        minimumSize: MaterialStatePropertyAll(
                                            Size(10, 10))),
                                    onPressed: () async {
                                      if (_phoneNumber != null) {
                                        final Uri url = Uri(
                                            scheme: 'tel',
                                            path: _phoneNumber.toString());
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url);
                                        } else {
                                          print('cannot launch this Url');
                                        }
                                      }
                                    },
                                    icon: Icon(Icons.call_outlined),
                                    label: Text('Call')),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                _sellerId == _service.user!.uid
                    ? SizedBox()
                    : Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            createChatRoom();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            textStyle: TextStyle(fontSize: 18),
                          ),
                          child: Text('Chat Now'),
                        ),
                      ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'User details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                //ad Posted user details
                Container(
                  height: 120,
                  color: Colors.teal,
                  child: Center(
                      child: Text(
                    'Ad posted user account part',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  )),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Ad Posted at',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    openGoogleMaps();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromARGB(255, 147, 209, 175),
                      ),
                      width: 200,
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'View on Map',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Container(
                //   height: 120,
                //   color: Colors.teal,
                //   child: Center(
                //       child: Text(
                //     'Ad posted Location',
                //     style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         color: Colors.white,
                //         fontSize: 20),
                //   )),
                // ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
            if (_loading = false)
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              )
          ],
        )),
      ),
    );
  }
}
