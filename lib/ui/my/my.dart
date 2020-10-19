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
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                child: Text('新しいroomを作る'),
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context)
                        .pushNamed('/chat', arguments: randomAlphaNumeric(32));
                  });
                },
              ),
              FavoriteStream()
            ],
          ),
        ));
  }
}
