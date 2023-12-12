import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:second_store/screens/categories/subCat_Screen.dart';
import 'package:second_store/services/firebase_services.dart';

class CategoryListScreen extends StatelessWidget {
  static const String id = 'category-list-screen';

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: Border(bottom: BorderSide(color: Colors.grey)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'categories',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: FutureBuilder<QuerySnapshot>(
            future: _service.categories.get(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Container();
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else
                debugPrint(snapshot.data!.docs.toString());
              return Container(
                height: MediaQuery.of(context).size.height,
                // width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var doc = snapshot.data!.docs[index];
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        // height:MediaQuery.of(context).size.height/6 ,
                        // color: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            visualDensity: VisualDensity(vertical: -3),
                            onTap: () {
                              //   if(snapshot.data!.docs[index]['subCat']==null){
                              //     return print('No sub Categories');
                              //   }
                              //  // Navigator.pushNamed(context, SubCatList.id,arguments:snapshot.data!.docs[index] );
                            },
                            leading: Image.network(
                              snapshot.data!.docs[index]['image'],
                              width: 40,
                            ),
                            title: Text(
                              snapshot.data!.docs[index]['catName'],
                              style: TextStyle(fontSize: 15),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
