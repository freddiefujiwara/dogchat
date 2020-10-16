import 'package:firebase_auth/firebase_auth.dart';
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
      await googleSignIn.signIn();

      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await auth.signInWithCredential(credential);
      final User user = authResult.user;

      if (user != null) {
        final User currentUser = auth.currentUser;
        assert(user.uid == currentUser.uid);
        print('signInWithGoogle succeeded: $user');
      }
    } catch (error) {
      print(error);
    }
  }

  Widget _buildBody() {
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
    if (loginUser != null) {
      if (id != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushNamed('/chat', arguments: id);
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushNamed('/issue');
        });
      }
    }
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
