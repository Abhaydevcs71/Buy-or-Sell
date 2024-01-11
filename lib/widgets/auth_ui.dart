import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:second_store/constants/constants.dart';
import 'package:second_store/screens/authentication/email_auth_screen.dart';
import 'package:second_store/screens/authentication/email_verification_screen.dart';
import 'package:second_store/screens/authentication/google_auth.dart';
import 'package:second_store/screens/authentication/phoneauth_screen.dart';
import 'package:second_store/services/phoneauth_services.dart';

class AuthUi extends StatelessWidget {
  const AuthUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 220,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // shape: ,
                  backgroundColor: AppColors.whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, PhoneAuthScreen.id);
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.phone_android_outlined,
                      color: AppColors.blackColor,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Continue with phone',
                      style: TextStyle(color: AppColors.blackColor),
                    )
                  ],
                )),
          ),
          SignInButton(Buttons.Google, text: 'Continue with Google',
              onPressed: () async {
            User? user =
                await GoogleAuthentication.signInWithGoogle(context: context);
            if (user != null) {
              //login success

              PhoneAuthServices _authentication = PhoneAuthServices();
              _authentication.addUser(context, user.uid);
            }
          }),
          // SignInButton(Buttons.FacebookNew,
          //     text: 'Continue with Facebook', onPressed: () {}),
           const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'OR',
              style: TextStyle(
                  color: AppColors.whiteColor, fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, EmailAuthScreen.id);

            },
            child: Container(
              child: Text(
                'Login with Email',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
