import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smashhit_ui/misc/legal_term_texts.dart';

class ContractForm extends StatefulWidget {

  DateTime? startDate;
  DateTime? endDate;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  _ContractFormState createState() => new _ContractFormState();
}

class _ContractFormState extends State<ContractForm> {
  DateTime? startDate;
  DateTime? endDate;

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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black45,
                blurRadius: 25.0,
                spreadRadius: 5.0,
                offset: Offset(10.0, 10.0))
          ]),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      width: screenWidth * 0.50,
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              titleField(),
              Container(height: 20),
              descriptionField(),
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
              timeFrameField()
            ],
          ),
        ),
      ),
    );
  }

  Widget titleField() {
    return Row(
      children: [
        Text("Title: ", style: TextStyle(fontSize: 25)),
        Expanded(
          child: TextFormField(
              style: TextStyle(fontSize: 20),
              controller: widget.titleController,
          ),
        )
      ],
    );
  }

  Widget descriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Contract Terms: ", style: TextStyle(fontSize: 25)),
        Container(
          height: 400,
          color: Colors.white54,
          child: TextField(
            controller: widget.descriptionController,
            maxLines: null,
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
              hintText: "Enter contract details here...",
            ),
          ),
        ),
      ],
    );
  }

  /// Check Box for the contractForm. If checked then the value is TRUE.
  /// [contractElement] is set by the Developer as this value is used for the
  /// actual structure of a contract in the knowledge graph.
  /// [checkBoxTitle] is then used on what text is displayed for the end-user
  /// in the contractForm.
  /// [tooltipMessage] is the message (from wikipedia) to be displayed to
  /// explain the checkbox meaning.
  /// [isChecked] is the boolean variable that is to be attached to this
  /// checkbox.
  Widget checkBoxElement(String contractElement, String checkBoxTitle, String tooltipMessage, CheckBoxBoolean isChecked) {
    return Container(
      child: Row(
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
            textStyle: TextStyle(fontSize: 14, color: Colors.white, fontStyle: FontStyle.italic),
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
    );
  }

  /// CURRENTLY NOT IN USE!
  Widget addContractElementButton() {
    return MaterialButton(
      child: Column(
        children: [
          Icon(Icons.add_circle_outline, size: 40),
          Text("Add Contract Element", style: TextStyle(color: Colors.black, fontSize: 10))
        ],
      ),
      onPressed: () {
        print("Add Contract Element - Pressed.");
      },
    );
  }

  Widget timeFrameField() {
    return Column(
      children: [
        Row(
          children: [
            Text("Start date: ", style: TextStyle(fontSize: 15)),
            startDate == null
                ? IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => chooseStartDate())
                : Expanded(
                    child: Row(
                    children: [
                      Text(_formatDate(startDate)),
                      IconButton(
                          icon: Icon(Icons.edit),
                          iconSize: 20,
                          onPressed: () => chooseStartDate())
                    ],
                  )),
            Spacer(),
            Text("End date: ", style: TextStyle(fontSize: 15)),
            endDate == null
                ? IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => chooseEndDate())
                : Expanded(
                    child: Row(
                    children: [
                      Text(_formatDate(endDate)),
                      IconButton(
                          icon: Icon(Icons.edit),
                          iconSize: 20,
                          onPressed: () => chooseEndDate())
                    ],
                  )),
          ],
        )
      ],
    );
  }

  Future<void> chooseStartDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050, 1, 1),
    );
    if (pickedDate != null && endDate == null) {
      setState(() {
        startDate = pickedDate;
        setWidgetStartDate();
      });
    } else if (pickedDate != null &&
        endDate != null &&
        pickedDate.isBefore(endDate!)) {
      setState(() {
        startDate = pickedDate;
        setWidgetStartDate();
      });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text(
                  "Please select a start date that is before the selected end date."),
              children: <Widget>[
                TextButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  Future<void> chooseEndDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050, 1, 1),
    );
    if (pickedDate != null &&
        startDate != null &&
        pickedDate.isAfter(startDate!)) {
      setState(() {
        endDate = pickedDate;
        setWidgetEndDate();
      });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text(
                  "Please select a start date first and be sure that the end date is after the start date."),
              children: <Widget>[
                TextButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  ///Function to nicely display the date in the contract form.
  String _formatDate(DateTime? date) {
    String dateString = "${date!.day}.${date.month}.${date.year}";
    return dateString;
  }

  void setWidgetStartDate() {
    widget.startDate = startDate;
  }

  void setWidgetEndDate() {
    widget.endDate = endDate;
  }

}

class CheckBoxBoolean {
  bool value = false;
}
