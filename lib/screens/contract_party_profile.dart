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
              child: screenSize == 2
                  ? Container()
                  : mediumScreenBuild(user!)
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
            Spacer(flex: 4),
            Expanded(flex: 4, child: profilePicture()),
            Spacer(flex: 1),
            Expanded(flex: 8, child: profileDetails(user)),
            Spacer(flex: 8)
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
        SizedBox(height: 5),
        profileDetailElement("Name", user.name!),
        SizedBox(height: 5),
        profileDetailElement("Phone Number", user.telephoneNumber!),
        SizedBox(height: 5),
        profileDetailElement("Email", user.email!),
        SizedBox(height: 5),
        profileDetailElement("Country", user.country!),
        SizedBox(height: 5),
        profileDetailElement("State", user.state!),
        SizedBox(height: 5),
        profileDetailElement("City", user.city!),
        SizedBox(height: 5),
        profileDetailElement("Street Address", user.streetAddress!),
      ],
    );
  }

  Widget profileDetailElement(String elementName, String elementData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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