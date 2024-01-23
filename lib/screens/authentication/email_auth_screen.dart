import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second_store/screens/authentication/reset_password_screen.dart';
import 'package:second_store/services/emailAuth_services.dart';

import '../../constants/constants.dart';

class EmailAuthScreen extends StatefulWidget {
  static const String id = 'emailAuth-screen';
  const EmailAuthScreen({super.key});

  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _validate = false;
  bool _login = false;
  bool _loading = false;

  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  EmailAuthentication _service = EmailAuthentication();

  _validateEmail() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _validate = false;
        _loading = true;
      });

      _service
          .getAdminCredential(
              context: context,
              isLog: _login,
              email: _emailController.text,
              password: _passwordController.text)
          .then((value) {
        setState(() {
          _loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Color.fromARGB(255, 221, 158, 171),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Login',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              CircleAvatar(
                radius: 30,
                //backgroundColor: Colors.red.shade200,
                child: const Icon(
                  CupertinoIcons.person_alt_circle,
                  color: Color.fromARGB(255, 221, 158, 171),
                  size: 60,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                'Enter to ${_login ? 'Login' : 'Register'}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Enter Email and Password to ${_login ? 'Login' : 'Register'}',
                style:
                    const TextStyle(color: AppColors.greyColor, fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  final bool isValid =
                      EmailValidator.validate(_emailController.text);
                  if (value == null || value.isEmpty) {
                    return 'Enter Email';
                  }
                  if (value.isNotEmpty && isValid == false) {
                    return 'Enter valid Email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  contentPadding: const EdgeInsets.only(left: 10),
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  suffixIcon: _validate
                      ? IconButton(
                          onPressed: () {
                            _passwordController.clear();
                            setState(() {
                              _validate = false;
                            });
                          },
                          icon: const Icon(Icons.clear))
                      : null,
                  contentPadding: EdgeInsets.only(left: 10),
                  filled: true,
                  labelText: 'Password',
                  fillColor: Colors.grey.shade300,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onChanged: (value) {
                  if (_emailController.text.isNotEmpty) {
                    if (value.length > 3) {
                      setState(() {
                        _validate = true;
                      });
                    } else {
                      setState(() {
                        _validate = false;
                      });
                    }
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: _login ? Text(
                      'Forgot password?',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ) : SizedBox(),
                    onPressed: () {
                      Navigator.pushNamed(context, PasswordResetScreen.id);
                    },
                  )),
              Row(
                children: [
                  Text(
                      _login ? 'New Account ? ' : 'Already have an Account ? '),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _login = !_login;
                        });
                      },
                      child: Text(
                        _login ? 'Register' : 'Login ',
                        style: const TextStyle(fontWeight: FontWeight.bold,color: Color.fromARGB(255, 131, 144, 209),),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: AbsorbPointer(
            absorbing: _validate ? false : true,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: _validate
                        ? MaterialStateProperty.all(
                            Theme.of(context).primaryColor)
                        : MaterialStateProperty.all(AppColors.greyColor)),
                onPressed: () {
                  _validateEmail();
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: _loading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          ' ${_login ? 'Login' : 'Register'}',
                          style: const TextStyle(
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
