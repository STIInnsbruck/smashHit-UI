import 'package:flutter/material.dart';
import 'package:smashhit_ui/screens/base_page.dart';

void main() {
  runApp(SmashHitApp());
}

class SmashHitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/contract/',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BasePage(),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/contract/':
            return MaterialPageRoute(
                builder: (_) => new SafeArea(child: BasePage()),
                settings: settings
            );
        }
      }
    );
  }
}
