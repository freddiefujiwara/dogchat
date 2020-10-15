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
    });
    googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      print("_handleSignIn(){");
      await googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
    print("}");
  }

  Widget _buildBody() {
    if (loginUser != null) {
      Navigator.of(context).pushNamed('/chat');
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        const Text("利用を開始するにはサインインが必要です"),
        FlatButton(
            onPressed: _handleSignIn,
            padding: EdgeInsets.all(0.0),
            child: Image.network(
                'https://developers.google.com/identity/images/btn_google_signin_dark_normal_web.png')),
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
