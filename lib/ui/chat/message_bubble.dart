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
      {this.Sender, this.TextMsg, this.Photo, this.TimeStamp, this.isMe});
  final String TextMsg;
  final String Sender;
  final String Photo;
  final Timestamp TimeStamp;
  bool isMe;

  @override
  Widget build(BuildContext context) {
    String name = Sender.replaceAll(RegExp(r'@.*$'), '')
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
              image: NetworkImage(this.Photo.isEmpty
                  ? 'https://freddiefujiwara.com/dogchat/favicon.png'
                  : this.Photo),
              fit: BoxFit.fill),
        ),
      ),
      Text(
        "$name",
        style: TextStyle(color: Colors.black87, fontSize: 12),
      ),
    ];
    Image image;
    if (RegExp(r'^data:image/[a-z]+;base64,').hasMatch(TextMsg)) {
      try {
        image = Image.memory(base64.decode(TextMsg.split(',').last));
      } catch (e) {
        print(e);
      }
    }
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
          image != null
              ? image
              : Material(
                  borderRadius: isMe ? dBorderRadiusRight : dBorderRadiusLeft,
                  elevation: 10,
                  color: isMe ? Colors.blueAccent : Colors.greenAccent,
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
                      text: TextMsg,
                      style: TextStyle(color: Colors.black87, fontSize: 12),
                      linkStyle: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ),
          Text(
              '${TimeStamp == null ? "" : new DateFormat.yMd().add_jm().format(DateTime.parse(TimeStamp.toDate().toString()))}'),
        ],
      ),
    );
  }
}
