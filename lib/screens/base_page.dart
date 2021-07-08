import 'package:flutter/material.dart';
import 'package:smashhit_ui/screens/dashboard.dart';
import 'package:smashhit_ui/screens/contract_creation.dart';
import 'package:smashhit_ui/data/models.dart';

class BasePage extends StatefulWidget {
  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _selectedIndex = 0;
  String _selectedTitle = "";
  Widget? _selectedPage;
  User? currentUser;

  _BasePageState() {
    _selectedPage = ContractCreation(changeScreen, currentUser);
    _selectedTitle = "Dashboard";
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Center(child: Text(_selectedTitle)),
          actions: [
            searchField(screenWidth),
            searchButton()
          ],
          /**bottom: TabBar(
            tabs: [
              Tab(
                text: "Personal Data",
              ),
              Tab(
                text: "Leasing",
              ),
              Tab(
                text: "Real Estate",
              ),
              Tab(
                text: "Subscriptions"
              )
            ],
          ),*/
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: userInformation(screenWidth),
              ),
              ListTile(
                title: Text("Dashboard"),
                onTap: () {
                  changeScreen(0);
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
                  changeScreen(1);
                },
              )]),
        ),
        body: _selectedPage,
        resizeToAvoidBottomInset: false,
      ),
    );
  }

  changeScreen(x) {
    setState(() {
      _selectedIndex = x;
      switch (_selectedIndex) {
        case 0:
          _selectedPage = Dashboard(changeScreen, currentUser);
          _selectedTitle = "Dashboard";
          break;
        case 1:
          _selectedPage = ContractCreation(changeScreen, currentUser);
          _selectedTitle = "Contract Creation";
          break;
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
          backgroundColor: Colors.lightGreen,
          child: Icon(Icons.person),
          radius: 50,
        ),
        Text("Name Surname")
      ],
    );
  }
}
