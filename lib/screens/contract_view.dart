import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ViewContract extends StatefulWidget {
  final Function(int, [String, List<Obligation>]) changeScreen;
  final String contractId;
  final User? user;

  ViewContract(this.changeScreen, this.contractId, this.user);

  @override
  _ContractCreationState createState() => new _ContractCreationState();
}

class _ContractCreationState extends State<ViewContract> {
  List<Widget> contractorWidgets = [];
  List<Widget> termWidgets = [];
  List<Obligation> obligations = [];
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
          physics: NeverScrollableScrollPhysics(),
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
    return Card(
      elevation: 10.0,
      child: FutureBuilder<Obligation>(
        future: dataProvider.fetchObligationById(obligationId),
        builder: (context, obligationSnapshot) {
          if (obligationSnapshot.hasData) {
            obligations.add(obligationSnapshot.data!);
            return FutureBuilder<User>(
              future: dataProvider.fetchUserById(obligationSnapshot.data!.contractorId!),
              builder: (context, userSnapshot) {
                if (userSnapshot.hasData) {
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
                              widget.changeScreen(8, "${obligationSnapshot.data!.contractorId}");
                            },
                            child: Text('${userSnapshot.data!.name}')),
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
                              '${obligationSnapshot.data!.description}',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.justify,
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Time Remaining: ',
                                    style: TextStyle(
                                        fontSize: 15, fontWeight: FontWeight.bold)),
                                Text('${obligationSnapshot.data!.getEndDateAsString()}')
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Status: ',
                                    style: TextStyle(
                                        fontSize: 15, fontWeight: FontWeight.bold)),
                                obligationIconByStatus(obligationSnapshot.data!.state!)
                              ],
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Center(child: obligationCardButton(obligationSnapshot.data!, userSnapshot.data!)),
                      /**userSnapshot.data!.name!.compareTo(widget.user!.name!) == 0
                          ? Center(
                        child: MaterialButton(
                          onPressed: () {
                            _showObligationCompletionDialog(obligationSnapshot.data!);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text('Tap to confirm completion',
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
                          child: Text('${userSnapshot.data!.name!} must complete',
                              style: TextStyle(color: Colors.grey)),
                          color: Colors.white,
                        ),
                      )*/
                    ],
                  );
                } else if (userSnapshot.hasError) {
                  return Text('${userSnapshot.error}');
                }
                return Center(child: CircularProgressIndicator());
              },
            );
          } else if (obligationSnapshot.hasError) {
            return Center(
              child: Text('${obligationSnapshot.error}')
            );
          }
          return Center(child: CircularProgressIndicator());
        }
      )
    );
  }

  MaterialButton obligationCardButton(Obligation obligation, User user) {
    if (user.id!.compareTo(widget.user!.id!) == 0) {
      if (obligation.state!.compareTo("hasFulfilled") == 0) {
        return MaterialButton(
          elevation: 0,
          onPressed: null,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text('Obligation already completed',
              style: TextStyle(color: Colors.grey)),
          color: Colors.white,
        );
      } else {
        return MaterialButton(
          onPressed: () {
            _showObligationCompletionDialog(obligation);
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          child: Text('Tap to confirm completion',
              style: TextStyle(color: Colors.white)),
          color: Colors.blue,
        );
      }
    } else {
      return MaterialButton(
        elevation: 0,
        onPressed: null,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text('${user.name!} must complete',
            style: TextStyle(color: Colors.grey)),
        color: Colors.white,
      );
    }
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
                      contractIconByStatus(contract.contractStatus!)),
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
            widget.changeScreen(4, widget.contractId, obligations);
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
    double percentageCompleted = calculateElapsedContractTime();
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
                      Text('Start: ${contract.getFormattedStartDate()}', style: TextStyle(fontSize: 15)),
                      Text('End: ${contract.getFormattedEndDate()}', style: TextStyle(fontSize: 15))
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
                        widthFactor: percentageCompleted / 100,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.blue),
                          child: Center(
                              child:
                                  Text('${percentageCompleted.toInt()}%', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
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
    buildContractUsers(contract);
    buildContractTerms(contract);
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
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 1),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: contractDetailText("Contract ID: ", "${contract.contractId}")),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 1, 15, 1),
            child: Align(
              alignment: Alignment.centerLeft,
              child: contractDetailText("Contract Type: ", "${contract.contractType}"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 1, 15, 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: contractDetailText("Contract Medium: ", "${contract.medium}"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 1, 15, 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: contractDetailText("Contract Category: ", "${contract.contractCategory}"),
            ),
          ),
          Column(
            children: contractorWidgets,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 1, 15, 1),
            child: Align(
              alignment: Alignment.centerLeft,
              child: contractDetailText("Purpose: ", "${contract.purpose}"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 1, 15, 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: contractDetailText("Consideration: ", "${contract.considerationDescription}"),
            ),
          ),
          contractTAC(contract),
          termWidgets.isNotEmpty
            ? Column(
            children: termWidgets,
          )
            : Center(child: Text("No terms were found in the contract.")),
          Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: contractDates()
          )
        ],
      ),
    );
  }

  Widget contractDates() {
    return Row(
      children: [
        Expanded(child: contractDetailText("Effective Date:", contract!.getFormattedEffectiveDate())),
        Expanded(child: contractDetailText("Execution Date:", contract!.getFormattedExecutionDate())),
        Expanded(child: contractDetailText("End Date:", contract!.getFormattedEndDate())),
      ],
    );
  }

  void buildContractUsers(Contract contract) {
    contractorWidgets.clear();
    contract.contractors.forEach((contractorId) {
      contractorWidgets.add(contractorDetails(contractorId));
    });
  }

  Widget contractorDetails(String contractorId) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
      child: FutureBuilder<User>(
        future: dataProvider.fetchUserById(contractorId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                contractDetailText("Contractor: ", "${snapshot.data!.name}"),
                SizedBox(height: 2),
                contractDetailText("Email: ", "${snapshot.data!.email}"),
                SizedBox(height: 2),
                contractDetailText("Phone: ", "${snapshot.data!.phone}"),
                SizedBox(height: 2),
                contractDetailText("Country: ", "${snapshot.data!.country}"),
                SizedBox(height: 2),
                contractDetailText("City: ", "${snapshot.data!.city}"),
                SizedBox(height: 2),
                contractDetailText("Address: ", "${snapshot.data!.streetAddress}")
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        }
      )
    );
  }

  Widget contractDetailText(String type, String content) {
    return Row(
      children: [
        Text("$type", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("$content")
      ],
    );
  }

  Widget contractTAC(Contract contract) {
    return contractTermTitle('Terms and Conditions');
  }

  Widget contractTerm(String termId, int index) {
    return Container(
      child: FutureBuilder<Term>(
          future: dataProvider.fetchTermById(termId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder<TermType>(
                future: dataProvider.fetchTermTypeById(snapshot.data!.termTypeId!),
                builder: (context, typeSnapshot) {
                  if (typeSnapshot.hasData) {
                    return Column(
                      children: [
                        contractTermTitle("$index. ${typeSnapshot.data!.name!}"),
                        contractTermText(snapshot.data!.description!),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: Column(
                            children: displayATermsObligations(termId),
                          ),
                        )
                      ],
                    );
                  } else if (typeSnapshot.hasError) {
                    return Center(child: Text('${snapshot.error}'));
                  }
                  return Center(child: CircularProgressIndicator());
                }
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }
            return Center(child: CircularProgressIndicator());
          }
      )
    );
  }

  List<Widget> displayATermsObligations(String termId) {
    List<Widget> widgets = [];
    int index = 0;
    obligations.forEach((element) {
      if(element.termId == termId) {
        widgets.add(obligationInfo(element, index));
        widgets.add(SizedBox(height: 20));
        index++;
      }
    });
    return widgets;
  }

  Widget obligationInfo(Obligation obligation, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Obligation-${index+1}:", style: TextStyle(fontSize: 15)),
        SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Description: ${obligation.description}", textAlign: TextAlign.justify),
            Text("Execution Date: ${obligation.getExecutionDateAsString()}"),
            Text("End Date: ${obligation.getEndDateAsString()}"),
          ]
        )
      ],
    );
  }

  void buildContractTerms(Contract contract) {
    if (contract.terms.isNotEmpty) {
      termWidgets.clear();
      int index = 1;
      contract.terms.forEach((termId) {
        termWidgets.add(contractTerm(termId, index));
        index++;
      });
    }
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

  void _showObligationCompletionDialog(Obligation obligation) {
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
                onPressed: () async {
                  bool updateSuccess = await dataProvider.updateObligationStatus(obligation, "hasFulfilled");
                  if (updateSuccess) {
                    setState(() {
                      obligation.state = "hasFulfilled";
                    });
                  } else {
                    _showObligationUpdateError(obligation);
                  }
                  _dismissDialog();
                },
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

  void _showObligationUpdateError(Obligation obligation) {

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error on completing your obligation.'),
            content: Text('There appears to be an error on completing the obligation with ID: ${obligation.id}'),
            actions: [
              MaterialButton(
                onPressed: () {
                  _dismissDialog();
                },
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Ok'),
              )
            ],
          );
        }
    );
  }

  Tooltip obligationIconByStatus(String status) {
    if (status.compareTo("hasPending") == 0) {
      return Tooltip(
        message: "Obligation is pending.",
          child: Icon(Icons.pending, color: Colors.grey, size: 30));
    } else if (status.compareTo("hasInvalid") == 0) {
      return Tooltip(
          message: "Obligation is invalid.",
          child: Icon(Icons.warning, color: Colors.yellow, size: 30));
    } else if (status.compareTo("hasFulfilled") == 0) {
      return Tooltip(
          message: "Obligation is fulfilled.",
          child: Icon(Icons.check_circle, color: Colors.green, size: 30));
    } else if (status.compareTo("hasValid") == 0) {
      return Tooltip(
          message: "Obligation is valid.",
          child: Icon(Icons.done, color: Colors.grey, size: 30));
    } else {
      return Tooltip(
        message: "Obligation is completed.",
          child: Icon(Icons.check_circle, color: Colors.green, size: 30));
    }
  }

  Tooltip contractIconByStatus(String status) {
    if (status.compareTo("hasCreated") == 0) {
      return Tooltip(
        message: "The contract has recently been created.",
        child: Icon(Icons.new_releases, color: Colors.blue, size: 50));
    } else if (status.compareTo("hasPending") == 0) {
      return Tooltip(
          message: "The contract is still awaiting signatures.",
          child: Icon(Icons.pending, color: Colors.grey, size: 50));
    } else if (status.compareTo("hasSigned") == 0) {
      return Tooltip(
          message: "The contract has been signed by all parties.",
          child: Icon(Icons.thumb_up, color: Colors.blue, size: 50));
    } else if (status.compareTo("hasTerminated") == 0) {
      return Tooltip(
          message: "The contract has been terminated.",
          child: Icon(Icons.do_not_disturb, color: Colors.yellow, size: 50));
    } else if (status.compareTo("hasRenewed") == 0) {
      return Tooltip(
          message: "The contract has been renewed.",
          child: Icon(Icons.history, color: Colors.blue, size: 50));
    } else if (status.compareTo("hasExpired") == 0) {
      return Tooltip(
          message: "The contract has expired.",
          child: Icon(Icons.hourglass_bottom, color: Colors.blue, size: 50));
    } else {
      return Tooltip(
          message: "The contract has recently been created.",
          child: Icon(Icons.new_releases, color: Colors.blue, size: 50));
    }
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
