import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';
import 'package:second_store/services/firebase_services.dart';

class ChatStream extends StatefulWidget {
  final String chatRoomId;

  const ChatStream({super.key, required this.chatRoomId});

  @override
  State<ChatStream> createState() => _ChatStreamState();
}

class _ChatStreamState extends State<ChatStream> {
  FirebaseService _service = FirebaseService();

  Stream<QuerySnapshot<Object?>>? chatMessageStream;

  @override
  void initState() {
    _service.getChat(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: chatMessageStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  String sentBy = snapshot.data!.docs[index]['sentBy'];
                  String me = _service.user!.uid;

                  // chat details
                  String lastChatDate;
                  var _date = DateFormat.yMMMd().format(
                      DateTime.fromMicrosecondsSinceEpoch(
                          snapshot.data!.docs[index]['time']));
                  var _today = DateFormat.yMMMd().format(
                      DateTime.fromMicrosecondsSinceEpoch(
                          DateTime.now().microsecondsSinceEpoch));

                  if (_date == _today) {
                    lastChatDate = DateFormat('hh:mm').format(
                        DateTime.fromMicrosecondsSinceEpoch(
                            snapshot.data!.docs[index]['time']));
                  } else {
                    lastChatDate = _date.toString();
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ChatBubble(
                          alignment: sentBy == me
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          backGroundColor: sentBy == me
                              ? Colors.greenAccent
                              : Colors.grey[300],
                          clipper: ChatBubbleClipper8(
                            type: BubbleType.sendBubble,
                          ),
                          child: Text(
                            snapshot.data!.docs[index]['message'],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Align(
                            alignment: sentBy == me
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Text(lastChatDate)),
                      ],
                    ),
                  );
                })
            : Container();
      },
    );
  }
}
//Text(snapshot.data!.docs[index]['message'])