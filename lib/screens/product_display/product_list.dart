import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second_store/constants/constants.dart';
import 'package:second_store/screens/product_display/product_card.dart';
import 'package:second_store/services/firebase_services.dart';
import 'package:intl/intl.dart';

class ProductList extends StatelessWidget {
  final bool? proScreen;

  const ProductList(bool bool, {super.key, this.proScreen});

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    final _format =
        NumberFormat('##,##,##0'); // to get price format look better

    return Container(
      width: MediaQuery.of(context).size.width,
      color: AppColors.whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<QuerySnapshot>(
          future: _service.products.get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.only(left: 140, right: 140),
                child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                  backgroundColor: AppColors.whiteColor,
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
                        'Fresh recomendation',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
                GridView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 250,
                      childAspectRatio: 2 / 2.6,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: snapshot.data!.size,
                    itemBuilder: (BuildContext context, int i) {
                      var data = snapshot.data!.docs[i];
                      var _price = int.parse(data[
                          'Price']); //price convert to int in firestore it is in string.
                      String _formatedPrice = '₹ ${_format.format(_price)}';

                      return ProductCard(
                          data: data, formattedPrice: _formatedPrice);

                      // data: data, formatedPrice: _formatedPrice);
                    }),
              ],
            );
          },
        ),
      ),
    );
  }
}
