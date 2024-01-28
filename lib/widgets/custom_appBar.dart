import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second_store/constants/constants.dart';
import 'package:second_store/screens/login/location_screen.dart';
import 'package:second_store/services/firebase_services.dart';
import 'package:second_store/services/search_services.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  FirebaseService _service = FirebaseService();
  SearchServices _search = SearchServices();
  late Future<List<Products>> productsFuture;
  List<Products> products = [];

  Future<List<Products>> loadProducts() async {
    try {
      print('Loading products...');
      QuerySnapshot snapshot = await _service.products.get();
      print('Products loaded: ${snapshot.docs.length}');

      List<Products> productList = snapshot.docs.map((doc) {
        return Products(
          doc: doc,
          title: doc['name'],
          category: doc['Category'],
          description: doc['Description'],
          postedDate: doc['date'],
          price: doc['Price'],
        );
      }).toList();

      setState(() {
        products = productList;
      });

      print('Total products loaded: ${products.length}');
      return products;
    } catch (e) {
      print('Error loading products: $e');
      return []; // Return an empty list in case of an error
    }
  }

  @override
  void initState() {
    super.initState();
    productsFuture = loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _service.users.doc(_service.user?.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Location not selected");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          if (data['address'] == null) {
            GeoPoint latLong = data['location'];
            _service
                .getAddress(latLong.latitude, latLong.longitude)
                .then((adrs) {
              return appBar(adrs, context);
            });
          } else {
            return appBar(data['address'], context);
          }
        }

        return Text("Fetching location...");
      },
    );
  }

  Widget appBar(address, context) {
    return AppBar(
      backgroundColor: AppColors.whiteColor,
      elevation: 0.0,
      title: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => LocationScreen(
                locationChanging: true,
              ),
            ),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  CupertinoIcons.location_solid,
                  color: AppColors.blackColor,
                  size: 18,
                ),
                Flexible(
                  child: Text(
                    address,
                    style: const TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: AppColors.blackColor,
                  size: 18,
                )
              ],
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: InkWell(
          onTap: () {},
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onTap: () {
                        print('Products count: ${products.length}');
                        _search.search(
                          context: context,
                          productList: products,
                        );
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 25,
                        ),
                        labelText: 'Search by title',
                        labelStyle: const TextStyle(fontSize: 18),
                        contentPadding:
                            const EdgeInsets.only(left: 10, right: 10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
