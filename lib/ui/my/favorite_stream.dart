import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogchat/constants.dart';

final _fireStore = FirebaseFirestore.instance;

class FavoriteStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _fireStore
            .collection('favorites')
            .where('email', isEqualTo: "${loginUser.email}")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Text('システムエラーが発生しました');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ),
            );
          }
          if (!snapshot.hasData) {
            return Text("読み込み中...");
          } else {
            List<FlatButton> favorites = [];
            for (var favorite in snapshot.data.docs) {
              favorites.add(FlatButton(
                child: Text("${favorite.data()['id']}"),
                onPressed: () =>
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context)
                      .pushNamed('/chat', arguments: favorite.data()['id']);
                }),
              ));
            }
            return Expanded(
                child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: favorites),
              ],
            ));
          }
        });
  }
}
