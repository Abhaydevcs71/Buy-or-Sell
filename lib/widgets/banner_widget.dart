import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_storage/firebase_storage.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .30,
      color: Color.fromARGB(255, 169, 201, 192),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Hostel',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                            fontSize: 25),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 150,
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                          ),
                          child: AnimatedTextKit(
                            repeatForever: true,
                            isRepeatingAnimation: true,
                            animatedTexts: [
                              FadeAnimatedText('Reach 10 lakh+\nIntrested Buyers',
                              duration: Duration(seconds: 4)),
                              FadeAnimatedText('New way to\nRent or sell\nHostels',
                              duration: Duration(seconds: 4)),
                              FadeAnimatedText('Over 1 Lakh\n Hostels to Rent',
                              duration: Duration(seconds: 4)),
                            ],
                            onTap: () {
                              print("Tap Event");
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 100,
                      height: 100,
                      child: Image.network('https://firebasestorage.googleapis.com/v0/b/secondstore-62b29.appspot.com/o/categories%2Fhostel.png?alt=media&token=9966ce36-c34a-42b1-b6b5-4333ebb5d449')),
                  )
                ],
              ),
            ),
            Row(
              
              mainAxisSize:MainAxisSize.min,
              children: [
          Expanded(child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.teal[900],
                shadowColor: const Color.fromARGB(255, 109, 106, 105),
                elevation: 5,
                fixedSize: const Size(30, 20)
              ),
              onPressed:(){},
               child:Text(
                'Rent hostel',textAlign: TextAlign.center,
                )
                ),
          )
              ),
          SizedBox(width:20),
          Expanded(child: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.teal[900],
                shadowColor: const Color.fromARGB(255, 109, 106, 105),
                elevation: 5,
                fixedSize: const Size(30, 20)
              ),
              onPressed: (){}, child: Text('Sell Hostel',textAlign: TextAlign.center,)),
          )),
        ],),
          ],
        ),
      ),
      
    ));
  }
}
