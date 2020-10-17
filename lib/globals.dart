import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:dogchat/model/dog_chat_user.dart';

const dMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'メッセージを入力',
  border: InputBorder.none,
);

const dMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const dBorderRadiusRight = BorderRadius.only(
    topLeft: Radius.circular(30),
    bottomRight: Radius.circular(30),
    bottomLeft: Radius.circular(30));

const dBorderRadiusLeft = BorderRadius.only(
    topRight: Radius.circular(30),
    bottomRight: Radius.circular(30),
    bottomLeft: Radius.circular(30));

DogChatUser loginUser;

final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    //'https://www.googleapis.com/auth/contacts.readonly',
  ],
);
final FirebaseAuth auth = FirebaseAuth.instance;
String id;
