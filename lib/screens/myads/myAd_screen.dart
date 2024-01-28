import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:second_store/constants/constants.dart';
import 'package:second_store/screens/product_display/product_card.dart';
import 'package:second_store/services/firebase_services.dart';

class MyAdsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    final _format =
        NumberFormat('##,##,##0'); // to get price format look better

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'My Ads',
              style: TextStyle(color: Colors.black),
            ),
            bottom: TabBar(
                indicatorColor: Theme.of(context).primaryColor,
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                indicatorWeight: 6,
                tabs: [
                  Tab(
                    child: Text(
                      'Ads',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Favorites',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  )
                ]),
          ),
          body: TabBarView(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder<QuerySnapshot>(
                    future: _service.products
                        .where('userId', isEqualTo: _service.user?.uid)
                        .orderBy('date')
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        print('Error: ${snapshot.error}');
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 140, right: 140),
                          child: Center(
                            child: LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                              backgroundColor: AppColors.whiteColor,
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: [
                          Container(
                            height: 56,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'My Ads',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 250,
                                  childAspectRatio: 2 / 2.6,
                                  crossAxisSpacing: 0,
                                  mainAxisSpacing: 8,
                                ),
                                itemCount: snapshot.data!.size,
                                itemBuilder: (BuildContext context, int i) {
                                  var data = snapshot.data!.docs[i];
                                  var _price = int.parse(data['Price']);
                                  String _formatedPrice =
                                      '₹ ${_format.format(_price)}';
                                  return ProductCard(
                                      data: data,
                                      formattedPrice: _formatedPrice);
                                }),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder<QuerySnapshot>(
                    future: _service.products
                        .where('favCount', arrayContains: _service.user!.uid)
                        //.orderBy('date')
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        print('Error: ${snapshot.error}');
                        // return Text('Something went wrong');
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 140, right: 140),
                          child: Center(
                            child: LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                              backgroundColor: AppColors.whiteColor,
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: [
                          Container(
                            height: 56,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Favorites',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 250,
                                  childAspectRatio: 2 / 2.6,
                                  crossAxisSpacing: 0,
                                  mainAxisSpacing: 8,
                                ),
                                itemCount: snapshot.data!.size,
                                itemBuilder: (BuildContext context, int i) {
                                  var data = snapshot.data!.docs[i];
                                  var _price = int.parse(data['Price']);
                                  String _formatedPrice =
                                      '₹ ${_format.format(_price)}';

                                  return ProductCard(
                                      data: data,
                                      formattedPrice: _formatedPrice);
                                }),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
