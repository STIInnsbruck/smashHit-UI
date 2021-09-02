import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ViewContract extends StatefulWidget {
  final Function(int) changeScreen;
  User? user;

  ViewContract(this.changeScreen, this.user);

  @override
  _ContractCreationState createState() => new _ContractCreationState();
}

class _ContractCreationState extends State<ViewContract> {
  List<User> users = [];
  DataProvider dataProvider = new DataProvider();
  late Future<Contract> futureContract;
  Contract? contract;
  String? contractDropDownType;

  @override
  void initState() {
    super.initState();
    futureContract = dataProvider.fetchContractById();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      child: FutureBuilder<Contract>(
        future: futureContract,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            contract = snapshot.data;
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: screenHeight,
                minHeight: screenHeight,
              ),
              child: Scrollbar(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      partiesTile(screenWidth, screenHeight),
                                      Container(width: screenWidth / 20),
                                      TOSTile(screenWidth, screenHeight),
                                    ]
                                ),
                                Container(height: screenHeight / 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    contractedEntitiesTile(screenWidth, screenHeight),
                                    Container(width: screenWidth / 20),
                                    statusTile(screenWidth, screenHeight),
                                  ],
                                ),
                              ],
                            ),
                            contractTimeProgressBar(screenWidth, screenHeight),
                          ],
                        ),
                      ]),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          // show loading indicator while fetching.
          return Center(child: CircularProgressIndicator());
        }
      ),
    );
  }

  Widget partiesTile(double width, double height) {
    return Container(
      height: height / 3,
      width: width / 3,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black45,
                blurRadius: 5,
                spreadRadius: 2.5,
                offset: Offset(2.5, 2.5))
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Involved Parties:"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              partyEntity(),
            ],
          )
        ],
      ),
    );
  }

  Widget partyEntity() {
    return Container(
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 22,
              child: Icon(Icons.person),
            ),
          ),
          Text(contract!.title!),
          Text("Primary", style: TextStyle(color: Colors.grey, fontSize: 15))
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget TOSTile(double width, double height) {
    return Container(
      height: height / 3,
      width: width / 3,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black45,
                blurRadius: 5,
                spreadRadius: 2.5,
                offset: Offset(2.5, 2.5))
          ]),
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text("Terms of Service"),
          ),
          Container(
            color: Colors.grey[300],
            height: height / 40,
            width: width / 5,
          ),
          Container(
            color: Colors.grey[300],
            height: height / 40,
            width: width / 10,
          ),
          Container(
            color: Colors.grey[300],
            height: height / 40,
            width: width / 8,
          ),
        ],
      ),
    );
  }

  Widget statusTile(double width, double height) {
    return Container(
      height: height / 3,
      width: width / 3,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black45,
                blurRadius: 5,
                spreadRadius: 2.5,
                offset: Offset(2.5, 2.5))
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Contract Status:"),
          statusIconByContractStatus(height),
        ],
      ),
    );
  }

  /// Takes the current Contract's status and returns the appropriate icon.
  Icon statusIconByContractStatus(double height) {
    switch (contract!.getContractStatusAsInt()) {
      case 0:
        return Icon(Icons.description, color: Colors.grey, size: height / 6);
      case 1:
        return Icon(Icons.work, color: Colors.grey, size: height / 6);
      case 2:
        return Icon(Icons.check_circle, color: Colors.green, size: height / 6);
    }
    return Icon(Icons.check_circle, color: Colors.green, size: height / 6);
  }

  Widget contractedEntitiesTile(double width, double height) {
    return Container(
      height: height / 3,
      width: width / 3,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black45,
                blurRadius: 5,
                spreadRadius: 2.5,
                offset: Offset(2.5, 2.5))
          ]),
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Contracted Entities"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                child: Icon(Icons.person),
                radius: height / 17,
              ),
              Icon(Icons.compare_arrows, color: Colors.grey, size: height / 8),
              CircleAvatar(
                child: Icon(Icons.person),
                radius: height / 17,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget contractTimeProgressBar(double width, double height) {
    return RotatedBox(
      quarterTurns: 1,
      child: Container(
          child: Column(children: [
        Text("Elapsed Contract Time:", style: TextStyle(fontSize: height / 30)),
        LinearPercentIndicator(
          width: height / 1.2,
          lineHeight: width / 40,
          percent: calculateElapsedContractTime() / 100,
          backgroundColor: Colors.grey,
          progressColor: Colors.blue,
          center: Text("${calculateElapsedContractTime()}%",
              style: TextStyle(fontSize: width / 60)),
        ),
      ])),
    );
  }

  /// This function returns the calculated elapsed time of the contract towards the
  /// current day. Return value must be between 0.0 and 1.0 inclusive. If the contract
  /// lies in the past, return 1.0 to represent 100% completion of the contract.
  double calculateElapsedContractTime() {
    DateTime today = DateTime.now();
    var totalTime =
        contract!.expireDate!.difference(contract!.executionDate!).inDays;
    var elapsedTime = today.difference(contract!.executionDate!).inDays;

    if(elapsedTime >= totalTime) {
      return 100.0;
    } else {
      double progressPercentage = (elapsedTime / totalTime) * 100;
      return progressPercentage.roundToDouble();
    }
  }
}
