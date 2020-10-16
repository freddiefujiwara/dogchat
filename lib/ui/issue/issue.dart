import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class Issue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
                  Navigator.of(context)
                      .pushNamed('/chat', arguments: randomAlphaNumeric(32));
                },
              ),
            ],
          ),
        ));
  }
}
