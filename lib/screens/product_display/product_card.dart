import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:second_store/screens/product_display/product_details_screen.dart';
import 'package:second_store/services/firebase_services.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatefulWidget {
  ProductCard({
    required this.data,
    required String formattedPrice,
  }) : _formattedPrice = formattedPrice;

  final QueryDocumentSnapshot<Object?> data;
  final String _formattedPrice;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  FirebaseService _service = FirebaseService();
  final _format = NumberFormat('##,##,##0');
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    getFav();
  }

  Future<void> getFav() async {
    try {
      var favCount = widget.data['favCount'] as List<dynamic>;

      setState(() {
        _isLiked = favCount.contains(_service.user!.uid);
      });
    } catch (error) {
      print('Error getting fav: $error');
    }
  }

  Future<void> updateFavCount() async {
    try {
      await _service.updateFavorite(!_isLiked, widget.data.id, context);

      setState(() {
        _isLiked = !_isLiked;
      });
    } catch (error) {
      print('Error updating fav count: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    var adId = widget.data['docId'];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              adId: adId,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).primaryColor, width: 0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 100,
                            child: Center(
                              child: Image.network(
                                widget.data['images'][0],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            widget._formattedPrice,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            widget.data['name'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(widget.data['Category']),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //like Button part
            Positioned(
              right: -10,
              top: -5,
              child: IconButton(
                icon: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                ),
                color: _isLiked ? Colors.red : Colors.black,
                onPressed: updateFavCount,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
