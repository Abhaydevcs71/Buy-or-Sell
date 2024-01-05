import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getChatStream() {
  return _firestore
      .collection('messages')
      .orderBy('time')
      .snapshots();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Chats'),
    ),
    body: StreamBuilder<QuerySnapshot>(
      stream: getChatStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        Set<String> chatRoomIds = Set<String>();

        snapshot.data!.docs.forEach((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          String chatRoomId = data['chatRoomId'] ?? ''; // Replace with your actual field name

          if (chatRoomId.isNotEmpty) {
            chatRoomIds.add(chatRoomId);
          }
        });

       // ...

return ListView(
  children: chatRoomIds.map((String chatRoomId) {
    // Retrieve the latest message for each chat room
    QueryDocumentSnapshot? latestMessage = snapshot.data!.docs.firstWhere(
      (doc) => doc['chatRoomId'] == chatRoomId,
     // orElse: () => null,
    );

    if (latestMessage != null) {
      Map<String, dynamic> data = latestMessage.data() as Map<String, dynamic>;

      return ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(data['image'] ?? ''),
        ),
        title: Text(data['name'] ?? ''),
        subtitle: data.containsKey('lastChat') ? Text(data['lastChat'] ?? '') : Text('No lastChat field'),
      );
    } else {
      return Container(); // Placeholder for no messages in the chat room
    }
  }).toList(),
);

// ...

      },
    ),
  );
}
}