import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogchat/constants.dart';
import 'package:dogchat/ui/chat/message_bubble.dart';

final _fireStore = FirebaseFirestore.instance;

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _fireStore
            .collection('messages')
            .where('id', isEqualTo: "$id")
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Text('システムエラーが発生しました');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("読み込み中...");
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
              final messageSender = message.data()['sender'];
              final currentUser = loginUser.email;
              bool val;
              if (currentUser != messageSender)
                val = false;
              else
                val = true;
              final messageBubbler = MessageBubble(
                Sender: messageSender,
                TextMsg: message.data()['text'],
                Photo: message.data()['photo'],
                TimeStamp: message.data()['timestamp'],
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
