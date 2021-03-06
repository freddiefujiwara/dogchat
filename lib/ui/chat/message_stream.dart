import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogchat/globals.dart';
import 'package:dogchat/ui/chat/message_bubble.dart';

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: fireStore
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
            Timestamp lastUpdate = Timestamp.now();
            for (var message in messages) {
              final data = message.data();
              final messageSender = data['sender'];
              final currentUser = loginUser.email;
              final messageBubble = MessageBubble(
                messageID: message.id,
                sender: messageSender,
                text: data['text'],
                photo: data['photo'],
                timestamp: data['timestamp'],
                isMe: currentUser == messageSender,
              );
              messageWidgets.add(messageBubble);
              lastUpdate = messageBubble.timestamp;
            }
            fireStore
                .collection('history')
                .where("id", isEqualTo: id)
                .where("email", isEqualTo: loginUser.email)
                .get()
                .then((snapshot) {
              if (snapshot.docs.length > 0) {
                for (var doc in snapshot.docs) {
                  fireStore.collection("history").doc(doc.id).delete();
                }
              }
              if (lastUpdate != null) {
                fireStore.collection('history').add({
                  'id': "$id",
                  'email': loginUser.email,
                  'timestamp': lastUpdate,
                });
              }
            });
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
