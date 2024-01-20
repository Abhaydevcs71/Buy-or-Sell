import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';
import 'package:second_store/services/firebase_services.dart';

class ChatStream extends StatefulWidget {
  final String chatRoomId;
  final ScrollController scrollController;

  const ChatStream({
    Key? key,
    required this.chatRoomId,
    required this.scrollController,
  }) : super(key: key);

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
    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: StreamBuilder<QuerySnapshot>(
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
                  controller: widget.scrollController,
                  //reverse: true, // Set reverse to true to scroll to the bottom
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
                                ? Color.fromARGB(255, 131, 144, 209)
                                : Color.fromARGB(255, 185, 191, 223),
                            clipper: ChatBubbleClipper8(
                              type: sentBy == me
                                  ? BubbleType.sendBubble
                                  : BubbleType.receiverBubble,
                            ),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                              ),
                              child: Text(
                                snapshot.data!.docs[index]['message'],
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Align(
                              alignment: sentBy == me
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Text(lastChatDate)),
                        ],
                      ),
                    );
                  },
                )
              : Container();
        },
      ),
    );
  }
}
