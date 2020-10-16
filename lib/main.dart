import 'package:dogchat/ui/home/home.dart';
import 'package:dogchat/ui/chat/chat.dart';
import 'package:dogchat/ui/my/my.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dogchat/constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:dogchat/utils_stub.dart' if (dart.library.html) 'dart:html';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  if (kIsWeb) {
    id = Uri.parse(window.location.toString()).queryParameters["id"];
    print("ID:$id");
  }
  runApp(
    MaterialApp(
      title: '🐕 Dog Chat -ワンタイムチャット-',
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => new Home(),
        '/chat': (_) => new Chat(),
        '/issue': (_) => new My(),
      },
    ),
  );
}
