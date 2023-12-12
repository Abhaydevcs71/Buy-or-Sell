// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:second_store/services/firebase_services.dart';

// class SubCatList extends StatelessWidget {
//   static const String id ='subCat-screen';
  

//   @override
//   Widget build(BuildContext context) {

//         FirebaseService _service = FirebaseService();


//     DocumentSnapshot? args = ModalRoute.of(context)?.settings.arguments as DocumentSnapshot;
//     debugPrint(args.toString());
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         shape: Border(bottom: BorderSide(color: Colors.grey)),
//         backgroundColor: Colors.white,
//         iconTheme: IconThemeData(color: Colors.black),
//         title: Text(
//           args['catName'],
//           style: TextStyle(color: Colors.black,fontSize: 18),
//         ),
//       ),
//       body: Center(
//         child: FutureBuilder<DocumentSnapshot>(
//           future: _service.categories.doc(args.id).get(),
//           builder:
//               (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//             if (snapshot.hasError) {
//               return Container();
//             }

//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             var data = snapshot.data!['subCat'];

//             return Container(
//               child: ListView.builder(
//                 scrollDirection: Axis.vertical,
//                 itemCount: data.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Padding(
//                     padding: const EdgeInsets.only(left: 8,right:8),
//                     child: ListTile(
//                       onTap: () {
//                        // Navigator.pushNamed(context, SubCatList.id);
//                       },
//                       title: Text(
//                         data[index],
//                         style: TextStyle(fontSize: 15),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             );
//           },
//         ), 
//       ),
//     );
//   }
// }