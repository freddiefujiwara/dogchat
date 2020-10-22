import 'dart:ui';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dogchat/globals.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {this.messageID,
      this.sender,
      this.text,
      this.photo,
      this.timestamp,
      this.isMe});
  final String messageID;
  final String text;
  final String sender;
  final String photo;
  final Timestamp timestamp;
  bool isMe;

  @override
  Widget build(BuildContext context) {
    String name = sender
        .replaceAll(RegExp(r'@.*$'), '')
        .replaceAll(RegExp(r'\.'), ' ')
        .split(" ")
        .map((orig) {
      return orig.substring(0, 1).toUpperCase() + orig.substring(1);
    }).join(" ");
    List<Widget> sendersInfo = [
      Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: NetworkImage(this.photo.isEmpty
                  ? 'https://freddiefujiwara.com/dogchat/favicon.png'
                  : this.photo),
              fit: BoxFit.fill),
        ),
      ),
      Text(
        "$name",
        style: TextStyle(fontSize: 12),
      ),
    ];
    Image image;
    if (RegExp(r'^data:image/[a-z]+;base64,').hasMatch(text)) {
      try {
        image = Image.memory(base64.decode(text.split(',').last));
      } catch (e) {
        image = null;
        print(e);
      }
    }
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: isMe ? sendersInfo.reversed.toList() : sendersInfo),
          image != null
              ? image
              : Material(
                  borderRadius: isMe ? dBorderRadiusRight : dBorderRadiusLeft,
                  elevation: 10,
                  color: isMe ? Colors.grey : Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: SelectableLinkify(
                      onOpen: (link) async {
                        if (await canLaunch(link.url)) {
                          await launch(link.url);
                        } else {
                          throw 'Could not launch $link';
                        }
                      },
                      text: text,
                      style: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                          fontSize: 12),
                      linkStyle:
                          TextStyle(color: Colors.blueAccent, fontSize: 12),
                    ),
                  ),
                ),
          GestureDetector(
            onLongPress: () {
              if (!isMe) {
                return;
              }
              showDialog(
                  context: context,
                  child: AlertDialog(
                    title: Text("この投稿を削除します"),
                    content: Text("削除すると戻せません"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("いいえ"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text("はい"),
                        onPressed: () {
                          fireStore
                              .collection('messages')
                              .doc(messageID)
                              .delete();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ));
            },
            child: Text(
                '${timestamp == null ? "" : new DateFormat.yMd().add_jm().format(DateTime.parse(timestamp.toDate().toString()))}'),
          )
        ],
      ),
    );
  }
}
