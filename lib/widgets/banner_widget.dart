import 'package:flutter/material.dart';
//import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return 
    // Neumorphic(
    //   child: 
      Container(
        //width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height,
        child: Text('Abcd'),
      )
   // )
    ;
  }
}
