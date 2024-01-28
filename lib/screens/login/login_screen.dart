import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:second_store/constants/constants.dart';
import 'package:second_store/screens/login/location_screen.dart';
import 'package:second_store/widgets/auth_ui.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'login_screen';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff3dfd5),
        body: Column(
          children: [
            Expanded(
                child: Container(
              width: MediaQuery.of(context).size.width,
              color: AppColors.whiteColor,
              child: Image.asset(
                'assets/images/stay.jpeg',
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                //color: AppColors.whiteColor,
              ),
            )),
            Expanded(
                child: Container(
              child: const AuthUi(),
            )),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'If you continue ,you are accepting\nTerms and Conditions and Privacy policy',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.whiteColor, fontSize: 10),
              ),
            )
          ],
        ));
  }
}
