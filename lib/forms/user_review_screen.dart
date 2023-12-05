// import 'dart:io';
// import 'dart:js';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:email_validator/email_validator.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:second_store/services/emailAuth_services.dart';
// import 'package:second_store/services/firebase_services.dart';
// import 'package:path/path.dart';

// class UserReviewScreen extends StatefulWidget {
//   static const String id = 'user-review-screen';

//   @override
//   State<UserReviewScreen> createState() => _UserReviewScreenState();
// }

// class _UserReviewScreenState extends State<UserReviewScreen> {
//   FirebaseService _service = FirebaseService();
//   var _nameController = TextEditingController();
//   var _phoneController = TextEditingController();
//   var _emailController = TextEditingController();
//   var _addressController = TextEditingController();

//  void showConfirmDialogue(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Confirm'),
//           content: Text('Are you sure you want to save the details?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('Yes'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('No'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(
//           color: Colors.black,
//         ),
//         elevation: 0.0,
//         title: const Text(
//           "Review your Details",
//           style: TextStyle(
//             color: Colors.black,
//           ),
//         ),
//         shape: Border(
//           bottom: BorderSide(
//             color: Colors.grey.shade400,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Container(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 10),
//                 child: Row(
//                   children: [
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.3,
//                       child: CircleAvatar(
//                         backgroundColor: Theme.of(context).primaryColor,
//                         radius: 40,
//                         child: CircleAvatar(
//                           backgroundColor: Colors.blue.shade50,
//                           radius: 38,
//                           child: Icon(
//                             CupertinoIcons.person_alt,
//                             color: Colors.red.shade300,
//                             size: 60,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Container(
//                       width: MediaQuery.of(context).size.width * 0.6,
//                       child: TextFormField(
//                         controller: _nameController,
//                         decoration: InputDecoration(
//                           labelText: 'Your Name',
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 30),
//           Text(
//             'Contact Details',
//             style: TextStyle(
//               fontSize: 30,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(width: 10),
//           Container(
//             width: MediaQuery.of(context).size.width * 0.9,
//             child: TextFormField(
//               controller: _phoneController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: 'Mobile Number',
//                 helperText: 'Enter contact mobile number',
//               ),
//               maxLength: 10,
//             ),
//           ),
//           SizedBox(height: 10),
//           Container(
//             width: MediaQuery.of(context).size.width * 0.9,
//             child: TextFormField(
//               controller: _emailController,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 helperText: 'Enter contact Email id',
//               ),
//               maxLength: 20,
//             ),
//           ),
//           SizedBox(height: 10),
//           Container(
//             width: MediaQuery.of(context).size.width * 0.9,
//             child: TextFormField(
//               controller: _addressController,
//               minLines: 3,
//               maxLines: 5,
//               keyboardType: TextInputType.multiline,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Contact Address',
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomSheet: Padding(
//         padding: EdgeInsets.all(20.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 if (_nameController.text.isEmpty ||
//                     _phoneController.text.isEmpty ||
//                     _emailController.text.isEmpty ||
//                     _addressController.text.isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Please fill in all the required fields'),
//                     ),
//                   );
//                 } else {
//                   showConfirmDialogue(context);
//                 }
//               },
//               child: Text(
//                 'Confirm',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
