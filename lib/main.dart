import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:second_store/constants/constants.dart';
import 'package:second_store/forms/pg_seller_form.dart';
import 'package:second_store/screens/authentication/email_auth_screen.dart';
import 'package:second_store/screens/authentication/email_verification_screen.dart';
import 'package:second_store/screens/authentication/phoneauth_screen.dart';
import 'package:second_store/screens/authentication/reset_password_screen.dart';
import 'package:second_store/screens/categories/category_list.dart';
import 'package:second_store/screens/categories/subCat_Screen.dart';
import 'package:second_store/screens/home_screen.dart';
import 'package:second_store/screens/location_screen.dart';
import 'package:second_store/screens/login_screen.dart';
import 'package:second_store/screens/main_screen.dart';
import 'package:second_store/screens/sellitems/seller_category_list.dart';
import 'package:second_store/screens/sellitems/seller_subCat.dart';
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
        SplashScreen.id: (context) =>  SplashScreen(),
        LoginScreen.id: (context) =>  LoginScreen(),
        PhoneAuthScreen.id: (context) =>  PhoneAuthScreen(),
        LocationScreen.id: (context) =>LocationScreen(),
        HomeScreen.id: (context) =>  HomeScreen(),
        EmailAuthScreen.id: (context) =>  EmailAuthScreen(),
        EmailVerificationScreen.id:(context)=>EmailVerificationScreen(),
        PasswordResetScreen.id:(context)=>PasswordResetScreen(),
        CategoryListScreen.id:(context)=>CategoryListScreen(),
        SubCatList.id:(context)=>SubCatList(),
        MainScreen.id:(context)=>MainScreen(),
        SellerSubCatList.id:(context)=>SellerSubCatList(),
        SellerCategory.id:(context)=>SellerCategory(),
        PgSellerForm.id:(context)=>PgSellerForm(),


      },
      
    );
    
  }
}
