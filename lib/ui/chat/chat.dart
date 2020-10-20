import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dogchat/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogchat/ui/chat/message_stream.dart';
import 'package:dogchat/ui/chat/favorite_stream.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

String message;

class Chat extends StatelessWidget {
  final messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Future<void> _signOut(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      loginUser = null;
      id = null;
      print("ID@Chat._signOut:$id");
      await googleSignIn.signOut();
      await auth.signOut();
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    });
  }

  void _handlePost() {
    if (message == null || message.trim().length == 0) {
      return;
    }
    fireStore.collection('messages').add({
      'id': "$id",
      'text': message,
      'sender': loginUser.email,
      'photo': loginUser.photoUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });
    message = null;
    this.messageController.clear();
  }

  Future<void> _handleImagePost() async {
    message = null;
    this.messageController.clear();
    try {
      final pickedFile = await _picker.getImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        fireStore.collection('messages').add({
          'id': "$id",
          'text':
              "data:image/jpeg;base64,${base64.encode(List<int>.from(await pickedFile.readAsBytes()))}",
          'sender': loginUser.email,
          'photo': loginUser.photoUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    id = ModalRoute.of(context).settings.arguments;
    print("ID@Chat.build:$id");
    if (id == null || id.isEmpty || loginUser == null) {
      this._signOut(context);
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async => await _signOut(context)),
        title: const Text('🐕 Chat room'),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        actions: [
          FavoriteStream(),
          IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
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
                  IconButton(
                      onPressed: this._handleImagePost,
                      icon: Icon(Icons.photo)),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        message = value;
                      },
                      onSubmitted: (String value) {
                        message = value.trim();
                        this._handlePost();
                      },
                      decoration: dMessageTextFieldDecoration,
                      keyboardType: isPCWeb
                          ? TextInputType.text
                          : TextInputType.multiline,
                      maxLines: isPCWeb ? 1 : null,
                    ),
                  ),
                  IconButton(
                      onPressed: this._handlePost, icon: Icon(Icons.send)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
