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

  ProductDetailsScreen({required this.productId});

  final String productId;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool _loading = true;
  List<String> images = [];
  FirebaseService _service = FirebaseService();
  final _format = NumberFormat('##,##,##0');
    var  _name;
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
          await _service.products.doc(widget.productId).get();
      if (snapshot.exists) {
        setState(() {
          // Update the state with the loaded data
          _loading = false;
          images = List<String>.from(snapshot['images']);
          _name= snapshot['name'];
          _adress= snapshot['adress'];
          _bhk= snapshot['bhk'];
          _description= snapshot['description'];
          _parking= snapshot['parking'];
          _date= snapshot['date'];
          _price = snapshot['Price'];
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
                child: Text(_name.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40
                ),
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
                child: Text(_price.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40
                ),
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
                child: Text(_adress.toString(),
                style: TextStyle(
                  fontSize:25 
                ),
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
                child: Text(_bhk.toString(),
                style: TextStyle(
                  fontSize: 20
                ),
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
                child: Text(_parking.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40
                ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
