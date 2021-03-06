import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import 'package:smashhit_ui/data/models.dart';

class UpdateForm extends StatefulWidget {
  final Function (int) changeScreen;
  final Function(int) toggleEditing;
  final Contract contract;

  UpdateForm(this.changeScreen, this.toggleEditing, this.contract);

  @override
  _UpdateFormState createState() => new _UpdateFormState();


}

class _UpdateFormState extends State<UpdateForm> {

  List<Widget> termWidgets = [];
  List<Widget> contractorWidgets = [];
  DataProvider dataProvider = new DataProvider();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double formWidth = screenWidth * (_isWideScreen(screenWidth, screenHeight)? 0.7 : 1);

    return Stack(
        children: [
          Container(
            alignment: Alignment.center,
              child: Scrollbar(
                  child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            updateFormBody(formWidth)
                          ]
                      )
                  )
              )
          ),
          Align(
            child: submitChangesButton(),
            alignment: Alignment.bottomRight,
          )
        ]
    );
  }

  Widget updateFormBody(double width) {
    return Container(
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black45,
                blurRadius: 25.0,
                spreadRadius: 5.0,
                offset: Offset(10.0, 10.0))
          ]),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Scrollbar(
          child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                      child: Text('Contract Update Form', style: TextStyle(fontSize: 25, decoration: TextDecoration.underline))
                  ),
                  SizedBox(height: 10),
                  contractDetailsBlock(),
                  SizedBox(height: 10),
                  contractContractorBlock(),
                  SizedBox(height: 10),
                  contractTACBlock(),
                  SizedBox(height: 20),
                ],
              )
          )
      ),
    );
  }

  Widget contractDetailsBlock() {
    return Tooltip(
      message: 'Tap to edit contract details.',
      child: MaterialButton(
        color: Colors.white,
        hoverColor: Colors.blue,
        onPressed: () { widget.toggleEditing(1); },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                    child: Text('Contract Details', style: TextStyle(fontSize: 20))),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                child: Text('Contract ID: ${widget.contract.contractId}')),
            Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5 , 5),
                child: Text('Contract Type: ${widget.contract.getContractType()}')),
            Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5 , 5),
                child: Text('Contract Medium: ${widget.contract.medium}')),
            Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5 , 5),
                child: Text('Contract Category: ${widget.contract.contractCategory}')),
            Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5 , 5),
                child: Text('Purpose: ${widget.contract.purpose}')),
            Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                child: Text('Consideration: ${widget.contract.considerationDescription}')),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Start Date: ${_formatDate(widget.contract.executionDate!)}'),
                  Text('End Date: ${_formatDate(widget.contract.endDate!)}')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget contractContractorBlock() {
    buildContractContractors();
    return Column(
      children: contractorWidgets,
    );
  }

  Widget contractRequesterBlock() {
    return Tooltip(
      message: 'Tap to edit data controller information',
      child: MaterialButton(
        color: Colors.white,
        hoverColor: Colors.blue,
        onPressed: () { widget.toggleEditing(2); },
        child: Row(
          children: [
            Center(child: Text('Data Controller(s): ', style: TextStyle(fontSize: 15))),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.contract.getContractorName(), style: TextStyle(fontSize: 15))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget contractProviderBlock() {
    return Tooltip(
      message: 'Tap to edit data processor information',
      child: MaterialButton(
        color: Colors.white,
        hoverColor: Colors.blue,
        onPressed: () { widget.toggleEditing(3); },
        child: Row(
          children: [
            Center(child: Text('Data Processor(s): ', style: TextStyle(fontSize: 15))),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.contract.getContracteeName(), style: TextStyle(fontSize: 15))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget contractTACBlock() {
    buildContractTerms();
    return Tooltip(
      message: 'Tap to edit the terms & conditions',
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        color: Colors.white,
        hoverColor: Colors.blue,
        onPressed: () { widget.toggleEditing(4); },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text('Terms & Conditions', style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 10),
            Column(
              children: termWidgets
            ),
          ],
        ),
      ),
    );
  }

  void buildContractContractors() {
    contractorWidgets.clear();
    widget.contract.contractors.forEach((contractorId) {
      contractorWidgets.add(Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: FutureBuilder<User> (
          future: dataProvider.fetchUserById(contractorId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Tooltip(
                message: 'Tap to edit contractor information',
                child: MaterialButton(
                    color: Colors.white,
                    hoverColor: Colors.blue,
                    onPressed: () { widget.toggleEditing(2); },
                    child: Center(
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
                              child: Column(
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
                              ),
                            )
                        )
                    )
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return Center(child: CircularProgressIndicator());
          },
        )
      ));
    });
  }

  Widget contractDetailText(String type, String content) {
    return Row(
      children: [
        Text("$type", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("$content")
      ],
    );
  }

  void buildContractTerms() {
    termWidgets.clear();
    widget.contract.terms.forEach((termId) {
      termWidgets.add(Container(
        child: FutureBuilder<Term>(
            future: dataProvider.fetchTermById(termId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return FutureBuilder<TermType>(
                    future: dataProvider.fetchTermTypeById(snapshot.data!.termTypeId!),
                    builder: (context, typeSnapshot) {
                      if (typeSnapshot.hasData) {
                        return termElement(typeSnapshot.data!.name!, snapshot.data!.description!);
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
      ));
    });
  }

  Widget termElement(String term, String termValue) {
    if (termValue == "") {
      setState(() {
        termValue = "None";
      });
    }
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text(term, style: TextStyle(fontSize: 20))),
          Text(termValue, style: TextStyle(fontSize: 15), textAlign: TextAlign.justify)
        ],
      ),
    );
  }

  Widget submitChangesButton() {
    return Container(
        width: 150,
        height: 50,
        child: MaterialButton(
            color: Colors.grey,
            hoverColor: Colors.blueGrey,
            child: Text("Submit Changes", style: TextStyle(color: Colors.white)),
            onPressed: () {
              print("not implemented yet.");
            }
        )
    );
  }

  bool _isWideScreen(double width, double height) {
    if (width < height) {
      return false;
    } else {
      return true;
    }
  }

  String _formatDate(DateTime dateTime) {
    String dateString = '${dateTime.day}.${dateTime.month}.${dateTime.year}';
    return dateString;
  }
}