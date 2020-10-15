import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dogchat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

final _firestore = FirebaseFirestore.instance;
GoogleSignInAccount loginUser;

class Chat extends StatefulWidget {
  static const String id = "Chat_screen";
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final messageController = TextEditingController();
  String message;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    try {
      if (loginUser != null) {
        print(loginUser.displayName);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    loginUser = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
        title: Text('🐕 Dog Chat -ワンタイムチャット-'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Messagestream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _firestore.collection('messages').add({
                        'text': message,
                        'sender': loginUser.email,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      messageController.clear();
                    },
                    child: Text(
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

class MessageBubble extends StatelessWidget {
  MessageBubble({this.Sender, this.TextMsg, this.isMe});
  final TextMsg;
  final Sender;
  bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            "$Sender",
            style: TextStyle(color: Colors.black87, fontSize: 12),
          ),
          Material(
            borderRadius: isMe ? Kborderradiusright : Kborderradiusleft,
            elevation: 10,
            color: isMe ? Colors.blueAccent : Colors.greenAccent,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$TextMsg',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Messagestream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore
            .collection('messages')
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('システムエラーが発生しました');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("よみこみ中...");
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ),
            );
          } else {
            final messages = snapshot.data.docs;
            List<MessageBubble> messagewidgets = [];
            for (var message in messages) {
              final messageText = message.data()['text'];
              final messageSender = message.data()['sender'];
              final currentUser = loginUser.email;
              bool val;
              if (currentUser != messageSender)
                val = false;
              else
                val = true;
              final messageBubbler = MessageBubble(
                Sender: messageSender,
                TextMsg: messageText,
                isMe: val,
              );
              messagewidgets.add(messageBubbler);
            }
            return Expanded(
                child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: messagewidgets),
              ],
            ));
          }
        });
  }
}
