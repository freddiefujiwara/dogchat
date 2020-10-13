import 'package:dogchat/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// Import the firebase_core plugin

void main() async {

WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(Login());
}
