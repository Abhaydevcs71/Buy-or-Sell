import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:second_store/services/firebase_services.dart';

class ChatCard extends StatefulWidget {
  final Map<String, dynamic> chatData;

  const ChatCard({super.key, required this.chatData});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  FirebaseService _service = FirebaseService();
  late DocumentSnapshot doc;

  @override
  void initState() {
    getProductInfo();
    super.initState();
  }

  getProductInfo() {
    _service.getProductInfo(widget.chatData['product']['docId']).then((value) {
      setState(() {
        doc = value;
                        //print(doc['title']);

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      height: 300,
      child: ListTile(
        leading: Image.network(doc['images'][0],width: 50,height: 50,
        ),
        title: Text(
          doc['name'],
        ),
        subtitle: Column(children: [
          if (widget.chatData['lastChat'] != null)
            Text(
              widget.chatData['lastChat'],
              maxLines: 1,
              style: TextStyle(fontSize: 15),
            ),
        ]),
      ),
    );

  }
}
