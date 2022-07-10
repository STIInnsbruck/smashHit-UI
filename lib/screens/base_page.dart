import 'package:flutter/material.dart';
import 'package:smashhit_ui/screens/dashboard.dart';
import 'package:smashhit_ui/screens/contract_creation.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/screens/contract_view.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import 'package:smashhit_ui/screens/template_selector.dart';
import 'package:smashhit_ui/screens/contract_violation.dart';
import 'package:smashhit_ui/screens/login.dart';
import 'package:smashhit_ui/screens/contract_update.dart';
import 'package:smashhit_ui/screens/profile_editor.dart';
import 'package:smashhit_ui/screens/contract_party_profile.dart';
import 'package:smashhit_ui/screens/term_type_creation.dart';
import 'package:smashhit_ui/screens/term_type_view.dart';

class BasePage extends StatefulWidget {
  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _selectedIndex = 5;
  String _selectedTitle = "";
  Widget? _selectedPage;
  User? user;
  String? userId;
  final TextEditingController searchBarController = new TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  DataProvider dataProvider = DataProvider();
  String? searchId;

  //Offline Mode set to true to not use the online endpoints.
  //Setting to true will use locally stored json files to read/write data.
  bool offlineMode = false;

  _BasePageState() {
    _selectedPage = LoginScreen(changeScreen, setUserId, setUser, toggleOfflineMode);
    _selectedTitle = "Login Screen";
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
          actions: [inboxIcon(), searchField(screenWidth), searchButton()],
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
              title: Text("View Data Requesters"),
              onTap: () {
                changeScreen(3);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text("View Term Types"),
              onTap: () {
                changeScreen(10);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text("Create a new term"),
              onTap: () {
                changeScreen(9);
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
            ListTile(
              title: Row(children: [
                Icon(Icons.person),
                SizedBox(width: 5),
                Text("Profile")
              ]),
              onTap: () {
                changeScreen(7);
                Navigator.of(context).pop();
              },
            ),
            //Spacer(),
            ListTile(
              title: Row(children: [
                Icon(Icons.logout),
                SizedBox(width: 5),
                Text("Logout")
              ]),
              onTap: () {
                changeScreen(5);
                Navigator.of(context).pop();
              },
            ),
          ]),
        ),
        body: _selectedIndex == 0? Dashboard(changeScreen, user, searchId) : _selectedPage,
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  changeScreen(x, [String? id, List<Obligation>? obligations]) {
    setState(() {
      _selectedIndex = x;
      switch (_selectedIndex) {
        case 0:
          _selectedPage = Dashboard(changeScreen, user, searchId);
          _selectedTitle = "Contracts Dashboard";
          break;
        case 1:
          _selectedPage = ContractCreation(changeScreen, user);
          _selectedTitle = "Contract Creation";
          break;
        case 2:
          _selectedPage = ViewContract(changeScreen, id!, user);
          _selectedTitle = "Contract ID: $id";
          (context as Element).performRebuild();
          break;
        case 3:
          _selectedPage = TemplateSelector(changeScreen, user);
          _selectedTitle = "Template Selector";
          break;
        case 4:
          _selectedPage = ContractViolation(changeScreen, id!, user, obligations!);
          _selectedTitle = "Violation Claim";
          break;
        case 5:
          _selectedPage = LoginScreen(changeScreen, setUserId, setUser, toggleOfflineMode);
          _selectedTitle = "Login Screen";
          break;
        case 6:
          _selectedPage = UpdateScreen(changeScreen, id!, user);
          _selectedTitle = "Change & Update Your Contract";
          break;
        case 7:
          _selectedPage = ProfileEditorPage(changeScreen, userId!);
          _selectedTitle = "Profile Editor";
          break;
        case 8:
          _selectedPage = ContractPartyProfile(changeScreen, id!);
          _selectedTitle = "Profile";
          break;
        case 9:
          _selectedPage = TermTypeCreationPage(changeScreen, user);
          _selectedTitle = "Create Term Types";
          break;
        case 10:
          _selectedPage = TermTypeViewPage(changeScreen, user);
          _selectedTitle = "View Term Types";
      }
    });
  }

  setUserId(String agentId) {
    setState(() {
      userId = agentId;
    });
  }

  setUser(User user) {
    setState(() {
      this.user = user;
    });
  }

  toggleOfflineMode() {
    setState(() {
      offlineMode = !offlineMode;
    });
  }

  Container searchField(double width) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      width: width / 4,
      child: TextFormField(
        maxLines: 1,
        focusNode: _searchFocus,
        controller: searchBarController,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(hintText: "Search for a contract by ID"),
        onChanged: (String value) {
          setSearchId(value);
        },
        onFieldSubmitted: (String value) {
          print("Enter pressed: $value");
          _searchFocus.unfocus();
        },
      ),
    );
  }

  void setSearchId(String value) {
    setState(() {
      searchId = value;
    });
  }

  PopupMenuButton inboxIcon() {
    return PopupMenuButton(
      tooltip: "Show notifications",
      child: Center(
        child: Stack(
          children: [
            Icon(Icons.inbox, size: 40, color: Colors.white),
            CircleAvatar(
              radius: 7,
              backgroundColor: Colors.red[400],
            )
          ],
        ),
      ),
      onSelected: (value) { print("Selected value: $value"); },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Object>>[
        PopupMenuItem(child: Text("Example Notification 1")),
        PopupMenuItem(child: Text("Example Notification 2")),
        PopupMenuItem(child: Text("Example Notification 3")),
        PopupMenuItem(child: Text("Example Notification 4")),
        PopupMenuItem(child: Text("Example Notification 5"))
      ],
    );
  }

  IconButton searchButton() {
    return IconButton(
      icon: Icon(Icons.search),
      iconSize: 30,
      onPressed: () {
        changeScreen(2, searchBarController.text);
      },
    );
  }

  //TODO: implement mail reader
  bool existsUnreadMail() {
    return true;
  }

  Column userInformation(double width) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue,
          backgroundImage: Image.asset('assets/images/placeholders/example_profile_pic.png').image,
          radius: 50,
        ),
        Text("username")
      ],
    );
  }
}
