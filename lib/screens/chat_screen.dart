import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:second_store/screens/chat_conversation.dart';
import 'package:second_store/screens/profile.dart';
import 'package:second_store/services/firebase_services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 221, 158, 171),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _service.messages
            .where('users', arrayContains: _service.user!.uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return Container(
                margin: const EdgeInsets.only(top: 8),
                height: 80,
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color.fromARGB(255, 131, 144, 209)),),),
                child: ListTile(
                  leading: Image.network(
                    data['image'],
                    width: 60,
                    height: 60,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, ProfileForm.id);
                    },
                  ),
                  title: Text(
                    data['adtitle'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: data['read'] == false
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    _service.messages
                        .doc(data['chatRoomId'])
                        .update({'read': 'true'});
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => ChatConversation(
                          chatRoomId: data['chatRoomId'],profile: data['image'],name1: data['adtitle'],
                        ),
                      ),
                    );
                  },
                  subtitle: data['lastChat'] == null
                      ? const Text('(draft)')
                      : Text(
                          data['lastChat'],
                        ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
