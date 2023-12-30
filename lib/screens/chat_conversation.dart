import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:second_store/screens/chat_stream.dart';
import 'package:second_store/services/firebase_services.dart';

class ChatConversation extends StatefulWidget {
  const ChatConversation({super.key, required this.chatRoomId});
  final String chatRoomId;

  @override
  State<ChatConversation> createState() => _ChatConversationState();
}

class _ChatConversationState extends State<ChatConversation> {
  FirebaseService _service = FirebaseService();

  //Stream<QuerySnapshot<Object?>>? chatMessageStream;
  var chatMessageController = TextEditingController();

  bool _send = false;

  sendMessage() {
    if (chatMessageController.text.isNotEmpty) {
      Map<String, dynamic> message = {
        'message': chatMessageController.text,
        'sentBy': _service.user!.uid,
        'time': DateTime.now().microsecondsSinceEpoch
      };

      _service.createChat(widget.chatRoomId, message);
      chatMessageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            ChatStream(chatRoomId: widget.chatRoomId),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: chatMessageController,
                          decoration: InputDecoration(
                            hintText: 'Type message',
                            hintStyle: TextStyle(
                                color: Theme.of(context).primaryColor),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                _send = true;
                              });
                            } else {
                              setState(() {
                                _send = false;
                              });
                            }
                          },
                        ),
                      ),
                      Visibility(
                        visible: _send,
                        child: IconButton(
                          onPressed: sendMessage,
                          icon: Icon(Icons.send),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
