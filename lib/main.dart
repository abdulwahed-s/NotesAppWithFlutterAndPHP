// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:nots/auth/login.dart';
import 'package:nots/auth/signup.dart';
import 'package:nots/screens/addnotes.dart';
import 'package:nots/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences shared;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  shared = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    showSemanticsDebugger: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      initialRoute: shared.getString('id')==null?'login':'home',
      routes: {
        "login": (context) => Login(),
        "signup": (context) => Signup(),
        "home": (context) => Home(),
        "add":(context) => AddNotes(),
      },
    );
  }
}
