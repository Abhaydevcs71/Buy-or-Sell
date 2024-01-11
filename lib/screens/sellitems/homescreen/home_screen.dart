import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:second_store/constants/constants.dart';
import 'package:second_store/screens/location_screen.dart';
import 'package:second_store/screens/login_screen.dart';
import 'package:second_store/screens/sellitems/homescreen/product_display/product_list.dart';
import 'package:second_store/widgets/banner_widget.dart';
import 'package:second_store/widgets/category_widget.dart';
import 'package:second_store/widgets/custom_appBar.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';

  const HomeScreen({super.key});

  // final LocationData? locationData;

  // const HomeScreen({super.key, this.locationData});
  //we are getting latilude and longitude here

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String address = 'India';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.red,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: SafeArea(child: CustomAppBar()),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: AppColors.whiteColor,
              child: Padding(
                padding: EdgeInsets.fromLTRB(12, 10, 12, 8),
                child: Column(
                  children: [BannerWidget(), CategoryWidget()],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            //Product list
            ProductList(true)
          ],
        ),
      ),
    );
  }
}
