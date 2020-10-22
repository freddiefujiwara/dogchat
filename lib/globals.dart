import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:dogchat/model/dog_chat_user.dart';

final ThemeData dTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  accentColor: Colors.grey,
  fontFamily: 'Georgia',
  textTheme: TextTheme(
    headline1: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
    headline6: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
    bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
  ),
);
const dMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'メッセージを入力',
  border: InputBorder.none,
);

const dMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.black, width: 2.0),
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
final fireStore = FirebaseFirestore.instance;
String id;
bool isPCWeb = false;
