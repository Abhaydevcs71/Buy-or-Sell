import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second_store/screens/account/account_screen.dart';
import 'package:second_store/screens/chat/chat_screen.dart';
import 'package:second_store/screens/myads/myAd_screen.dart';
import 'package:second_store/screens/home/home_screen.dart';

import 'package:second_store/screens/sellitems/seller_category_list.dart';

class MainScreen extends StatefulWidget {
  static const String id = 'main-screen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _currentScreen = HomeScreen();
  int _index = 0;
  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: PageStorage(child: _currentScreen, bucket: _bucket),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 221, 158, 171),
        onPressed: () {
          //post ad
          Navigator.pushNamed(context, SellerCategory.id);
        },
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //lft side
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        _index = 0;
                        _currentScreen = HomeScreen();
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _index == 0 ? Icons.home : Icons.home_outlined,
                          color: _index == 0
                              ? Color.fromARGB(255, 221, 158, 171)
                              : Colors.black,
                          size: 35,
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        _index = 1;
                        _currentScreen = ChatScreen();
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _index == 1
                              ? CupertinoIcons.chat_bubble_fill
                              : CupertinoIcons.chat_bubble,
                          color: _index == 1
                              ? Color.fromARGB(255, 221, 158, 171)
                              : Colors.black,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Right side
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        _index = 2;
                        _currentScreen = MyAdsScreen();
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _index == 2
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: _index == 2
                              ? Color.fromARGB(255, 221, 158, 171)
                              : Colors.black,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        _index = 3;
                        _currentScreen = AccountScreen();
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _index == 3
                              ? CupertinoIcons.person_fill
                              : CupertinoIcons.person,
                          color: _index == 3
                              ? Color.fromARGB(255, 221, 158, 171)
                              : Colors.black,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
