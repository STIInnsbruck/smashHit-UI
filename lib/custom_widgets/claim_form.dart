import 'package:flutter/material.dart';
import 'package:smashhit_ui/misc/legal_term_texts.dart';
import 'package:smashhit_ui/data/models.dart';


class ClaimForm extends StatefulWidget {

  Function(int) changeScreen;
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

  @override
  void initState() {
    super.initState();
    conditionController.text = widget.contract.description!;
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
                            claimFormBody(screenWidth * 0.5)
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
              Container(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Date of Violation: ${_formatDate(DateTime.now())}'),
                  Text('Contract ID: ${widget.contract.contractId}')
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
                  Text(widget.contract.contractor!, style: TextStyle(fontSize: 15)),
                  Spacer(flex: 1),
                  Text(widget.contract.contractee!, style: TextStyle(fontSize: 15)),
                  Spacer(flex: 2),
                ],
              ),
              Container(height: 20),
              Row(
                children: [
                  Text('Contract Dates:', style: TextStyle(fontSize: 15)),
                  Spacer(),
                  Text('Start Date: ${widget.contract.executionDate}', style: TextStyle(fontSize: 15)),
                  Container(width: 20),
                  Text('End Date: ${widget.contract.expireDate}', style: TextStyle(fontSize: 15)),
                ],
              ),
              Container(height: 20),
              Text('Contract Terms & Conditions:', style: TextStyle(fontSize: 20)),
              Container(height: 10),
              Text(widget.contract.description!, style: TextStyle(fontSize: 15), textAlign: TextAlign.justify),
              Container(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  checkBoxElement('Amendment', 'Has an amendment', AMENDMENT, isAmendment),
                  checkBoxElement('ConfidentialityObligation', 'Is there a confidentiality obligation?', CONFIDENTIALITY_OBLIGATION, isConfidentialObligation),
                  checkBoxElement('DataController', 'Is there a data controller?', DATA_CONTROLLER, isDataController),
                  checkBoxElement('DataProtection', 'Does the contract contain data protection?', DATA_PROTECTION, isDataProtection),
                  checkBoxElement('LimitationOnUse', 'Is there a limitation on use?', LIMITATION_ON_USE, isLimitationOnUse),
                  checkBoxElement('MethodOfNotice', 'Has method of notice?', METHOD_OF_NOTICE, isMethodOfNotice),
                  checkBoxElement('NoThirdPartyBeneficiaries', 'Are there third party beneficiaries?', NO_THIRD_PARTY_BENEFICIARIES, isNoThirdPartyBeneficiaries),
                  checkBoxElement('PermittedDisclosure', 'Is there a permitted disclosure?', PERMITTED_DISCLOSURE, isPermittedDisclosure),
                  checkBoxElement('ReceiptOfNotice', 'Is there a receipt of notice?', RECEIPT_OF_NOTICE, isReceiptOfNotice),
                  checkBoxElement('Severability', 'Is there a severability?', SEVERABILITY, isSeverability),
                  checkBoxElement('TerminationForInsolvency', 'Is there a termination for insolvency?', TERMINATION_FOR_INSOLVENCY, isTerminationForInsolvency),
                  checkBoxElement('TerminationForMaterialBreach', 'Is there a termination for material breach?', TERMINATION_FOR_MATERIAL_BREACH, isTerminationForMaterialBreach),
                  checkBoxElement('TerminationOnNotice', 'Is there a termination on notice?', TERMINATION_ON_NOTICE, isTerminationOnNotice),
                  checkBoxElement('Waiver', 'Waiver', WAIVER, isWaiver),
                ],
              ),
              Container(height: 50),
              Container(height: 50,
              child: TextFormField(
                textAlign: TextAlign.justify,
                controller: conditionController,
              )),
              Container(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  checkBoxElementEdit('Amendment', 'Has an amendment', AMENDMENT, isAmendment2),
                  checkBoxElementEdit('ConfidentialityObligation', 'Is there a confidentiality obligation?', CONFIDENTIALITY_OBLIGATION, isConfidentialObligation2),
                  checkBoxElementEdit('DataController', 'Is there a data controller?', DATA_CONTROLLER, isDataController2),
                  checkBoxElementEdit('DataProtection', 'Does the contract contain data protection?', DATA_PROTECTION, isDataProtection2),
                  checkBoxElementEdit('LimitationOnUse', 'Is there a limitation on use?', LIMITATION_ON_USE, isLimitationOnUse2),
                  checkBoxElementEdit('MethodOfNotice', 'Has method of notice?', METHOD_OF_NOTICE, isMethodOfNotice2),
                  checkBoxElementEdit('NoThirdPartyBeneficiaries', 'Are there third party beneficiaries?', NO_THIRD_PARTY_BENEFICIARIES, isNoThirdPartyBeneficiaries2),
                  checkBoxElementEdit('PermittedDisclosure', 'Is there a permitted disclosure?', PERMITTED_DISCLOSURE, isPermittedDisclosure2),
                  checkBoxElementEdit('ReceiptOfNotice', 'Is there a receipt of notice?', RECEIPT_OF_NOTICE, isReceiptOfNotice2),
                  checkBoxElementEdit('Severability', 'Is there a severability?', SEVERABILITY, isSeverability2),
                  checkBoxElementEdit('TerminationForInsolvency', 'Is there a termination for insolvency?', TERMINATION_FOR_INSOLVENCY, isTerminationForInsolvency2),
                  checkBoxElementEdit('TerminationForMaterialBreach', 'Is there a termination for material breach?', TERMINATION_FOR_MATERIAL_BREACH, isTerminationForMaterialBreach2),
                  checkBoxElementEdit('TerminationOnNotice', 'Is there a termination on notice?', TERMINATION_ON_NOTICE, isTerminationOnNotice2),
                  checkBoxElementEdit('Waiver', 'Waiver', WAIVER, isWaiver2),
                ],
              ),
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