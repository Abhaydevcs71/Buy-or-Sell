import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:second_store/constants/constants.dart';
import 'package:second_store/screens/authentication/email_auth_screen.dart';
import 'package:second_store/screens/authentication/email_verification_screen.dart';
import 'package:second_store/screens/authentication/phoneauth_screen.dart';
import 'package:second_store/screens/authentication/reset_password_screen.dart';
import 'package:second_store/screens/home_screen.dart';
import 'package:second_store/screens/location_screen.dart';
import 'package:second_store/screens/login_screen.dart';
import 'package:second_store/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: AppColors.mainColor, fontFamily: 'Lato'),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        PhoneAuthScreen.id: (context) => const PhoneAuthScreen(),
        LocationScreen.id: (context) => const LocationScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        EmailAuthScreen.id: (context) => const EmailAuthScreen(),
        EmailVerificationScreen.id:(context)=>EmailVerificationScreen(),
        PasswordResetScreen.id:(context)=>PasswordResetScreen(),

      },
    );
    //  return FutureBuilder(
    //   future: Future.delayed(const Duration(seconds: 5)),

    //   builder: (context, AsyncSnapshot snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       //if its connecting screen will go to splash screen//
    //       return MaterialApp(
    //           debugShowCheckedModeBanner: false,
    //           theme: ThemeData(
    //               primaryColor: AppColors.mainColor, fontFamily: 'Lato'),
    //           home: SplashScreen());
    //     } else {
    //       return MaterialApp(
    //         debugShowCheckedModeBanner: false,
    //         theme: ThemeData(
    //             primaryColor: AppColors.mainColor, fontFamily: 'Lato'),
    //         home: const LoginScreen(),
    //         routes: {
    //           LoginScreen.id: (context) =>  LoginScreen(),
    //           PhoneAuthScreen.id: (context) =>  PhoneAuthScreen(),
    //           LocationScreen.id: (context) =>  LocationScreen(),
    //         },
    //       );
    //     }
    //   },
    // );
  }
}
