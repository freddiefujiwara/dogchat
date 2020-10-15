import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dogchat/constants.dart';

class Home extends StatefulWidget {
  @override
  State createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        loginUser = account;
      });
      Navigator.of(context).pushNamed('/chat');
    });
    googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      await googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        const Text("チャットを開始するにはサインインが必要です"),
        RaisedButton(
          child: const Text('Googleでログインしてください'),
          onPressed: _handleSignIn,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('🐕 Dog Chat -ワンタイムチャット-'),
          centerTitle: true,
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }
}
