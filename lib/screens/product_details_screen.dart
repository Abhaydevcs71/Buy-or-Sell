import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:second_store/constants/constants.dart';
import 'package:second_store/screens/chat_conversation.dart';
import 'package:second_store/services/firebase_services.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String id = 'product-details-screen';

  ProductDetailsScreen({this.adId});

  var adId;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool _loading = true;
  List<String> images = [];
  FirebaseService _service = FirebaseService();
  final _format = NumberFormat('##,##,##0');
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
        setState(() {
          // Update the state with the loaded data
          _loading = false;
          images = List<String>.from(data?['images']);
          _name = data?['name'];
          _adress = data?['adress'];
          _bhk = data?['bhk'];
          _description = data?['Description'];
          _parking = data['parking'];
          _date = (data?['date'] as Timestamp).toDate();
          _price = data?['Price'];
          _sellerId = data['userId'];
          _id = data['docId'];
          _category = data?['Category'];
          _people = data?['People'];
          _bathroom = data?['bathroom'];
          _gender = data?['gender'];
          _food = data?['food'];

          _familyRoomPrice = data?['familyRoomPrice'];
          _doubleRoomPrice = data?['doubleRoomPrice'];
          _singleRoomPrice = data?['singleRoomPrice'];
          _wifi = data?['internet'];
          _cleaning = data?['cleaningservice'];
        });
      }
    } catch (error) {
      print('Error loading product details: $error');
      // Handle error here
    }
  }

  createChatRoom() {
    List<String> users = [
      _sellerId, // seller
      _service.user!.uid, // buyer
    ];

// chat room id

    String chatRoomId = '$_sellerId.${_service.user!.uid}.${_id}';

//print (chatRoomId);

Map<String,dynamic> chatData ={
  'users' : users,
  'chatRoomId' : chatRoomId,
  'lastChat' : null,
  'lastChatTime' : DateTime.now().microsecondsSinceEpoch,

};

_service.createChatRoom(
  chatData: chatData,
);


//open chat screen 

Navigator.push<void>(
    context,
    MaterialPageRoute<void>(
      builder: (BuildContext context) => ChatConversation(chatRoomId: chatRoomId,),
    ),
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(_name),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
                          autoPlayInterval: Duration(seconds: 4),
                          currentItemShadow: [
                            BoxShadow(color: Colors.transparent)
                          ],
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
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                              'Posted On: ${DateFormat.yMd().add_jm().format(_date)}',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.normal)),
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
                      ],
                    ),
                  ),
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
            );
           _sellerId== _service.user!.uid ? Container() : Positioned(
              right: 10,
              bottom: 10,
              child: FloatingActionButton(
                onPressed: () {
                  createChatRoom();
                },
                child: Text('chat'),
              ),
            )
          ,
              SizedBox(
                height: 10,
              ),
              // Ad Location part
              Container(
                height: 220,
                color: Colors.teal,
                child: Center(
                    child: Text(
                  'Show location part',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20),
                )),
              ),
            ,
          ),
        ),
      ),
    
  }
}
