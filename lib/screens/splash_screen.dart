import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:second_store/constants/constants.dart';
import 'package:second_store/screens/login/location_screen.dart';
import 'package:second_store/screens/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        const Duration(
          seconds: 4,
        ), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          //not signedin
          Navigator.pushReplacementNamed(context, LoginScreen.id);
        } else {
          //if user already Signedin
          Navigator.pushReplacementNamed(context, LocationScreen.id);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      AppColors.greyColor,
      AppColors.whiteColor,
    ];

    const colorizeTextStyle = TextStyle(
      fontSize: 30.0,
      fontFamily: 'Lato',
    );

    return Scaffold(
      //backgroundColor:Color.fromARGB(255, 221, 158, 171),
      extendBodyBehindAppBar: true,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/stay.jpeg',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              //color: AppColors.whiteColor,
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            // SizedBox(
            //   width: 250.0,
            //   child: AnimatedTextKit(
            //     animatedTexts: [
            //       ColorizeAnimatedText(
            //         'Buy or Sell',
            //         textAlign: TextAlign.center,
            //         textStyle: colorizeTextStyle,
            //         colors: colorizeColors,
            //       ),
            //     ],
            //     isRepeatingAnimation: true,
            //     onTap: () {
            //       print("Tap Event");
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
