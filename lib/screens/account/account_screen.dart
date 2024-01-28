import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:second_store/screens/login/login_screen.dart';
import 'package:second_store/screens/home/home_screen.dart';
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
String? num;

class _AccountScreenState extends State<AccountScreen> {
  Future<void> fetchData() async {
    QuerySnapshot doc = await users.where('uid', isEqualTo: user!.uid).get();

    var userData = doc.docs.first.data() as Map<String, dynamic>;
    setState(() {
      profile = userData['profile'];
      name = userData['firstName'];
      name2 = userData['secondName'];
      num = userData['phone'];
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.account_circle_outlined),
            SizedBox(
              width: 10,
            ),
            Text(
              'Profile',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 221, 158, 171),
        elevation: 5,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: [
            Container(
              height: MediaQuery.sizeOf(context).height * 0.43,
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                children: [
                  const SizedBox(
                    height: 14,
                  ),
                  ClipRRect(
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
                                profile,
                                fit: BoxFit.cover,
                                width: 220,
                                height: 220,
                              )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (name != null)
                    Text(
                      name! + ' ' + name2.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    user!.email.toString(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    num.toString(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            InkWell(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                width: MediaQuery.sizeOf(context).width,
                child: const Row(
                  children: [
                    Icon(
                      Icons.logout,
                      size: 35,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      'LOG OUT',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, LoginScreen.id);
              },
            )
          ],
        ),
      ),
    );
  }
}
