import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';


class ViewContract extends StatefulWidget {
  final Function(int, [String]) changeScreen;
  final String contractId;
  User? user;

  ViewContract(this.changeScreen, this.contractId, this.user);

  @override
  _ContractCreationState createState() => new _ContractCreationState();
}

class _ContractCreationState extends State<ViewContract> {
  List<User> users = [];
  DataProvider dataProvider = new DataProvider();
  late Future<Contract> futureContract;
  Contract? contract;
  String? contractDropDownType;
  TextEditingController? reportViolationController;
  double smallSide = 10;
  double textSize = 0;


  @override
  void initState() {
    super.initState();
    futureContract = dataProvider.fetchContractById(widget.contractId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    getSmallerSide(screenHeight, screenWidth);
    textSize = smallSide / 50;

    return Container(
      child: FutureBuilder<Contract>(
        future: futureContract,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            contract = snapshot.data;
            return Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: screenHeight,
                  minHeight: screenHeight,
                ),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
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
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("The contract ID you entered was not found.", style: TextStyle(fontSize: 32)),
                  Text('${snapshot.error}')
                ],
              ),
            );
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
          Text("Involved Parties:", style: TextStyle(fontSize: textSize)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //first 45 characters are the URI from the ontology
              partyEntity(contract!.contractorId!.substring(45, contract!.contractorId!.length)),
              partyEntity(contract!.contracteeId!.substring(45, contract!.contracteeId!.length)),
            ],
          )
        ],
      ),
    );
  }

  Widget partyEntity(String partyName) {
    return Container(
      child: Column(
        children: [
          CircleAvatar(
            radius: smallSide / 25,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: smallSide / 30,
              child: Icon(Icons.person),
            ),
          ),
          Text(partyName, style: TextStyle(fontSize: textSize)),
          //Text("Primary", style: TextStyle(color: Colors.grey, fontSize: 15))
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget TOSTile(double width, double height) {
    return Tooltip(
      message: 'Click to view contract details.',
      child: MaterialButton(
        child: Container(
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
                child: Text("Contract Purpose", style: TextStyle(fontSize: textSize)),
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
        ),
        onPressed: () { _showContractPurposeDialog(width); }
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
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Contract Status:", style: TextStyle(fontSize: textSize)),
                statusIconByContractStatus(height)
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: reportViolationButton(),
          )
        ],
      ),
    );
  }

  Widget reportViolationButton() {
    return IconButton(
      iconSize: smallSide / 15,
      padding: EdgeInsets.zero,
      icon: Icon(Icons.report_problem, color: Colors.orange),
      tooltip: 'Report a contract violation.',
      onPressed: () {
        widget.changeScreen(4, widget.contractId);
      },
    );
  }

  /// Takes the current Contract's status and returns the appropriate icon.
  Widget statusIconByContractStatus(double height) {
    switch (contract!.getContractStatusAsInt()) {
      case 0:
        return Column(
          children: [
            Icon(Icons.description, color: Colors.grey, size: smallSide / 6),
            Text("The contract is still being created.")
          ],
        );
      case 1:
        return Column(
          children: [
            Icon(Icons.work, color: Colors.grey, size: smallSide / 6),
            Text("Contract is still under negotiation.")
          ],
        );
      case 2:
        return Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: smallSide / 6),
            Text("The contract is valid.")
          ],
        );
      case 5:
        return Column(
          children: [
            Icon(Icons.report, color: Colors.red, size: smallSide / 6),
            Text("A violation has been reported.")
          ],
        );
    }
    return Column(
      children: [
        Icon(Icons.check_circle, color: Colors.green, size: smallSide / 6),
        Text("The contract is valid.")
      ],
    );
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
      //padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Contracted Entities", style: TextStyle(fontSize: textSize)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                child: Icon(Icons.person),
                radius: smallSide / 18,
              ),
              Icon(Icons.compare_arrows, color: Colors.grey, size: smallSide / 10),
              CircleAvatar(
                child: Icon(Icons.person),
                radius: smallSide / 18,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget contractTimeProgressBar(double width, double height) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Start Date: ${_formatDate(contract!.executionDate!)}", overflow: TextOverflow.ellipsis),
          Container(height: 20),
          RotatedBox(
            quarterTurns: 1,
            child: Container(
                child: Column(children: [
                  Text("Elapsed Contract Time:", style: TextStyle(fontSize: smallSide / 30)),
                  LinearPercentIndicator(
                    width: height / 1.4,
                    lineHeight: smallSide / 30,
                    percent: calculateElapsedContractTime() / 100,
                    backgroundColor: Colors.grey,
                    progressColor: Colors.blue,
                    center: Text("${calculateElapsedContractTime()}%",
                        style: TextStyle(fontSize: width / 60)),
                  ),
                ])),
          ),
          Container(height: 20),
          Text("End Date: ${_formatDate(contract!.expireDate!)}", overflow: TextOverflow.ellipsis)
        ],
      ),
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
    } else if (elapsedTime < 0){
      return 0.0;
    } else {
      double progressPercentage = (elapsedTime / totalTime) * 100;
      return progressPercentage.roundToDouble();
    }
  }

  void getSmallerSide(double height, double width) {
    setState(() {
      if (height >= width) {
        smallSide = width;
      } else {
        smallSide = height;
      }
    });
  }

  void _showReportViolationDialog() {
    reportViolationController = new TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reporting a contract violation'),
          content: TextField(
            controller: reportViolationController,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(hintText: "Please enter and explain the violation of the contract."),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _dismissDialog();
              },
              child: Text('Cancel')
            ),
            TextButton(
              onPressed: () {
                print('sending report...');
                setState(() {
                  contract!.contractStatus = 'Violation';
                });
                _dismissDialog();
              },
              child: Text('Send Report')
            )
          ],
        );
      }
    );
  }

  void _showContractPurposeDialog(double width) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Contract Purpose'),
          content: Scrollbar(
            child: SingleChildScrollView(
              child: Container(
                  width: width / 2,
                  child: Text(contract!.description!)),
            ),
          ),
          actions: <Widget> [
            TextButton(
              onPressed: () {
                _dismissDialog();
              },
              child: Text('Close'),
            )
          ],
        );
      }
    );
  }
  
  String _formatDate(DateTime dateTime) {
    String dateString = '${dateTime.day}.${dateTime.month}.${dateTime.year}';
    return dateString;
  }

  _dismissDialog() {
    Navigator.pop(context);
  }
}
