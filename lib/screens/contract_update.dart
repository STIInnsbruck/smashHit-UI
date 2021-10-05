import 'package:flutter/material.dart';

class UpdateScreen extends StatefulWidget {
  Function(int) changeScreen;

  UpdateScreen(this.changeScreen);

  @override
  _UpdateScreenState createState() => new _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
    );
  }

}