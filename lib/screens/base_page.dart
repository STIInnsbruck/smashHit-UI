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
import 'package:smashhit_ui/screens/obligation_dashboard.dart';
import 'package:smashhit_ui/screens/contractors_view.dart';

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
  bool _isComplianceChecking = false;

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
          actions: [checkComplianceButton(), searchField(screenWidth), searchButton()],
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
              title: Text("View My Obligations"),
              onTap: () {
                changeScreen(11);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text("View Data Requesters"),
              onTap: () {
                changeScreen(12);
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
        body: Stack(
          children: [
            _selectedIndex == 0? Dashboard(changeScreen, user, searchId, offlineMode) : _selectedPage!,
            _isComplianceChecking ? showCheckingCompliance() : Container()
          ],
        ),
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  changeScreen(x, [String? id, List<Obligation>? obligations]) {
    setState(() {
      _selectedIndex = x;
      switch (_selectedIndex) {
        case 0:
          _selectedPage = Dashboard(changeScreen, user, searchId, offlineMode);
          _selectedTitle = "Contracts Dashboard";
          break;
        case 1:
          _selectedPage = ContractCreation(changeScreen, user, offlineMode);
          _selectedTitle = "Contract Creation";
          break;
        case 2:
          _selectedPage = ViewContract(changeScreen, id!, user, offlineMode);
          _selectedTitle = "Contract ID: $id";
          (context as Element).performRebuild();
          break;
        case 3:
          _selectedPage = TemplateSelector(changeScreen, user);
          _selectedTitle = "Template Selector";
          break;
        case 4:
          _selectedPage = ContractViolation(changeScreen, id!, user, obligations!, offlineMode);
          _selectedTitle = "Violation Claim";
          break;
        case 5:
          _selectedPage = LoginScreen(changeScreen, setUserId, setUser, toggleOfflineMode);
          _selectedTitle = "Login Screen";
          break;
        case 6:
          _selectedPage = UpdateScreen(changeScreen, id!, user, offlineMode);
          _selectedTitle = "Change & Update Your Contract";
          break;
        case 7:
          _selectedPage = ProfileEditorPage(changeScreen, userId!, offlineMode);
          _selectedTitle = "Profile Editor";
          break;
        case 8:
          _selectedPage = ContractPartyProfile(changeScreen, id!, offlineMode);
          _selectedTitle = "Profile";
          break;
        case 9:
          _selectedPage = TermTypeCreationPage(changeScreen, user, offlineMode, id);
          _selectedTitle = "Create Clause Types";
          break;
        case 10:
          _selectedPage = TermTypeViewPage(changeScreen, user, offlineMode);
          _selectedTitle = "View Clause Types";
          break;
        case 11:
          _selectedPage = ObligationsDashboard(changeScreen, user, searchId, offlineMode);
          _selectedTitle = "View My Obligations";
          break;
        case 12:
          _selectedPage = ContractorViewPage(changeScreen, user, offlineMode);
          _selectedTitle = "View Data Requesters";
      }
    });
  }

  Widget showCheckingCompliance() {
    return Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.grey[50],
        child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                Text("Checking contract compliance. Please wait.")
              ],
            )));
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

  Widget checkComplianceButton() {
    return Tooltip(
      message: "Start automatic compliance check.",
      child: IconButton(
        icon: Icon(Icons.published_with_changes),
        onPressed: () async {
          setState(() { _isComplianceChecking = true; });
          bool flag = await dataProvider.checkCompliance();
          setState(() { _isComplianceChecking = false; });
        },
      ),
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
        Text("Max Mustermann")
      ],
    );
  }
}
