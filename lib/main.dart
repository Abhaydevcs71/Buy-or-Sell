import 'package:flutter/material.dart';
import 'package:second_store/constants/constants.dart';
import 'package:second_store/screens/login_screen.dart';
import 'package:second_store/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 300)),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          //if its connecting screen will go to splash screen//
          return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: SplashScreen()); //need to create this screen
        } else {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primaryColor: AppColors.mainColor, fontFamily: 'Lato'),
              home: const LoginScreen());
        }
      },
    );
  }
}
