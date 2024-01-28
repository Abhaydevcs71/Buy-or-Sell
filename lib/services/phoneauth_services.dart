//import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialogs/dialogs/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:second_store/screens/authentication/otp_screen.dart';
import 'package:second_store/screens/login/location_screen.dart';
import 'package:second_store/screens/login/profile.dart';

class PhoneAuthServices {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(context, uid) async {
    final QuerySnapshot result = await users.where('uid', isEqualTo: uid).get();

    List<DocumentSnapshot> document = result.docs; //list of users data

    if (document.length > 0) {
      //user data exist
      //skip firestore
      Navigator.pushReplacementNamed(context, ProfileForm.id);
    } else {
      //user data not exist
      //add user data to firestore
      return users.doc(user?.uid).set({
        'uid': user?.uid, // user id
        'mobile': user?.phoneNumber, // phone number
        'email': user?.email // email
      }).then((value) {
        Navigator.pushReplacementNamed(context, ProfileForm.id);
      }).catchError((error) => print("Failed to add user: $error"));
    }
  }

  Future<void> verifyPhoneNumber(BuildContext context, number) async {
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      await auth
          .signInWithCredential(credential); //after verification need to signin
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      //if verification faild ,it will show the reson
      if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
      }
      print('The error is ${e.code}');
    };
    final PhoneCodeSent codeSent = (String verId, int? resendToken) async {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPScreen(
              number: number,
              verId: verId,
            ),
          ));
    };
    try {
      auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          timeout: Duration(minutes: 1),
          codeAutoRetrievalTimeout: (String verificationId) {
            print(verificationId);
          });
    } catch (e) {
      print('Error ${e.toString()}');
    }
  }
}
