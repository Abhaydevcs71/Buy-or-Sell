import 'package:flutter/material.dart';
import 'package:second_store/screens/chat_stream.dart';
import 'package:second_store/services/firebase_services.dart';

class ChatConversation extends StatefulWidget {
  const ChatConversation({
    Key? key,
    required this.chatRoomId,
  }) : super(key: key);

  final String chatRoomId;

  @override
  State<ChatConversation> createState() => _ChatConversationState();
}

class _ChatConversationState extends State<ChatConversation> {
  FirebaseService _service = FirebaseService();
  var chatMessageController = TextEditingController();
  bool _send = false;
  ScrollController _scrollController = ScrollController();

  sendMessage() {
    if (chatMessageController.text.isNotEmpty) {
      FocusScope.of(context).unfocus();
      Map<String, dynamic> message = {
        'message': chatMessageController.text,
        'sentBy': _service.user!.uid,
        'time': DateTime.now().microsecondsSinceEpoch
      };

      _service.createChat(widget.chatRoomId, message);
      chatMessageController.clear();

      // Scroll to the bottom
      Future.delayed(const Duration(milliseconds: 300), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatStream(
                chatRoomId: widget.chatRoomId,
                scrollController: _scrollController),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[600],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      controller: chatMessageController,
                      decoration: const InputDecoration(
                        hintText: 'Type message',
                        hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _send = value.isNotEmpty;
                        });
                      },
                    ),
                  ),
                  Visibility(
                    visible: _send,
                    child: IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
