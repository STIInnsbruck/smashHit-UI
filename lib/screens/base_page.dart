import 'package:flutter/material.dart';
import 'package:smashhit_ui/screens/dashboard.dart';
import 'package:smashhit_ui/data/models.dart';

class BasePage extends StatefulWidget {
  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _selectedIndex = 0;
  String _selectedTitle = "";
  Widget _selectedPage;
  User currentUser;

  _BasePageState() {
    _selectedPage = Dashboard(changeScreen, currentUser);
    _selectedTitle = "Dashboard";
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Center(child: Text(_selectedTitle)),
        actions: [
          searchField(screenWidth),
          searchButton()
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.grey),
              child: userInformation(screenWidth),
            ),
            ListTile(
              title: Text("Dashboard"),
              onTap: () {
                //Do something.
              },
            ),
            ListTile(
              title: Text("Contacts"),
              onTap: () {
                //Do something.
              },
            ),
            ListTile(
              title: Text("Create a new contract"),
              onTap: () {
                //Do something.
              },
            )]),
      ),
      body: _selectedPage,
    );
  }

  changeScreen(x) {
    setState(() {
      _selectedIndex = x;
      switch (_selectedIndex) {
        case 0:
          _selectedPage = Dashboard(changeScreen, currentUser);
          _selectedTitle = "Dashboard";
      }
    });
  }

  Container searchField(double width) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      width: width / 6,
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
            hintText: "Search..."
        ),
      ),
    );
  }

  IconButton searchButton() {
    return IconButton(
      icon: Icon(Icons.search),
      iconSize: 25,
      onPressed: () {},
    );
  }

  Column userInformation(double width) {
    return Column(
      children: [
        CircleAvatar(
          child: Icon(Icons.person),
          radius: 50,
        ),
        Text("Name Surname")
      ],
    );
  }
}
