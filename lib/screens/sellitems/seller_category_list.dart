import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:second_store/forms/apartment/apartment_seller_form.dart';
import 'package:second_store/forms/hostel/hostel_seller_form.dart';
import 'package:second_store/forms/hotel/hotel_seller_form.dart';
import 'package:second_store/forms/house/house_seller_form.dart';
import 'package:second_store/forms/pg/pg_seller_form.dart';
//import 'package:second_store/forms/pg_seller_form.dart';

import 'package:second_store/screens/home/home_screen.dart';
//import 'package:second_store/screens/sellitems/seller_subCat.dart';
import 'package:second_store/services/firebase_services.dart';

class SellerCategory extends StatelessWidget {
  static const String id = 'seller-category-list-screen';

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 221, 158, 171),
        elevation: 0,
        shape: Border(bottom: BorderSide(color: Colors.grey)),
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Choose categories',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: FutureBuilder<QuerySnapshot>(
            future: _service.categories.get(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Container();
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else
                debugPrint(snapshot.data!.docs.toString());
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var doc = snapshot.data!.docs[index];

                      return Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                              visualDensity: VisualDensity(vertical: -3),
                              leading: Image.network(
                                snapshot.data!.docs[index]['image'],
                                width: 40,
                              ),
                              title: Text(
                                snapshot.data!.docs[index]['catName'],
                                style: TextStyle(fontSize: 15),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                              ),
                              onTap: () {
                                if (snapshot.data!.docs[index]['catName'] ==
                                    'PG') {
                                  Navigator.pushNamed(context, PgSellerForm.id);
                                } else if (snapshot.data!.docs[index]
                                        ['catName'] ==
                                    'Hostel') {
                                  Navigator.pushNamed(
                                      context, HostelSellerForm.id);
                                } else if (snapshot.data!.docs[index]
                                        ['catName'] ==
                                    'House') {
                                  Navigator.pushNamed(
                                      context, HouseSellerForm.id);
                                } else if (snapshot.data!.docs[index]
                                        ['catName'] ==
                                    'Hotel') {
                                  Navigator.pushNamed(
                                      context, HotelSellerForm.id);
                                } else if (snapshot.data!.docs[index]
                                        ['catName'] ==
                                    'Apartment') {
                                  Navigator.pushNamed(
                                      context, ApartmentSellerForm.id);
                                }
                              }),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
