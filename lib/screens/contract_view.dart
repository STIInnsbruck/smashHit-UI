import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ViewContract extends StatefulWidget {
  final Function(int, [String]) changeScreen;
  final String contractId;
  final User? user;

  ViewContract(this.changeScreen, this.contractId, this.user);

  @override
  _ContractCreationState createState() => new _ContractCreationState();
}

class _ContractCreationState extends State<ViewContract> {
  List<User> users = [];
  DataProvider dataProvider = new DataProvider();
  Contract? contract;
  String? contractDropDownType;
  TextEditingController? reportViolationController;
  double smallSide = 10;
  double textSize = 0;
  int screenSize = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;

    screenSize = _screenSize(screenWidth);

    getSmallerSide(screenHeight, screenWidth);
    textSize = smallSide / 50;

    return Container(
      child: FutureBuilder<Contract>(
          future: dataProvider.fetchContractById(widget.contractId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              contract = snapshot.data;
              return Container(
                margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: screenHeight,
                    minHeight: screenHeight,
                  ),
                  child: Scrollbar(
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: screenSize == 2
                            ? smallScreenBuild(contract!)
                            : mediumScreenBuild(contract!, orientation)),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("The contract ID you entered was not found.",
                        style: TextStyle(fontSize: 32)),
                    Text('${snapshot.error}')
                  ],
                ),
              );
            }
            // show loading indicator while fetching.
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget mediumScreenBuild(Contract contract, Orientation orientation) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(mainAxisSize: MainAxisSize.min, children: [
          Expanded(child: contractStatusCard(contract)),
          Expanded(flex: 2, child: contractTimeCard(contract)),
          Expanded(child: reportIssueCard(contract))
        ]),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: orientation == Orientation.portrait ? 1.55 : 2.70,
          ),
          shrinkWrap: true,
          itemCount: contract.obligations.length,
          itemBuilder: (BuildContext context, index) {
            return partyObligationCard(contract.obligations[index]);
          }
        ),
        contractDetailsCard(contract),
      ],
    );
  }

  Widget smallScreenBuild(Contract contract) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: contractStatusCard(contract)),
          Expanded(child: reportIssueCard(contract))
        ],
      ),
      contractTimeCard(contract),
      partyObligationCard(contract.getContractorName()),
      partyObligationCard(contract.getContracteeName()),
      contractDetailsCard(contract),
    ]);
  }

  Card partyObligationCard(String obligationId) {
    Obligation? obligation;
    return Card(
      elevation: 10.0,
      child: FutureBuilder<Obligation>(
        future: dataProvider.fetchObligationById(obligationId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            obligation = snapshot.data;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Center(
                        child: Text('Obligation', style: TextStyle(fontSize: 20))),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: GestureDetector(
                      onTap: () {
                        widget.changeScreen(8, "${snapshot.data!.contractorId}");
                      },
                      child: Text(snapshot.data!.contractorId!)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Obligation Description: ',
                          style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      Text(
                        '${snapshot.data!.description}',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Time Remaining: ',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          Text('${snapshot.data!.endDate}')
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Status: ',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          Icon(Icons.check_circle, color: Colors.green, size: 30)
                        ],
                      ),
                    ),
                  ],
                ),
                obligationId.compareTo(widget.user!.name!) == 0
                    ? Center(
                  child: MaterialButton(
                    onPressed: () {
                      _showObligationCompletionDialog();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text('Tap to complete',
                        style: TextStyle(color: Colors.white)),
                    color: Colors.blue,
                  ),
                )
                    : Center(
                  child: MaterialButton(
                    elevation: 0,
                    onPressed: null,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('$obligationId must complete',
                        style: TextStyle(color: Colors.grey)),
                    color: Colors.white,
                  ),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}')
            );
          }
          return Center(child: CircularProgressIndicator());
        }
      )
    );
  }

  Card contractStatusCard(Contract contract) {
    return Card(
      elevation: 10.0,
      child: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Center(
                  child:
                      Text('Contract Status', style: TextStyle(fontSize: 20))),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Center(
                  child:
                      Icon(Icons.check_circle, size: 50, color: Colors.green)),
            ),
          ),
        ],
      ),
    );
  }

  Card reportIssueCard(Contract contract) {
    return Card(
      elevation: 10.0,
      child: InkWell(
          splashColor: Colors.blue,
          onTap: () {
            widget.changeScreen(4, widget.contractId);
          },
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Center(
                      child:
                          Text('Report Issue', style: TextStyle(fontSize: 20))),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Center(
                      child: Icon(Icons.report_problem,
                          size: 50, color: Colors.yellow)),
                ),
              ),
            ],
          )),
    );
  }

  Card contractTimeCard(Contract contract) {
    return Card(
        elevation: 10.0,
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Center(
                    child:
                        Text('Contract Time', style: TextStyle(fontSize: 20))),
              ),
            ),
            Container(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Start: 23.10.2022', style: TextStyle(fontSize: 15)),
                      Text('End: 30.12.2022', style: TextStyle(fontSize: 15))
                    ],
                  )),
            ),
            Container(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.black, width: 1)),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        heightFactor: 1.0,
                        widthFactor: 0.8,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.blue),
                          child: Center(
                              child:
                                  Text('80%', style: TextStyle(fontSize: 15))),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Card contractDetailsCard(Contract contract) {
    return Card(
      elevation: 10.0,
      child: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Center(
                  child:
                      Text('Contract Details', style: TextStyle(fontSize: 20))),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Center(
                  child: Text('${contract.contractId}',
                      style: TextStyle(fontSize: 20))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Contract Type: ${contract.contractType}'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child:
                  Text('Contract Requester: ${contract.getContractorName()}'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Contract Provider: ${contract.getContracteeName()}'),
            ),
          ),
          contractTAC(contract),
          //TODO: adjust to new contract form.
          Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Start Date: ${contract.getFormattedStartDate()}',
                      style: TextStyle(fontSize: 15)))),
          Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      'Effective Date: ${contract.getFormattedStartDate()}',
                      style: TextStyle(fontSize: 15)))),
          Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('End Date: ${contract.getFormattedEndDate()}',
                      style: TextStyle(fontSize: 15)))),
        ],
      ),
    );
  }

  Widget contractTAC(Contract contract) {
    return contract.purpose!.isNotEmpty
        ? Column(
            children: [
              contractTermTitle('Terms and Conditions'),
              contractTermText(contract.purpose!)
            ],
          )
        : Container();
  }

  Widget contractTermTitle(String title) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
        child: Center(
            child: Text(title,
                style: TextStyle(
                    fontSize: 20, decoration: TextDecoration.underline))));
  }

  Widget contractTermText(String text) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
        child: Center(
            child: Text(text,
                style: TextStyle(fontSize: 15), textAlign: TextAlign.justify)));
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
              partyEntity(contract!.contractors[0]
                  .substring(45, contract!.contractors[0].length)),
              partyEntity(contract!.contractors[0]
                  .substring(45, contract!.contractors[0].length)),
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
                  child: Text("Contract Purpose",
                      style: TextStyle(fontSize: textSize)),
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
          onPressed: () {
            _showContractPurposeDialog(width);
          }),
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
              Icon(Icons.compare_arrows,
                  color: Colors.grey, size: smallSide / 10),
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

  /// This function returns the calculated elapsed time of the contract towards the
  /// current day. Return value must be between 0.0 and 1.0 inclusive. If the contract
  /// lies in the past, return 1.0 to represent 100% completion of the contract.
  double calculateElapsedContractTime() {
    DateTime today = DateTime.now();
    var totalTime =
        contract!.endDate!.difference(contract!.executionDate!).inDays;
    var elapsedTime = today.difference(contract!.executionDate!).inDays;

    if (elapsedTime >= totalTime) {
      return 100.0;
    } else if (elapsedTime < 0) {
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

  void _showContractPurposeDialog(double width) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Contract Purpose'),
            content: Scrollbar(
              child: SingleChildScrollView(
                child: Container(
                    width: width / 2, child: Text(contract!.purpose!)),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _dismissDialog();
                },
                child: Text('Close'),
              )
            ],
          );
        });
  }

  void _showObligationCompletionDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Completing Your Obligation'),
            content: Text(
                'You are about to state that you have completed your selected obligation.\nTo finalise the completion of your obligation, a confirmation of the other parties will be required.'),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  _dismissDialog();
                },
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Cancel'),
              ),
              MaterialButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Text('Complete & await confirmation',
                    style: TextStyle(color: Colors.white)),
                color: Colors.blue,
              )
            ],
          );
        });
  }

  String _formatDate(DateTime dateTime) {
    String dateString = '${dateTime.day}.${dateTime.month}.${dateTime.year}';
    return dateString;
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

  _dismissDialog() {
    Navigator.pop(context);
  }
}
