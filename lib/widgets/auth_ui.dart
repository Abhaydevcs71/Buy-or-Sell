import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:second_store/constants/constants.dart';

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
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(AppColors.whiteColor)),
                onPressed: () {},
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
          SignInButton(Buttons.Google,
              text: 'Continue with Google', onPressed: () {}),
          SignInButton(Buttons.FacebookNew,
              text: 'Continue with Facebook', onPressed: () {}),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'OR',
              style: TextStyle(
                  color: AppColors.whiteColor, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Login with Email',
              style: TextStyle(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }
}
