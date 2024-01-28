import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:second_store/constants/constants.dart';
import 'package:second_store/screens/login/location_screen.dart';
import 'package:second_store/screens/login/login_screen.dart';
import 'package:second_store/screens/product_display/product_list.dart';
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
        child: SafeArea(
          child: CustomAppBar(),
        ),
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
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          BannerWidget(
                              cat: 'HOSTEL',
                              img:
                                  'https://firebasestorage.googleapis.com/v0/b/secondstore-62b29.appspot.com/o/categories%2Fhostel.png?alt=media&token=9966ce36-c34a-42b1-b6b5-4333ebb5d449'),
                          SizedBox(
                            width: 5,
                          ),
                          BannerWidget(
                            cat: 'PG',
                            img:
                                'https://firebasestorage.googleapis.com/v0/b/secondstore-62b29.appspot.com/o/categories%2FPG.png?alt=media&token=0f1eaa88-7ef9-4321-9cd5-f365b13f02fe',
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          BannerWidget(
                            cat: 'HOUSE',
                            img:
                                'https://firebasestorage.googleapis.com/v0/b/secondstore-62b29.appspot.com/o/categories%2Fhouse.png?alt=media&token=94ecf97a-7f60-4f12-a935-27007fcb8edb',
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          BannerWidget(
                            cat: 'HOTEL',
                            img:
                                'https://firebasestorage.googleapis.com/v0/b/secondstore-62b29.appspot.com/o/categories%2Fdoor.png?alt=media&token=75f426f0-0d2b-431d-8d52-86893d61fe8d',
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          BannerWidget(
                            cat: 'APARTMENT',
                            img:
                                'https://firebasestorage.googleapis.com/v0/b/secondstore-62b29.appspot.com/o/categories%2Fdormitory.png?alt=media&token=debe3bc8-7cc8-4b5f-bf14-1f938fdf45d4',
                          ),
                        ],
                      ),
                    ),
                    CategoryWidget()
                  ],
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
