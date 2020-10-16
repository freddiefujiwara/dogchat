import 'dart:async';

import 'package:dogchat/ui/home/home.dart';
import 'package:dogchat/ui/chat/chat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      title: '🐕 Dog Chat -ワンタイムチャット-',
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => new Home(),
        '/chat': (_) => new Chat(),
      },
    ),
  );
}
