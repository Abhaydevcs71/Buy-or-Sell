import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:second_store/screens/login_screen.dart';
import 'package:second_store/services/firebase_services.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({
    super.key,
  });

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  // final //QueryDocumentSnapshot<Object?> data;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  FirebaseService _service = FirebaseService();

  @override
  Widget build(BuildContext context) {
//SignOut function

    //  CollectionReference users = FirebaseFirestore.instance.collection('users');
    void fetchUserData() async {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {
        // Reference to the "users" collection
        CollectionReference users =
            FirebaseFirestore.instance.collection('users');

        // Query the user document based on the email field
        QuerySnapshot querySnapshot =
            await users.where('email', isEqualTo: user.email).get();

        // Check if there is a matching document
        if (querySnapshot.docs.isNotEmpty) {
          // Retrieve the user data from the first document
          var userData =
              querySnapshot.docs.first.data() as Map<String, dynamic>;

          // Access specific fields, for example, the 'name' field
          var address = userData?['address'];
          var city = userData?['city'];
          var country = userData?['counntry'];

          print('User ID: ${user.uid}');
          print('User Email: ${user.email}');
          print('User city: $address');
          // Add more fields as needed
        } else {
          print('No matching document found in the "users" collection.');
        }
      } else {
        print('User is not signed in.');
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Account'),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            color: Colors.blue,
            child: Row(
              children: [
                Container(
                  height: double.infinity,
                  width: 120,
                  child: Center(
                      child: CircleAvatar(
                    radius: 40,
                    onBackgroundImageError: (exception, stackTrace) {
                      Text('loading');
                    },
                    backgroundImage: NetworkImage(
                        'https://w7.pngwing.com/pngs/87/237/png-transparent-male-avatar-boy-face-man-user-flat-classy-users-icon.png'),
                  )),
                ),

                // Container(
                //   color: Colors.yellow,
                // )
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User id:${user!.uid.toString()}',
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text('Email: ${user!.email.toString()}')
                  ],
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 200,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: double.infinity,
                    width: double.infinity / .5,
                    color: Colors.yellow,
                    margin: EdgeInsets.only(right: 2, top: 5),
                    child: Center(child: Text('Myad with number')),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: double.infinity,
                    width: double.infinity / .5,
                    color: Colors.red,
                    margin: EdgeInsets.only(left: 2, top: 5),
                    child: Center(child: Text('favorites with number')),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, LoginScreen.id);
              },
              child: Text('SignOut'))
        ],
      ),
    );
  }
}
