import 'package:dialogs/dialogs/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second_store/constants/constants.dart';
import 'package:second_store/services/phoneauth_services.dart';

class PhoneAuthScreen extends StatefulWidget {
  static const String id = 'phone_authScreen';
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  bool validate = false;
  var countryCodeController = TextEditingController(text: '+91');
  var phoneNumberController = TextEditingController();

  PhoneAuthServices _services = PhoneAuthServices();

  @override
  Widget build(BuildContext context) {
    //Create an instance of ProgressDialog
    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      loadingText: 'Please wait',
      progressIndicatorColor: Theme.of(context).primaryColor,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: AppColors.whiteColor,
        iconTheme: const IconThemeData(color: AppColors.blackColor),
        title: const Text(
          'Login',
          style: TextStyle(
            color: AppColors.blackColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.red.shade200,
              child: const Icon(
                CupertinoIcons.person_alt_circle,
                color: Colors.red,
                size: 60,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              'Enter your phone',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'We will send confirmation code to your phone',
              style: TextStyle(color: AppColors.greyColor),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: countryCodeController,
                    //enabled: false,
                    decoration: const InputDecoration(labelText: 'Country'),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    onChanged: (value) {
                      if (value.length == 10) {
                        setState(() {
                          validate = true;
                        });
                      }
                      if (value.length < 10) {
                        setState(() {
                          validate = false;
                        });
                      }
                    },
                    autofocus: true,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    controller: phoneNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Number',
                      hintText: 'Enter your phone Number',
                      hintStyle:
                          TextStyle(fontSize: 10, color: AppColors.greyColor),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: AbsorbPointer(
            absorbing: validate ? false : true,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: validate
                        ? MaterialStateProperty.all(
                            Theme.of(context).primaryColor)
                        : MaterialStateProperty.all(AppColors.greyColor)),
                onPressed: () {
                  progressDialog.show();
                  String number =
                      '${countryCodeController.text}${phoneNumberController.text}';

                  progressDialog.show();
                  _services.verifyPhoneNumber(context, number);
                },
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Next',
                    style: TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
