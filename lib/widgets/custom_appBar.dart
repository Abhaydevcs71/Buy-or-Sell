import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second_store/constants/constants.dart';
import 'package:second_store/screens/location_screen.dart';
import 'package:second_store/services/firebase_services.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

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
            // check the next one

            GeoPoint latLong = data['location'];
            _service
                .getAddress(latLong.latitude, latLong.longitude)
                .then((adrs) {
              // show this address in appbar
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
          Navigator.pushNamed(context, LocationScreen.id);
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
    );
  }
}
