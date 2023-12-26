import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:second_store/constants/constants.dart';
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
          _description = data?['description'];
          _parking = data?['parking'];
          _date = data?['date'];
          _price = data?['Price'];
        });
      }
    } catch (error) {
      print('Error loading product details: $error');
      // Handle error here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
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
                          Text('Loading your ad'),
                        ],
                      ),
                    )
                  : FanCarouselImageSlider(
                      imagesLink: images,
                      isAssets: false,
                      autoPlay: false,
                      imageFitMode: BoxFit.cover,
                      sliderHeight: 300,
                    ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 70),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  _name.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 70),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  _price.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 70),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  _adress.toString(),
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 70),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  _bhk.toString(),
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 70),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  _parking.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                ),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: FloatingActionButton(
                onPressed: () {},
                child: Text('chat'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
