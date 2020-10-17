import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dogchat/globals.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {this.Sender, this.TextMsg, this.Photo, this.TimeStamp, this.isMe});
  final String TextMsg;
  final String Sender;
  final String Photo;
  final Timestamp TimeStamp;
  bool isMe;

  @override
  Widget build(BuildContext context) {
    print(Photo);
    List<Widget> sendersInfo = [
      Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: NetworkImage(this.Photo.isEmpty
                  ? 'https://freddiefujiwara.com/dogchat/favicon.png'
                  : this.Photo),
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
            borderRadius: isMe ? dBorderRadiusRight : dBorderRadiusLeft,
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
          Text(
              '${TimeStamp == null ? "" : DateTime.parse(TimeStamp.toDate().toString())}'),
        ],
      ),
    );
  }
}
