import 'package:flutter/material.dart';
import 'package:smashhit_ui/screens/dashboard.dart';
import 'package:smashhit_ui/screens/contract_creation.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/screens/view_contract.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import 'package:smashhit_ui/screens/template_selector.dart';
import 'package:smashhit_ui/screens/contract_violation.dart';
import 'package:smashhit_ui/screens/login.dart';
import 'package:smashhit_ui/screens/contract_update.dart';

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
    _selectedTitle = "Contracts Dashboard";
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
        appBar: _selectedIndex == 5 ? null : AppBar(
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
              title: Text("Contracts Dashboard"),
              onTap: () {
                changeScreen(0);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text("Create a new contract"),
              onTap: () {
                changeScreen(3);
                Navigator.of(context).pop();
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
          _selectedTitle = "Contracts Dashboard";
          break;
        case 1:
          _selectedPage = ContractCreation(changeScreen, currentUser);
          _selectedTitle = "Contract Creation";
          break;
        case 2:
          _selectedPage = ViewContract(changeScreen, contractId!, currentUser);
          _selectedTitle = "Contract ID: $contractId";
          (context as Element).performRebuild();
          break;
        case 3:
          _selectedPage = TemplateSelector(changeScreen, currentUser);
          _selectedTitle = "Template Selector";
          break;
        case 4:
          _selectedPage = ContractViolation(changeScreen, contractId!, currentUser);
          _selectedTitle = "Violation Claim";
          break;
        case 5:
          _selectedPage = LoginScreen(changeScreen);
          _selectedTitle = "Login Screen";
          break;
        case 6:
          _selectedPage = UpdateScreen(changeScreen, contractId!, currentUser);
          _selectedTitle = "Change & Update Your Contract";
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
        textAlign: TextAlign.center,
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
