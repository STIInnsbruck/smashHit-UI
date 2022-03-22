import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import 'package:smashhit_ui/data/models.dart';

class ContractPartyProfile extends StatefulWidget {
  final Function(int, [String]) changeScreen;
  final String userId;

  ContractPartyProfile(this.changeScreen, this.userId);

  @override
  _ContractPartyProfileState createState() => _ContractPartyProfileState();
}

class _ContractPartyProfileState extends State<ContractPartyProfile> {

  DataProvider dataProvider = new DataProvider();
  late Future<User> futureUser = User() as Future<User>;
  User? user;
  int screenSize = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      child: FutureBuilder<User> (
        future: dataProvider.fetchUserById(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            user = snapshot.data;
            return Container(
              margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: screenHeight,
                  minWidth: screenHeight,
                ),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: screenSize == 2
                      ? Container()
                      : mediumScreenBuild(user!)
                  ),
                ),
              )
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("The user's profile was not found.", style: TextStyle(fontSize: 32)),
                  Text('${snapshot.error}')
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        }
      )
    );
  }

  Widget mediumScreenBuild(User user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: profilePicture()),
            Expanded(child: profileDetails(user))
          ],
        )
      ],
    );
  }

  Widget profilePicture() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Profile Picture"),
        CircleAvatar(
          backgroundColor: Colors.blue,
          backgroundImage: Image.asset('assets/images/placeholders/example_profile_pic.png').image,
          radius: 75,
        )
      ],
    );
  }

  Widget profileDetails(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Profile Details"),
        profileDetailElement("Name", user.name!)
      ],
    );
  }

  Widget profileDetailElement(String elementName, String elementData) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("$elementName:", style: TextStyle(color: Colors.grey)),
        Text("$elementData")
      ],
    );
  }

  ///Return and integer deciding if big, medium or small screen.
  ///0 = Big. 1 = Medium. 2 = Small.
  _screenSize(double width) {
    if (width > 800) {
      return 0;
    } else if (width <= 800 && width > 500) {
      return 1;
    } else {
      return 2;
    }
  }

}