import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/custom_widgets/reportable_widget.dart';


class ClaimForm extends StatefulWidget {

  final Function(int, [String]) changeScreen;
  final Contract contract;
  final List<Obligation> obligations;

  ClaimForm(this.changeScreen, this.contract, this.obligations);


  @override
  _ClaimFormState createState() => new _ClaimFormState();
}

class _ClaimFormState extends State<ClaimForm> {
  TextEditingController textController = TextEditingController();

  List<ReportableWidget> contractorWidgets = [];
  List<ReportableWidget> termWidgets = [];
  List<ReportableWidget> obligationWidgets = [];
  List<Obligation> obligations = [];
  DataProvider dataProvider = new DataProvider();
  ReportableWidget? startDateWidget;
  ReportableWidget? endDateWidget;
  ReportableWidget? purposeWidget;
  ReportableWidget? considerationWidget;

  bool existsAViolation = false;

  @override
  void initState() {
    super.initState();
    buildContractUsers(widget.contract);
    buildReportableObligations();
    buildContractTerms();
    setWidgets();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    setExistsAViolation();

    return Stack(
        children: [
          Container(
              child: Scrollbar(
                  child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            claimFormBody(screenWidth * (isBigScreen(screenWidth)? 0.8 : 1))
                          ]
                      )
                  )
              )
          ),
        ]
    );
  }

  Widget claimFormBody(double width) {
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
                  child: Text('Contract Violation Form', style: TextStyle(fontSize: 30, decoration: TextDecoration.underline))
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Date of Violation: ${_formatDate(DateTime.now())}'),
                  Text('Contract ID: ${widget.contract.formatContractId()}')
                ],
              ),
              SizedBox(height: 20),
              Center(
                  child: Text('Contract Information', style: TextStyle(fontSize: 20, decoration: TextDecoration.underline))
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contractors:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: contractorWidgets
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(child: startDateWidget),
                  Container(child: endDateWidget),
                ],
              ),
              SizedBox(height: 10),
              Container(child: purposeWidget),
              SizedBox(height: 10),
              Container(child: considerationWidget),
              SizedBox(height: 10),
              Text('Terms and Conditions:', style: TextStyle(fontSize: 20, decoration: TextDecoration.underline)),
              SizedBox(height: 10),
              termWidgets.isNotEmpty
                ? Column(
                children: termWidgets,
                )
                : Center(child: Text("No terms were found in the contract.")),
              SizedBox(height: 20),
              Row(
                children: [
                  cancelViolationButton(),
                  Spacer(),
                  confirmViolationButton()
                ],
              )
            ],
          )
        )
      ),
    );
  }

  void setWidgets() {
    setState(() {
      startDateWidget = ReportableWidget(
          child: Row(
            children: [
              Text("Start Date: ", style: TextStyle(fontWeight: FontWeight.bold)),
              Text('${widget.contract.getFormattedStartDate()}', style: TextStyle(fontSize: 15))
            ],
          ), violationCallback: setExistsAViolation);

      endDateWidget = ReportableWidget(
              child: Row(
                children: [
                  Text("End Date: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${widget.contract.getFormattedEndDate()}', style: TextStyle(fontSize: 15))
                ],
              ), violationCallback: setExistsAViolation);

      purposeWidget = ReportableWidget(
              child: Row(
                children: [
                  Text("Purpose: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.contract.purpose!,style: TextStyle(fontSize: 15), textAlign: TextAlign.justify),
                ],
              ), violationCallback: setExistsAViolation);

      considerationWidget = ReportableWidget(
              child: Row(
                children: [
                  Text("Consideration: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.contract.consideration!,style: TextStyle(fontSize: 15), textAlign: TextAlign.justify),
                ],
              ), violationCallback: setExistsAViolation);
    });
  }

  Widget contractorDetails(String contractorId) {
    return Container(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
        child: FutureBuilder<User>(
            future: dataProvider.fetchUserById(contractorId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('${snapshot.data!.name}');
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            }
        )
    );
  }

  void buildContractUsers(Contract contract) {
    contractorWidgets.clear();
    contract.contractors.forEach((contractorId) {
      contractorWidgets.add(ReportableWidget(child: contractorDetails(contractorId), violationCallback: setExistsAViolation));
    });
  }

  void buildContractTerms() {
    if (widget.contract.terms.isNotEmpty) {
      termWidgets.clear();
      int index = 1;
      widget.contract.terms.forEach((termId) {
        termWidgets.add(contractTerm(termId, index));
        index++;
      });
    }
  }

  ReportableWidget contractTerm(String termId, int index) {
    return ReportableWidget(
        violationCallback: setExistsAViolation,
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
                            displayTermElementInfo(typeSnapshot.data!.name!, snapshot.data!.description!, index),
                            SizedBox(height: 10),
                            Column(
                                children: displayATermsObligations(termId)
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
    return obligationWidgets.where((element) => element.termId!.compareTo(termId) == 0).toList();
  }

  void buildReportableObligations() {
    int index = 0;
    this.widget.obligations.forEach((element) {
      obligationWidgets.add(
        ReportableWidget(
          termId: element.termId,
          violationCallback: setExistsAViolation,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Obligation ${index+1}:", style: TextStyle(fontSize: 15)),
              SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Description: ${element.description}", textAlign: TextAlign.justify),
                  Text("Execution Date: ${element.getExecutionDateAsString()}"),
                  Text("End Date: ${element.getEndDateAsString()}")
                ],
              )
            ],
          )
        )
      );
      index++;
    });
  }

  bool isBigScreen(double width) {
    if (width <= 500) {
      return false;
    } else {
      return true;
    }
  }

  Widget displayTermElementInfo(String name, String description, int termNum) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(child: Text("$termNum. $name", style: TextStyle(fontSize: 20))),
        description.compareTo("") == 0 ?
          Text('None.', textAlign: TextAlign.justify) :
          Align(
              alignment: Alignment.centerLeft,
              child: Text('$description', textAlign: TextAlign.justify)
          )
      ],
    );
  }

  Widget checkBoxElement(String contractElement, String checkBoxTitle, String tooltipMessage, CheckBoxBoolean isChecked) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                  value: isChecked.value,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked.value = value!;
                    });
                  }
              ),
              Container(width: 5),
              Text(checkBoxTitle, style: TextStyle(fontSize: 15)),
              Container(width: 5),
              Tooltip(
                textStyle: TextStyle(fontSize: 16, color: Colors.white, fontStyle: FontStyle.italic),
                message: tooltipMessage,
                child: CircleAvatar(
                  child: Text('?', style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.grey,
                  radius: 10,
                ),
              ),
              Spacer()
            ],
          ),
        ],
      ),
    );
  }

  Widget checkBoxElementEdit(String contractElement, String checkBoxTitle, String tooltipMessage, CheckBoxBooleanEdit isChecked) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                  value: isChecked.value,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked.value = value!;
                    });
                  }
              ),
              Container(width: 5),
              Text(checkBoxTitle, style: TextStyle(fontSize: 15)),
              Container(width: 5),
              Tooltip(
                textStyle: TextStyle(fontSize: 16, color: Colors.white, fontStyle: FontStyle.italic),
                message: tooltipMessage,
                child: CircleAvatar(
                  child: Text('?', style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.grey,
                  radius: 10,
                ),
              ),
              Spacer()
            ],
          ),
          isChecked.value == true?
          Container(
              height: 100,
              color: Colors.white54,
              child: TextField(
                controller: textController,
                maxLines: null,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  hintText: ("Please enter the $checkBoxTitle details here..."),
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      borderSide: BorderSide(
                          color: Colors.blue
                      )
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0
                      )
                  ),
                ),
              )) : Container()
        ],
      ),
    );
  }

  MaterialButton cancelViolationButton() {
    return MaterialButton(
      color: Colors.grey,
      onPressed: () => widget.changeScreen(2, widget.contract.id!),
      child: Text('CANCEL', style: TextStyle(fontSize: 40, color: Colors.white)),
    );
  }

  MaterialButton confirmViolationButton() {
    return existsAViolation
        ? MaterialButton(
            color: Colors.green,
            onPressed: () async {
              widget.contract.status = "stateViolated";
              print("new contract status is: ${widget.contract.status}");
              await dataProvider.updateContract(widget.contract);
              widget.changeScreen(2, widget.contract.id!);
            },
            child: Text('CONFIRM', style: TextStyle(fontSize: 40, color: Colors.white)))
        : MaterialButton(
            color: Colors.grey,
            onPressed: () => null,
            child: Text('CONFIRM', style: TextStyle(fontSize: 40, color: Colors.white)));
  }

  void setExistsAViolation() {
    setState(() {
      existsAViolation = false;
      for (int i = 0; i < contractorWidgets.length; i++) {
        if (contractorWidgets[i].isAViolation == true) { existsAViolation = true; }
      }
      for (int i = 0; i < termWidgets.length; i++) {
        if (termWidgets[i].isAViolation == true) { existsAViolation = true; }
      }
      for (int i = 0; i < obligationWidgets.length; i++) {
        if (obligationWidgets[i].isAViolation == true) { existsAViolation = true; }
      }
      if (startDateWidget!.isAViolation == true || endDateWidget!.isAViolation == true
          || purposeWidget!.isAViolation == true || considerationWidget!.isAViolation == true) {
        existsAViolation = true;
      }
    });
  }

  String _formatDate(DateTime? date) {
    String dateString = "${date!.day}.${date.month}.${date.year}";
    return dateString;
  }
}

class CheckBoxBoolean {
  bool value = true;
}

class CheckBoxBooleanEdit {
  bool value = false;
}