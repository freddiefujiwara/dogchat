import 'package:flutter/material.dart';
// https://pub.dev/documentation/google_sign_in/latest/google_sign_in/google_sign_in-library.html
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> _handleSignIn() async {
    GoogleSignInAccount currentUser = _googleSignIn.currentUser;

    try {
      currentUser ??= await _googleSignIn.signInSilently();
      currentUser ??= await _googleSignIn.signIn();
      if (currentUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await currentUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final User user = (await _auth.signInWithCredential(credential)).user;
      return user;
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    print("LOGIN");
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Center(
          child: Column(
        children: <Widget>[
          SizedBox(height: 24.0),
          FlatButton(
              child: Text('SignIn'),
              onPressed: () => _handleSignIn().then((User user) {
                    print(user);
                    Navigator.pushReplacementNamed(context, "/");
                  }).catchError((e) => print(e)))
        ],
      )),
    );
  }
}
