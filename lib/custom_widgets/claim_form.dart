import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/custom_widgets/reportable_widget.dart';


class ClaimForm extends StatefulWidget {

  final Function(int) changeScreen;
  final Contract contract;

  ClaimForm(this.changeScreen, this.contract);


  @override
  _ClaimFormState createState() => new _ClaimFormState();
}

class _ClaimFormState extends State<ClaimForm> {
  TextEditingController textController = TextEditingController();
  TextEditingController conditionController = TextEditingController();

  CheckBoxBoolean isAmendment = CheckBoxBoolean();
  CheckBoxBoolean isConfidentialObligation = CheckBoxBoolean();
  CheckBoxBoolean isDataController = CheckBoxBoolean();
  CheckBoxBoolean isDataProtection = CheckBoxBoolean();
  CheckBoxBoolean isLimitationOnUse = CheckBoxBoolean();
  CheckBoxBoolean isMethodOfNotice = CheckBoxBoolean();
  CheckBoxBoolean isNoThirdPartyBeneficiaries = CheckBoxBoolean();
  CheckBoxBoolean isPermittedDisclosure = CheckBoxBoolean();
  CheckBoxBoolean isReceiptOfNotice = CheckBoxBoolean();
  CheckBoxBoolean isSeverability = CheckBoxBoolean();
  CheckBoxBoolean isTerminationForInsolvency = CheckBoxBoolean();
  CheckBoxBoolean isTerminationForMaterialBreach = CheckBoxBoolean();
  CheckBoxBoolean isTerminationOnNotice = CheckBoxBoolean();
  CheckBoxBoolean isWaiver = CheckBoxBoolean();

  CheckBoxBooleanEdit isAmendment2 = CheckBoxBooleanEdit();
  CheckBoxBooleanEdit isConfidentialObligation2 = CheckBoxBooleanEdit();
  CheckBoxBooleanEdit isDataController2 = CheckBoxBooleanEdit();
  CheckBoxBooleanEdit isDataProtection2 = CheckBoxBooleanEdit();
  CheckBoxBooleanEdit isLimitationOnUse2 = CheckBoxBooleanEdit();
  CheckBoxBooleanEdit isMethodOfNotice2 = CheckBoxBooleanEdit();
  CheckBoxBooleanEdit isNoThirdPartyBeneficiaries2 = CheckBoxBooleanEdit();
  CheckBoxBooleanEdit isPermittedDisclosure2 = CheckBoxBooleanEdit();
  CheckBoxBooleanEdit isReceiptOfNotice2 = CheckBoxBooleanEdit();
  CheckBoxBooleanEdit isSeverability2 = CheckBoxBooleanEdit();
  CheckBoxBooleanEdit isTerminationForInsolvency2 = CheckBoxBooleanEdit();
  CheckBoxBooleanEdit isTerminationForMaterialBreach2 = CheckBoxBooleanEdit();
  CheckBoxBooleanEdit isTerminationOnNotice2 = CheckBoxBooleanEdit();
  CheckBoxBooleanEdit isWaiver2 = CheckBoxBooleanEdit();

  List<Widget> termWidgets = [];
  DataProvider dataProvider = new DataProvider();

  @override
  void initState() {
    super.initState();
    conditionController.text = widget.contract.purpose!;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
    buildContractTerms();
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
              Container(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Date of Violation: ${_formatDate(DateTime.now())}'),
                  Text('Contract ID: ${widget.contract.formatContractId()}')
                ],
              ),
              Container(height: 20),
              Center(
                  child: Text('Contract Information', style: TextStyle(fontSize: 25))
              ),
              Container(height: 20),
              Row(
                children: [
                  Text('Involved Parties:', style: TextStyle(fontSize: 15)),
                  Spacer(flex: 2),
                  Text(widget.contract.getContractorName(), style: TextStyle(fontSize: 15)),
                  Spacer(flex: 1),
                  Text(widget.contract.getContractorName(), style: TextStyle(fontSize: 15)),
                  Spacer(flex: 2),
                ],
              ),
              Container(height: 20),
              Row(
                children: [
                  Text('Start Date: ${widget.contract.getFormattedStartDate()}', style: TextStyle(fontSize: 15)),
                  Spacer(flex: 1),
                  Text('End Date: ${widget.contract.getFormattedEndDate()}', style: TextStyle(fontSize: 15)),
                  Spacer(flex: 1)
                ],
              ),
              Container(height: 20),
              Text('Contract Terms & Conditions:', style: TextStyle(fontSize: 20)),
              Container(height: 10),
              //TODO: adjust to new contract form.
              ReportableWidget(child: Text(widget.contract.purpose!, style: TextStyle(fontSize: 15), textAlign: TextAlign.justify)),
              Column(
                children: termWidgets,
              ),
              Container(height: 20),
              Container(height: 50),
              Container(height: 50,
              child: TextFormField(
                textAlign: TextAlign.justify,
                controller: conditionController,
              )),
              Container(height: 20),
              Container(height: 50),
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

  void buildContractTerms() {
    widget.contract.terms.forEach((termId) {
      termWidgets.add(ReportableWidget(
        child: FutureBuilder<Term>(
            future: dataProvider.fetchTermById(termId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return displayTermElementInfo(snapshot.data!.name!, snapshot.data!.description!);
              } else if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              }
              return Center(child: CircularProgressIndicator());
            }
        )
      ));
    });
  }

  bool isBigScreen(double width) {
    if (width <= 500) {
      return false;
    } else {
      return true;
    }
  }

  Widget displayTermElementInfo(String name, String description) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(child: Text(name, style: TextStyle(fontSize: 20))),
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
      onPressed: () => widget.changeScreen(0),
      child: Text('CANCEL', style: TextStyle(fontSize: 40, color: Colors.white)),
    );
  }

  MaterialButton confirmViolationButton() {
    return MaterialButton(
      color: Colors.green,
      onPressed: () => widget.changeScreen(0),
      child: Text('CONFIRM', style: TextStyle(fontSize: 40, color: Colors.white)),
    );
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