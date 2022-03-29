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
                      child: Text('Contract Update Form', style: TextStyle(fontSize: 30, decoration: TextDecoration.underline))
                  ),
                  SizedBox(height: 10),
                  contractDetailsBlock(),
                  SizedBox(height: 5),
                  contractContractorBlock("C001"),
                  SizedBox(height: 5),
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
                child: Text('Contract Details', style: TextStyle(fontSize: 20)),
            ),
            Text('Contract ID: ${widget.contract.contractId}'),
            Text('Contract Type: ${widget.contract.getContractType()}')
          ],
        ),
      ),
    );
  }

  Widget contractContractorBlock(String contractorId) {
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
        color: Colors.white,
        hoverColor: Colors.blue,
        onPressed: () { widget.toggleEditing(4); },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text('Terms & Conditions', style: TextStyle(fontSize: 25)),
            ),
            Text(widget.contract.purpose!, style: TextStyle(fontSize: 15), textAlign: TextAlign.justify),
            Container(height: 20),
            Column(
              children: termWidgets
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Start Date: ${_formatDate(widget.contract.executionDate!)}'),
                Text('End Date: ${_formatDate(widget.contract.endDate!)}')
              ],
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
                            child: Text('Contractor: ${snapshot.data!.name!}')
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

  void buildContractTerms() {
    termWidgets.clear();
    widget.contract.terms.forEach((termId) {
      termWidgets.add(Container(
        child: FutureBuilder<Term>(
            future: dataProvider.fetchTermById(termId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return termElement(snapshot.data!.name!, snapshot.data!.description!);
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