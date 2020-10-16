import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:dogchat/constants.dart';

class Issue extends StatelessWidget {
  void _signOut(BuildContext context) {
    googleSignIn.signOut();
    loginUser = null;
    id = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).popUntil(ModalRoute.withName('/'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.logout), onPressed: () => _signOut(context)),
          title: const Text('🐕 Dog Chat -ワンタイムチャット-'),
          centerTitle: true,
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              const Text("新しいchat roomを作りますか？"),
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
            ],
          ),
        ));
  }
}
