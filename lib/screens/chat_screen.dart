import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:second_store/screens/chat_card.dart';
import 'package:second_store/services/firebase_services.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        leading: const Icon(
          Icons.chat_rounded,
          color: Colors.black,
        ),
        title: const Text(
          'Chats',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: _service.messages
              .where('users', arrayContains: _service.user!.uid)
              .snapshots(),
             
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                 // valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return ChatCard(chatData: data);
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
