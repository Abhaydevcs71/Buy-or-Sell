import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:second_store/screens/login/profile.dart';
//import 'package:firebase_storage/firebase_storage.dart';

class BannerWidget extends StatelessWidget {
  String img;
  String cat;
  BannerWidget({super.key, required this.img, required this.cat});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * .25,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 169, 201, 192),
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [Color(0xffdaa4af), Color(0xff3f5efb)],
            stops: [0.25, 0.75],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
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
                        cat,
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
                              FadeAnimatedText(
                                  'Reach 10 lakh+\nIntrested Buyers',
                                  duration: Duration(seconds: 4)),
                              FadeAnimatedText(
                                  'New way to\nRent or sell\n${cat}S',
                                  duration: Duration(seconds: 4)),
                              FadeAnimatedText('Over 1 Lakh\n${cat}S \nto Rent',
                                  duration: Duration(seconds: 4)),
                            ],
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
                      child: Image.network(
                        img,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
