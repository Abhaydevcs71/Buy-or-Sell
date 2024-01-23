import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:second_store/screens/authentication/email_auth_screen.dart';
 class PasswordResetScreen extends StatelessWidget {
  static const String id= 'password-reset-screen';

  @override
  Widget build(BuildContext context) {

    var _emailController= TextEditingController();
    final _formKey= GlobalKey<FormState>(); 

    return Scaffold(
      body: Form(
        key:_formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock,color: Theme.of(context).primaryColor,size:75),
                SizedBox(height: 10,),
                Text('Forgot password?',
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,
                color: Theme.of(context).primaryColor),),SizedBox(height: 8,),
                Text('Send us your email,\nwe will send link to reset your password',
                textAlign:TextAlign.center,
                style:TextStyle(color: Colors.grey)),SizedBox(height: 8,),
                SizedBox(height:10),
                 TextFormField(
                  textAlign: TextAlign.center,
                    obscureText: true,
                    controller: _emailController ,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      labelText: 'Registered Email',
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
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
                    
                    
                  ),SizedBox(height: 20,),
                  ElevatedButton(
                  
            style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
            
                  
                  child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('send'),
                  ),
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                 FirebaseAuth.instance.sendPasswordResetEmail(email:_emailController.text).then((value) {
                  Navigator.pushReplacementNamed(context, EmailAuthScreen.id);   
                 });
                }
                }
                 ),
          
              ],
            ),
          ),
        ),
      ),
     
      
    );
  }
}