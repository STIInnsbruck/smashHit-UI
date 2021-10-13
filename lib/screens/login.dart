import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final Function(int) changeScreen;

  LoginScreen(this.changeScreen);

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Material(
        child: Center(
          child: Container(
            width: screenWidth * 0.7,
            child: Column(
      children: [
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("smash",style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                Text("Hit", style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.blue))
              ],
            ),
            Spacer(),
            CircleAvatar(
              radius: screenWidth * 0.10,
              backgroundColor: Colors.grey,
              child: CircleAvatar(
                radius: screenWidth * 0.098,
                backgroundColor: Colors.white,
                child: Container(
                  width: screenWidth * 0.192,
                  height: screenWidth * 0.192,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.bottomCenter,
                  child: ClipOval(
                    child: Icon(Icons.person, size: screenWidth * 0.192, color: Colors.white),
                  ),
                )
              ),
            ),
            Spacer(),
            Container(
              width: screenWidth * 0.20,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Username',
                  hintStyle: TextStyle(fontSize: 30)
                ),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              )
            ),
            Container(),
            Container(
              width: screenWidth * 0.20,
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(fontSize: 30),
                ),
                obscureText: true,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              )
            ),
            Spacer(flex: 2),
            Row(
              children: [
                Spacer(flex: 2),
                MaterialButton(
                  onPressed: () {
                    widget.changeScreen(0);
                  },
                  child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 50)),
                  elevation: 10,
                  color: Colors.grey,
                  minWidth: screenWidth * 0.12,
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                ),
                Spacer(),
                MaterialButton(
                  onPressed: () {},
                  child: Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 50)),
                  elevation: 10,
                  color: Colors.grey,
                  minWidth: screenWidth * 0.12,
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                ),
                Spacer(flex: 2),
              ],
            ),
            Spacer(flex: 4)
      ],
    ),
          ),
        ));
  }
}
