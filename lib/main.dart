import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_store/constants/constants.dart';
import 'package:second_store/forms/apartment/apartment_seller_form.dart';

import 'package:second_store/forms/hostel/hostel_seller_form.dart';
import 'package:second_store/forms/hotel/hotel_seller_form.dart';
import 'package:second_store/forms/house/house_seller_form.dart';
import 'package:second_store/forms/pg/pg_seller_form.dart';

import 'package:second_store/screens/authentication/email_auth_screen.dart';
import 'package:second_store/screens/authentication/email_verification_screen.dart';
import 'package:second_store/screens/authentication/phoneauth_screen.dart';
import 'package:second_store/screens/authentication/reset_password_screen.dart';
import 'package:second_store/screens/product_display/category_result.dart';
import 'package:second_store/screens/login/gmap.dart';
import 'package:second_store/screens/product_display/product_details_screen.dart';
import 'package:second_store/screens/login/profile.dart';

import 'package:second_store/screens/home/home_screen.dart';
import 'package:second_store/screens/login/location_screen.dart';
import 'package:second_store/screens/login/login_screen.dart';
import 'package:second_store/screens/home/main_screen.dart';
import 'package:second_store/screens/sellitems/seller_category_list.dart';

import 'package:second_store/screens/splash_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
    // argument for `webProvider`
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    // appleProvider: AppleProvider.appAttest,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color.fromARGB(255, 221, 158, 171),
          fontFamily: 'Lato',
          primarySwatch: Colors.blueGrey),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        PhoneAuthScreen.id: (context) => PhoneAuthScreen(),
        ProfileForm.id: (context) => ProfileForm(),
        LocationScreen.id: (context) => LocationScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        EmailAuthScreen.id: (context) => EmailAuthScreen(),
        EmailVerificationScreen.id: (context) => EmailVerificationScreen(),
        PasswordResetScreen.id: (context) => PasswordResetScreen(),
        MainScreen.id: (context) => MainScreen(),
        SellerCategory.id: (context) => SellerCategory(),
        PgSellerForm.id: (context) => PgSellerForm(),
        HostelSellerForm.id: (context) => HostelSellerForm(),
        HouseSellerForm.id: (context) => HouseSellerForm(),
        HotelSellerForm.id: (context) => HotelSellerForm(),
        ApartmentSellerForm.id: (context) => ApartmentSellerForm(),
        MapScreen.id: (context) => MapScreen(),
        ProductDetailsScreen.id: (context) => ProductDetailsScreen(),
        CategoryResultScreen.id: (context) => CategoryResultScreen(),
      },
    );
  }
}
