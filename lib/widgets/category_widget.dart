import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:second_store/screens/product_display/category_result.dart';
import 'package:second_store/services/firebase_services.dart';

class CategoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: FutureBuilder<QuerySnapshot>(
          future: _service.categories.get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }

            return Container(
              height: 110,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('categories')),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          var doc = snapshot.data!.docs[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                var catName =
                                    snapshot.data!.docs[index]['catName'];
                                Navigator.pushNamed(
                                  context,
                                  CategoryResultScreen.id,
                                  arguments: {'catName': catName},
                                );
                              },
                              child: Container(
                                width: 60,
                                height: 50,
                                child: Column(children: [
                                  Image.network(doc['image']),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Flexible(
                                        child: Text(
                                      doc['catName'].toUpperCase(),
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 10),
                                    )),
                                  ),
                                ]),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
