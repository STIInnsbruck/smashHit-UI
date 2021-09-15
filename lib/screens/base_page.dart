import 'package:flutter/material.dart';
import 'package:smashhit_ui/screens/dashboard.dart';
import 'package:smashhit_ui/screens/contract_creation.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/screens/view_contract.dart';
import 'package:smashhit_ui/data/data_provider.dart';

class BasePage extends StatefulWidget {
  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _selectedIndex = 0;
  String _selectedTitle = "";
  Widget? _selectedPage;
  User? currentUser;
  final TextEditingController searchBarController = new TextEditingController();
  DataProvider dataProvider = DataProvider();

  _BasePageState() {
    _selectedPage = Dashboard(changeScreen, currentUser);
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
          actions: [searchField(screenWidth), searchButton()],
        ),
        drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
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
              title: Text("Create a new contract"),
              onTap: () {
                changeScreen(1);
              },
            ),
            ListTile(
              title: Text("View Contract"),
              onTap: () {
                changeScreen(2);
              },
            ),
          ]),
        ),
        body: _selectedPage,
        resizeToAvoidBottomInset: false,
      ),
    );
  }

  changeScreen(x, [String? contractId]) {
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
        case 2:
          _selectedPage = ViewContract(changeScreen, contractId!, currentUser);
          (context as Element).markNeedsBuild();
          _selectedTitle = "Contract ID: $contractId";
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
        controller: searchBarController,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(hintText: "Search for a contract by ID"),
      ),
    );
  }

  IconButton searchButton() {
    return IconButton(
      icon: Icon(Icons.search),
      iconSize: 25,
      onPressed: () {
        changeScreen(2, searchBarController.text);
      },
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
