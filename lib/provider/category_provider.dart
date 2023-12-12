import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:second_store/services/firebase_services.dart';

class CategoryProvider with ChangeNotifier {
  FirebaseService _service = FirebaseService();

  DocumentSnapshot? doc;
  DocumentSnapshot? userDetails;
  String? selectedCategory;
  List<String> urlList = [];
  Map<String, dynamic> dataToFirestore = {};

  getCategory(selectedCategory) {
    this.selectedCategory = selectedCategory;
    notifyListeners();
  }

  getCategorySnapshot(snapshot) {
    notifyListeners();
  }

  getImages(url) {
    this.urlList.add(url);
    notifyListeners();
  }

  getData(data) {
    this.dataToFirestore = data;
    notifyListeners();
  }

  // getUserDetails() {
  //   _service.getUserData().then((value) {
  //     this.userDetails = value;
  //     notifyListeners();
  //   });
  // }

  clearData() {
    this.urlList = [];
    dataToFirestore = {};
    notifyListeners();
  }
}
