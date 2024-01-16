
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
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
    _firestore
        .collection('messages')
        .add({'text': messageText, 'sender': loggedInUser!.email});
  }

  // void getMessages() async {
  //   final messages = await _firestore.collection('messages').get();
  //   for (var message in messages.docs) {
  //     print(message.data());
  //   }
  // }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        // ignore: avoid_print
        print(message.data());
      }
    }
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
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                fireStoreDocumentsCleaner();
                // messagesStream();
              }),
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
            StreamBuilder(
              stream: _firestore.collection('messages').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlue),
                  );
                } else {
                  final messages = snapshot.data!.docs;
                  List<Text> messageWidgets = [];
                  for (var message in messages) {
                    final messageText = message.data()['text'];
                    final messageSender = message.data()['sender'];
                    final messageWidget =
                        Text('$messageText from $messageSender');
                    messageWidgets.add(messageWidget);
                  }
                  return Column(
                    children: messageWidgets,
                  );
                }
              },
            ),
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
