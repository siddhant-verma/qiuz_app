import 'package:flutter/material.dart';
import 'package:quiz_app/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Color.fromRGBO(225, 212, 0, 100)),
      home: Home(),
    );
  }
}
