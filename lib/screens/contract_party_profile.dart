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
    Orientation orientation = MediaQuery.of(context).orientation;

    screenSize = _screenSize(screenWidth);

    return Container(
      child: FutureBuilder<User> (
        future: dataProvider.fetchUserById(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            user = snapshot.data;
            return Container(
              margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: screenSize == 2
                  ? smallScreenBuild(user!, orientation)
                  : mediumScreenBuild(user!, orientation)
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

  Widget mediumScreenBuild(User user, Orientation orientation) {
    return orientation == Orientation.portrait
        ? mediumPortrait(user)
        : mediumLandscape(user);
  }

  Widget mediumLandscape(User user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(flex: 4),
            Expanded(flex: 4, child: profilePicture()),
            Spacer(flex: 1),
            Expanded(flex: 8, child: profileDetails(user)),
            Spacer(flex: 8)
          ],
        ),
        Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Expanded(flex: 1, child: gdprFineCountCard()),
            Expanded(flex: 1, child: averageGdprFineCard()),
            Expanded(flex: 1, child: mostRecentFineDateCard()),
            Spacer(),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Expanded(child: mostRecentFineTypeCard()),
            Expanded( child: obligationCompletionRateCard()),
            Spacer(),
            Spacer(),
          ],
        ),
        Spacer()
      ],
    );
  }

  Widget mediumPortrait(User user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(flex: 4),
            Expanded(flex: 4, child: profilePicture()),
            Spacer(flex: 1),
            Expanded(flex: 8, child: profileDetails(user)),
            Spacer(flex: 8)
          ],
        ),
        Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Expanded(flex: 3, child: gdprFineCountCard()),
            Expanded(flex: 3, child: averageGdprFineCard()),
            Expanded(flex: 3, child: mostRecentFineDateCard()),
            Spacer(),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Expanded(flex: 3, child: mostRecentFineTypeCard()),
            Expanded(flex: 3, child: obligationCompletionRateCard()),
            Spacer(flex: 3),
            Spacer(),
          ],
        ),
        Spacer()
      ],
    );
  }

  Widget smallScreenBuild(User user, Orientation orientation) {
    return orientation == Orientation.portrait
        ? smallPortrait(user)
        : smallLandscape(user);
  }

  Widget smallPortrait(User user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(flex: 4),
            Expanded(flex: 4, child: profilePicture()),
            Spacer(flex: 1),
            Expanded(flex: 8, child: profileDetails(user)),
            Spacer(flex: 8)
          ],
        ),
        Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Expanded(flex: 5, child: gdprFineCountCard()),
            Expanded(flex: 5, child: averageGdprFineCard()),
            Spacer(),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Expanded(flex: 5, child: mostRecentFineDateCard()),
            Expanded(flex: 5, child: mostRecentFineTypeCard()),
            Spacer()
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Expanded(flex: 5, child: obligationCompletionRateCard()),
            Spacer(),
          ],
        ),
        Spacer()
      ],
    );
  }

  Widget smallLandscape(User user) {
    return Container();
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

  Widget gdprFineCountCard() {
    return Card(
      elevation: 10.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 0, 5),
                  child: Text('Total GDPR\nFines'),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Tooltip(
                    message: 'The amount of publicly listed GDPR violations issued to this user.',
                    child: Icon(Icons.info, color: Colors.grey),
                  )
              )
            ],
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 5, 10),
              child: Text('13', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
            ),
          ),
        ],
      )
    );
  }

  Widget averageGdprFineCard() {
    return Card(
        elevation: 10.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 0, 5),
                    child: Text('Average Fine\nAmount'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Tooltip(
                    message: 'The overall average of all publicly available GDPR fines issued to this user.\n Higher fines are given depending on the severity of the violation.',
                    child: Icon(Icons.info, color: Colors.grey),
                  )
                )
              ],
            ),
            Container(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 5, 10),
                  child: Text("€13'213,00", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ),
            ),
          ],
        )
    );
  }

  Widget mostRecentFineDateCard() {
    return Card(
        elevation: 10.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 0, 5),
                    child: Text('Most Recent\nFine'),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Tooltip(
                      message: 'The amount of days ago when the most recent publicly available GDPR fine was issued to this user.',
                      child: Icon(Icons.info, color: Colors.grey),
                    )
                )
              ],
            ),
            Container(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 5, 10),
                  child: Text('29 Days ago', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ),
            ),
          ],
        )
    );
  }

  Widget mostRecentFineTypeCard() {
    return Card(
        elevation: 10.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 0, 5),
                    child: Text('Most Recent\nViolation Type'),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Tooltip(
                      message: "The violation description of this user's most recently issued GDPR violation.",
                      child: Icon(Icons.info, color: Colors.grey),
                    )
                )
              ],
            ),
            Container(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 5, 10),
                  child: Text('Art. 28 (2) GDPR, Art. 32 GDPR', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 1)
              ),
            ),
          ],
        )
    );
  }

  Widget obligationCompletionRateCard() {
    return Card(
        elevation: 10.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 0, 5),
                    child: Text('Obligation\nCompletion Rate'),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Tooltip(
                      message: "The violation description of this user's most recently issued GDPR violation.",
                      child: Icon(Icons.info, color: Colors.grey),
                    )
                )
              ],
            ),
            Container(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 5, 10),
                  child: Text('100%', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ),
            ),
          ],
        )
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