import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:second_store/constants/constants.dart';
import 'package:second_store/screens/product_display/product_card.dart';
import 'package:second_store/services/firebase_services.dart';

class CategoryResultScreen extends StatelessWidget {
  static const String id = 'category-result-screen';

  final FirebaseService _service = FirebaseService();
  final NumberFormat _format = NumberFormat('##,##,##0');

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    String categoryName = args['catName'];
    print(categoryName);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Category Result'),
        backgroundColor: Color.fromARGB(255, 221, 158, 171),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: AppColors.whiteColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<QuerySnapshot>(
            future: _service.products
                .where('Category', isEqualTo: categoryName)
                .orderBy('date')
                .get(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

              var myAdsCount = snapshot.data!.size;

              return Column(
                children: [
                  Container(
                    height: 56,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Results ($myAdsCount)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 250,
                        childAspectRatio: 2 / 2.6,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: myAdsCount,
                      itemBuilder: (BuildContext context, int i) {
                        var data = snapshot.data!.docs[i];
                        var _price = int.parse(data['Price']);
                        String _formatedPrice = '₹ ${_format.format(_price)}';
                        return ProductCard(
                            data: data, formattedPrice: _formatedPrice);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
