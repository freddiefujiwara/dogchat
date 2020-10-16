import 'package:dogchat/ui/home/home.dart';
import 'package:dogchat/ui/chat/chat.dart';
import 'package:dogchat/ui/issue/issue.dart';
import 'package:flutter/material.dart';
import 'package:dogchat/constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:dogchat/utils_stub.dart' if (dart.library.html) 'dart:html';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        '/issue': (_) => new Issue(),
      },
    ),
  );
}
