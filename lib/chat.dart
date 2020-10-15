import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dogchat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

final _firestore = FirebaseFirestore.instance;

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
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        loginUser = account;
      });
    });
    super.initState();
  }

  void _handlePost() {
    if (this.message == null || this.message.length == 0) {
      return;
    }
    _firestore.collection('messages').add({
      'text': this.message,
      'sender': loginUser.email,
      'photo': loginUser.photoUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });
    this.messageController.clear();
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
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        this.message = value;
                      },
                      onSubmitted: (String value) {
                        this.message = value;
                        this._handlePost();
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                      onPressed: this._handlePost, child: Icon(Icons.send)),
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
  MessageBubble({this.Sender, this.TextMsg, this.Photo, this.isMe});
  final TextMsg;
  final Sender;
  final Photo;
  bool isMe;

  @override
  Widget build(BuildContext context) {
    List<Widget> sendersInfo = [
      Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: NetworkImage(this.Photo ??
                  'https://freddiefujiwara.com/dogchat/favicon.png'),
              fit: BoxFit.fill),
        ),
      ),
      Text(
        "$Sender",
        style: TextStyle(color: Colors.black87, fontSize: 12),
      ),
    ];
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: isMe ? sendersInfo.reversed.toList() : sendersInfo),
          Material(
            borderRadius: isMe ? Kborderradiusright : Kborderradiusleft,
            elevation: 10,
            color: isMe ? Colors.blueAccent : Colors.greenAccent,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Linkify(
                onOpen: (link) async {
                  if (await canLaunch(link.url)) {
                    await launch(link.url);
                  } else {
                    throw 'Could not launch $link';
                  }
                },
                text: '$TextMsg',
                style: TextStyle(color: Colors.black87, fontSize: 12),
                linkStyle: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
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
            List<MessageBubble> messageWidgets = [];
            for (var message in messages) {
              final messageText = message.data()['text'];
              final messageSender = message.data()['sender'];
              final messageSenderPhoto = message.data()['photo'];
              final currentUser = loginUser.email;
              bool val;
              if (currentUser != messageSender)
                val = false;
              else
                val = true;
              final messageBubbler = MessageBubble(
                Sender: messageSender,
                TextMsg: messageText,
                Photo: messageSenderPhoto,
                isMe: val,
              );
              messageWidgets.add(messageBubbler);
            }
            return Expanded(
                child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: messageWidgets),
              ],
            ));
          }
        });
  }
}
