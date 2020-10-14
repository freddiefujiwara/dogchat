import 'dart:async';

import 'package:dogchat/home.dart';
import 'package:dogchat/chat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      title: 'Google Sign In',
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => new Home(),
        '/chat': (_) => new Chat(),
      },
    ),
  );
}
