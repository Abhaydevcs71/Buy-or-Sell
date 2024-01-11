import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:second_store/screens/login_screen.dart';
import 'package:second_store/screens/sellitems/homescreen/home_screen.dart';
import 'package:second_store/services/firebase_services.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

FirebaseAuth auth = FirebaseAuth.instance;
User? user = auth.currentUser;
CollectionReference users = FirebaseFirestore.instance.collection('users');
FirebaseService _service = FirebaseService();

String profile = '';
String? name;
String? name2;



class _AccountScreenState extends State<AccountScreen> {

  Future<void> fetchData() async {
  QuerySnapshot doc = await users.where('uid', isEqualTo: user!.uid).get();

  var userData = doc.docs.first.data() as Map<String, dynamic>;
setState(() {
   profile = userData['profile'];
  name = userData['firstName'];
  name2 = userData['secondName'];
  
});
 
}
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Center(
            child: Container(
                //width: MediaQuery.sizeOf(context).width * 0.55,
                //height: MediaQuery.sizeOf(context).height * 0.3,
                child: ClipRRect(
              borderRadius: BorderRadius.circular(110),
              child: CircleAvatar(
                  radius: 110,
                  child: profile == ''
                      ? Image.network(
                          'https://w7.pngwing.com/pngs/87/237/png-transparent-male-avatar-boy-face-man-user-flat-classy-users-icon.png',
                          width: 220,
                          height: 220,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          profile,fit: BoxFit.cover,
                          width: 220,
                          height: 220,
                        )),
            )),
          ),
          Text(user!.uid),
          Text(user!.email.toString()),
          Text(name!+' '+name2.toString()),
          ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, LoginScreen.id);
              },
              child: Text('Log out'))
        ],
      ),
    );
  }
}
