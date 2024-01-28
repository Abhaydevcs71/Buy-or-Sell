import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:search_page/search_page.dart';
import 'package:second_store/screens/product_display/product_details_screen.dart';
import 'package:second_store/screens/product_display/product_list.dart';

class Products {
  final String? title, description, category, price;
  final Timestamp? postedDate;
  final DocumentSnapshot? doc;

  Products(
      {this.title,
      this.description,
      this.category,
      this.price,
      this.postedDate,
      this.doc});
}

class SearchServices {
  search({context, productList}) {
    showSearch(
      context: context,
      delegate: SearchPage<Products>(
          // onQueryUpdate: (s) => print(s),
          items: productList,
          searchLabel: 'Search products',
          suggestion: const SingleChildScrollView(child: ProductList(true)),
          failure: const Center(
            child: Text('No products found :('),
          ),
          filter: (products) {
            final title = (products.title ?? '').toLowerCase();
            final description = (products.description ?? '').toLowerCase();
            final category = (products.category ?? '').toLowerCase();

            // print('Filtering: $title, $description, $category');

            return [title, description, category];
          },
          builder: (Products) {
            final _format = NumberFormat('##,##,##0');
            var _price = int.parse(Products.price.toString());

            String _formatedPrice = '₹ ${_format.format(_price)}';

            var _date = Products.postedDate;

            var adId = Products.doc!['docId'];

            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsScreen(
                        adId: adId,
                      ),
                    ));
              },
              child: Container(
                height: 120,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 120,
                          child: Image.network(Products.doc!['images']
                              [0]), //for show only one image.
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (Products.category.toString() != 'Hotel')
                              Text(
                                _formatedPrice,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            Text(
                              Products.title.toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              'Posted at : ${DateFormat.yMd().add_jm().format(_date!.toDate())}',
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
