import 'package:flutter/material.dart';
import 'package:smashhit_ui/screens/base_page.dart';

void main() {
  runApp(SmashHitApp());
}

class SmashHitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BasePage(),
    );
  }
}
