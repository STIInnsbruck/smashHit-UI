import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Material(
      child: Column(
        children: [
          Text("SmashHit"),
          CircleAvatar(
            radius: screenWidth * 0.11,
          ),
          TextFormField(),
          TextFormField(),
          Row(
            children: [
              ElevatedButton(onPressed: null, child: Text("LOGIN")),
              Spacer(),
              ElevatedButton(onPressed: null, child: Text("SIGN UP"))
            ],
          )
        ],
      )
    );
  }
}