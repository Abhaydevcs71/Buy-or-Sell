import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:second_store/constants/constants.dart';
import 'package:second_store/screens/location_screen.dart';
import 'package:second_store/screens/login_screen.dart';
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
        preferredSize: Size.fromHeight(26),
        child: SafeArea(child: CustomAppBar()),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 25,
                          ),
                          labelText: 'Search by city or hotel',
                          labelStyle: const TextStyle(fontSize: 18),
                          contentPadding:
                              const EdgeInsets.only(left: 10, right: 10)),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Icon(
                    Icons.notifications_none,
                    size: 25,
                  ),
                  const SizedBox(
                    width: 8,
                  )
                ],
              ),
            ),
          ),
         Padding(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Column(
              children: [
                BannerWidget(),
                CategoryWidget()
              ],
            ),
          )
        ],
      ),
    );
  }
}
