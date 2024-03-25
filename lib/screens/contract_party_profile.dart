import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/custom_widgets/profileStatisticCard.dart';

class ContractPartyProfile extends StatefulWidget {
  final Function(int, [String]) changeScreen;
  final String userId;
  final bool offlineMode;

  ContractPartyProfile(this.changeScreen, this.userId, this.offlineMode);

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
    Orientation orientation = MediaQuery.of(context).orientation;

    screenSize = _screenSize(screenWidth);

    return Container(
      child: FutureBuilder<User> (
        future: dataProvider.fetchUserById(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            user = addDummyStatistics(snapshot.data!);
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
            Expanded(child: obligationCompletionRateCard()),
            Expanded(child: ratingCard()),
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
            Expanded(flex: 3, child: ratingCard()),
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
              child: Text('${user!.numGdprFines}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
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
                  child: Text('${user!.avgFineAmount}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
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
                  child: Text('${user!.recentFine}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
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
                  child: Text('${user!.recentViolation}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 1)
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
                      message: "The average amount of obligation this user has completed in time. Only obligations of completed contracts are considered.",
                      child: Icon(Icons.info, color: Colors.grey),
                    )
                )
              ],
            ),
            Container(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 5, 10),
                  child: Text('${user!.oblCompetionRate}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ),
            ),
          ],
        )
    );
  }

  Widget ratingCard() {
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
                    child: Text('Average Contracting\nRating'),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Tooltip(
                      message: "The average rating of this user, rated by their past contracting parties' experiences with this user.",
                      child: Icon(Icons.info, color: Colors.grey),
                    )
                )
              ],
            ),
            Container(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 5, 10),
                  child: starRating(user!.rating!)
                  //child: Text('${user!.rating}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ),
            ),
          ],
        )
    );
  }

  Widget starRating(int rating) {
    List<Icon> stars = [];
    //max amount of starts is 5
    int numEmptyStars = 5 - rating;
    for(int i = 0; i < rating; i++) {
      stars.add(Icon(Icons.star, color: Colors.yellow, size: 25));
    }
    for(int i = 0; i < numEmptyStars; i++) {
      stars.add(Icon(Icons.star_border, color: Colors.grey, size: 25));
    }
    return Row(
      children: [
        stars[0],
        stars[1],
        stars[2],
        stars[3],
        stars[4],
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
        profileDetailElement("Phone Number", user.phone!),
        SizedBox(height: 5),
        profileDetailElement("Email", user.email!),
        SizedBox(height: 5),
        profileDetailElement("Country", user.country!),
        //SizedBox(height: 5),
        //profileDetailElement("State", user.state!),
        SizedBox(height: 5),
        profileDetailElement("City", user.city!),
        SizedBox(height: 5),
        profileDetailElement("Street Address", user.streetAddress!),
      ],
    );
  }

  User addDummyStatistics(User user) {
    if (user.id == "c_12d91e9e-0d1a-11ed-a172-0242ac150002") {
      return addDummyStats(user, 21, "€1000,00", "41 Days Ago", "Art. 13 (2) GDPR", "100%", 5);
    } else if (user.id == "c_d6c5b656-0d19-11ed-8ab1-0242ac150002") {
      return addDummyStats(user, 0, "€0,00", "None", "None", "20%", 1);
    } else if (user.id == "c_3ea24178-0d19-11ed-94d9-0242ac150002") {
      return addDummyStats(user, 1, "€16'000,00", "437 Days Ago", "Art. 5 (1) a) GDPR", "98%", 4);
    } else {
      return addDummyStats(user, 7, "€5'132,00", "3 Days Ago", "Art. 28 (2) GDPR, Art. 3", "80%", 4);
    }
  }

  User addDummyStats(User user, int numGdprFines, String avgFineAmount, String recentFine, String recentViolation, String oblCompletionRate, int rating) {
    user.numGdprFines = numGdprFines;
    user.avgFineAmount = avgFineAmount;
    user.recentFine = recentFine;
    user.recentViolation = recentViolation;
    user.oblCompetionRate = oblCompletionRate;
    user.rating = rating;

    return user;
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