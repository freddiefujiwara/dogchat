import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User user;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _handleSignOut(context) async {
    await Firebase.initializeApp();
    await FirebaseAuth.instance.signOut();
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print(e);
    }

    Navigator.pushReplacementNamed(context, "/");
  }

  @override
  void initState() {
    super.initState();
    this.user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(this.user != null ? this.user.displayName : "guest"),
        FlatButton(
            child: Text('SignOut'), onPressed: () => _handleSignOut(context))
      ],
    )));
  }
}
