import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dogchat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogchat/ui/chat/message_stream.dart';
import 'package:dogchat/ui/chat/favorite_stream.dart';
import 'package:url_launcher/url_launcher.dart';

final _fireStore = FirebaseFirestore.instance;

class Chat extends StatelessWidget {
  final messageController = TextEditingController();
  String message;

  void _signOut(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      googleSignIn.signOut();
      loginUser = null;
      id = null;
      Navigator.of(context).popUntil(ModalRoute.withName('/'));
    });
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
    id = ModalRoute.of(context).settings.arguments;
    if (id == null || id.isEmpty) {
      this._signOut(context);
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.logout), onPressed: () => _signOut(context)),
        title: const Text('🐕 チャットルーム'),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        actions: [
          FavoriteStream(),
          IconButton(
              icon: Icon(Icons.person),
              onPressed: () async {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushNamed('/my');
                });
              }),
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () async {
                await launch("https://freddiefujiwara.com/dogchat/?id=$id");
              }),
        ],
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
