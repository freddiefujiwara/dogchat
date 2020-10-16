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
            .where('id', isEqualTo: "$id")
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
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ),
            );
          } else {
            final favorites = snapshot.data.docs;
            return favorites.length > 0
                ? IconButton(
                    icon: Icon(Icons.favorite),
                    onPressed: () => _fireStore
                        .collection('favorites')
                        .doc(favorites.first.id)
                        .delete(),
                  )
                : IconButton(
                    icon: Icon(Icons.favorite_border),
                    onPressed: () => _fireStore.collection('favorites').add({
                          'id': "$id",
                          'email': loginUser.email,
                          'timestamp': FieldValue.serverTimestamp(),
                        }));
          }
        });
  }
}
