import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  String? messageText;
  TextEditingController textCleaner = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  void deactivate() {
    _auth.signOut();
    super.deactivate();
  }

  void getCurrentUser() async {
    try {
      final user = _auth
          .currentUser; // 'user' will be null if nobody is currently assigned in.
      if (user != null) {
        loggedInUser = user;
        // ignore: avoid_print
        print(loggedInUser!.email);
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  void sendMessages() {
    _firestore.collection('messages').add({
      'text': messageText,
      'sender': loggedInUser!.email,
      'created': FieldValue.serverTimestamp(),
    });
  }

  void fireStoreDocumentsCleaner() async {
    final allDocuments = await _firestore.collection("messages").get();
    for (var doc in allDocuments.docs) {
      await doc.reference.delete();
    }
  }

  void resetTextFieldState() {
    textCleaner.clear();
    bool messageCompleted = true;
    if (messageCompleted) {
      primaryFocus!.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            null, // 'turn back arrow' will become another widget with another funcion
        actions: <Widget>[
          Tooltip(
            message: 'Erase All Messages For Everyone',
            child: IconButton(
              icon: const Icon(
                Icons.delete_forever,
                size: 25.0,
              ),
              onPressed: () {
                fireStoreDocumentsCleaner();
              },
            ),
          ),
        ],
        title: Row(
          children: [
            Hero(
              tag: 'logo',
              child: Image.asset(
                'images/logo.png',
                height: 30,
              ),
            ),
            const Text('Chat'),
          ],
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: textCleaner,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                      onSubmitted: (value) {
                        if (value != '') {
                          sendMessages();
                        }
                        resetTextFieldState();
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (textCleaner.text.isNotEmpty) {
                        sendMessages();
                      }
                      resetTextFieldState();
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore
          .collection('messages')
          .orderBy('created', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(backgroundColor: Colors.lightBlue),
          );
        } else {
          final messages = snapshot.data!.docs;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            final messageText = message.data()['text'];
            final messageSender = message.data()['sender'];
            final currentUser = loggedInUser!.email;

            final messageBubble = MessageBubble(
              text: messageText,
              sender: messageSender,
              isMe: currentUser == messageSender,
            );
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              children: messageBubbles,
            ),
          );
        }
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.text,
    required this.sender,
    required this.isMe,
  });

  final String text;
  final String sender;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
            elevation: 5.0,
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
