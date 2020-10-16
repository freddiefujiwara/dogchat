import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dogchat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dogchat/ui/chat/message_stream.dart';

final _fireStore = FirebaseFirestore.instance;

class Chat extends StatefulWidget {
  @override
  Chat({Key key, String identifier: ""}) : super(key: key) {
    if (identifier != null && identifier.isNotEmpty) {
      id = identifier;
    }
  }
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
    _fireStore.collection('messages').add({
      'id': "$id",
      'text': this.message,
      'sender': loginUser.email,
      'photo': loginUser.photoUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });
    this.messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await googleSignIn.disconnect();
              loginUser = null;
              Navigator.of(context).popUntil(ModalRoute.withName('/'));
            }),
        title: Text('🐕 Dog Chat -ワンタイムチャット-'),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: dMessageContainerDecoration,
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
                      decoration: dMessageTextFieldDecoration,
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
