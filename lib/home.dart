import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dogchat/constants.dart';

class Home extends StatefulWidget {
  @override
  State createState() => HomeState();
}

class HomeState extends State<Home> {
  String _contactText;

  @override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        loginUser = account;
      });
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

  Future<void> _handleSignOut() => googleSignIn.disconnect();

  Widget _buildBody() {
    if (loginUser != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: loginUser,
            ),
            title: Text(loginUser.displayName ?? ''),
            subtitle: Text(loginUser.email ?? ''),
          ),
          const Text("サインインに成功しました"),
          Text(_contactText ?? ''),
          RaisedButton(
            child: const Text('Googleからサインアウト'),
            onPressed: _handleSignOut,
          ),
          RaisedButton(
            child: const Text('チャットルームに入る'),
            onPressed: () => Navigator.of(context).pushNamed('/chat'),
          ),
        ],
      );
    } else {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('🐕 Dog Chat -ワンタイムチャット-'),
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }
}
