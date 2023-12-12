import 'package:flutter/material.dart';
import 'package:second_store/constants/constants.dart';
import 'package:second_store/provider/category_provider.dart';

class FormClass {
  Widget appBar(CategoryProvider _provider) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: AppColors.whiteColor,
      iconTheme: IconThemeData(color: AppColors.blackColor),
      shape: Border(bottom: BorderSide(color: AppColors.greyColor)),
      title: Text(
        '${_provider.selectedCategory}',
        style: TextStyle(color: AppColors.blackColor),
      ),
    );
  }
}
