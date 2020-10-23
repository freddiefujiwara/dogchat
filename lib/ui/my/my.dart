import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:dogchat/globals.dart';
import 'package:dogchat/ui/my/favorite_stream.dart';

class My extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      loginUser = null;
      id = null;
      print("ID@my:$id");
      await googleSignIn.signOut();
      await auth.signOut();
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async => _signOut(context)),
          title: const Text('🐕 マイページ'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FlatButton(
                  child: Text('新しいroomを作る'),
                  color: Colors.blueGrey,
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).pushNamed('/chat',
                          arguments: randomAlphaNumeric(32));
                    });
                  },
                ),
                FavoriteStream()
              ],
            ),
          ),
        ));
  }
}
