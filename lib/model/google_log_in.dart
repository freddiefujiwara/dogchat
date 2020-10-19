import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dogchat/globals.dart';
import 'package:dogchat/model/dog_chat_user.dart';

class GoogleLogIn extends ChangeNotifier {
  GoogleLogIn() {
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      if (account != null && account.email != null) {
        loginUser = new DogChatUser(
            email: account.email,
            photoUrl: account.photoUrl ??
                "https://freddiefujiwara.com/dogchat/favicon.png");
        notifyListeners();
      }
    });
    googleSignIn.signInSilently();
  }
  Future<void> handleGoogleSignIn() async {
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
        print('signInWithGoogle succeeded: ${user.email} ${user.photoURL}');
      }
    } catch (error) {
      print(error);
    }
  }
}
