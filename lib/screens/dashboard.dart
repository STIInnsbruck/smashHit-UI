import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';

class Dashboard extends StatefulWidget {

  final Function(int) changeScreen;
  User user;

  Dashboard(this.changeScreen, this.user);

  @override
  _DashboardState createState() => new _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;

    return Container();
  }
}