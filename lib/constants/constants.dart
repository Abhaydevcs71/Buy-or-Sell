import 'package:flutter/material.dart';

class AppColors {
  static const Color mainColor = Color.fromARGB(255, 0, 96, 100);
  static const Color whiteColor = Colors.white;
  static const Color greyColor = Colors.grey;
  static const Color blackColor = Colors.black;
  
}

class AppImage {
  static Image iconImage = Image.asset(
    'assets/images/263142.png',
    height: 70,
    width: 70,
    color: AppColors.mainColor,
  );
}

class AppTexts {
  static Text loginScreenAppName = const Text(
    'Buy or Sell',
    style: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: AppColors.mainColor,
    ),
  );
}
