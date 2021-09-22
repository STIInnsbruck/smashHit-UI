import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smashhit_ui/misc/legal_term_texts.dart';
import 'package:smashhit_ui/data/models.dart';

enum ContractType { Written, Mutual, Verbal, Transferable}

class ContractForm extends StatefulWidget {

  DateTime? startDate;
  DateTime? endDate;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController requesterController = TextEditingController();
  List<TextEditingController> providerControllers = [];
  String? contractDropDownType;


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

  ContractType? _type;

  bool toggleStepOne = true;
  bool toggleStepTwo = false;
  bool toggleStepThree = false;

  List<User> providers = [];

  @override
  void initState() {
    super.initState();
    widget.providerControllers.add(TextEditingController());
    providers.add(User("Secondary"));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              contractStep1Header(screenWidth * 0.5),
              toggleStepOne == true? contractStep1(screenWidth * 0.5) : Container(),
              contractStep2Header(screenWidth * 0.5),
              contractStep3Header(screenWidth * 0.5),
              Align(
                alignment: Alignment.centerRight,
                child: nextStepButton(),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: previousStepButton(),
              )
            ]
          )
        )
      )
    );
  }

  Widget contractStep1Header(double width) {
    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: Colors.grey,
          boxShadow: [
            BoxShadow(
                color: Colors.black45,
                blurRadius: 25.0,
                spreadRadius: 5.0,
                offset: Offset(10.0, 10.0))
          ]),
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Align(
          child: Text("Contract Base Information", style: TextStyle(fontSize: 30, color: Colors.white)),
          alignment: Alignment.centerLeft),
    );
  }

  Widget contractStep2Header(double width) {
    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: Colors.grey,
          boxShadow: [
            BoxShadow(
                color: Colors.black45,
                blurRadius: 25.0,
                spreadRadius: 5.0,
                offset: Offset(10.0, 10.0))
          ]),
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Align(
          child: Text("Fill in Contract Party Details", style: TextStyle(fontSize: 30, color: Colors.white)),
          alignment: Alignment.centerLeft),
    );
  }

  Widget contractStep3Header(double width) {
    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: Colors.grey,
          boxShadow: [
            BoxShadow(
                color: Colors.black45,
                blurRadius: 25.0,
                spreadRadius: 5.0,
                offset: Offset(10.0, 10.0))
          ]),
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Align(
          child: Text("Terms and Conditions of the Contract", style: TextStyle(fontSize: 30, color: Colors.white)),
          alignment: Alignment.centerLeft),
    );
  }

  /// The contract creation is done primarily in 3 steps. This is the first step
  /// block. In the first step only the title, date and medium and contract
  /// type are required to be entered by the user.
  Widget contractStep1(double width) {
    return Container(
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
      width: width,
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              titleField(),
              Container(height: 10),
              //contractTypeMenu(),
              contractTypeRadioMenu(),
              Container(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      startDate == null ? Container() : Text("Chosen Start Date:"),
                      startDateButton(),
                    ],
                  ),
                  Column(
                    children: [
                      endDate == null ? Container() : Text("Chosen End Date:"),
                      endDateButton(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget contractTypeMenu() {
    return Row(
      children: [
        Text("What type of contract is being formed?", style: TextStyle(fontSize: 20)),
        Spacer(flex: 1),
        DropdownButton(
          value: widget.contractDropDownType,
          icon: const Icon(Icons.arrow_drop_down),
          hint: Text("Pick a contract type", style: TextStyle(fontSize: 20)),
          onChanged: (String? newValue) {
            setState(() {
              widget.contractDropDownType = newValue;
            });
          },
          elevation: 16,
          style: const TextStyle(color: Colors.black),
          underline: Container(
            height: 2,
            color: Colors.white,
          ),
          items: <String>[
            'Written Contract',
            'Verbal Contract',
            'Mutual Contract',
            'Transferable Contract'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(fontSize: 20)),
            );
          }).toList(),
        ),
        Spacer(flex: 3)
      ],
    );
  }

  Widget contractTypeRadioMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("What type of contract is being formed?", style: TextStyle(fontSize: 20)),
        ListTile(
          title: Text("Written Contract", style: TextStyle(fontSize: 15, color: Colors.black)),
          leading: Radio(
            value: ContractType.Written,
            groupValue: _type,
            onChanged: (ContractType? value) {
              setState(() {
                _type = value;
              });})),
        ListTile(
          title: Text("Verbal Contract", style: TextStyle(fontSize: 15, color: Colors.black)),
            leading: Radio(
                value: ContractType.Verbal,
                groupValue: _type,
                onChanged: (ContractType? value) {
                  setState(() {
                    _type = value;
                  });})
        ),
        ListTile(
            title: Text("Mutual Contract", style: TextStyle(fontSize: 15, color: Colors.black)),
            leading: Radio(
                value: ContractType.Mutual,
                groupValue: _type,
                onChanged: (ContractType? value) {
                  setState(() {
                    _type = value;
                  });})
        ),
        ListTile(
            title: Text("Transferable Contract", style: TextStyle(fontSize: 15, color: Colors.black)),
            leading: Radio(
                value: ContractType.Transferable,
                groupValue: _type,
                onChanged: (ContractType? value) {
                  setState(() {
                    _type = value;
                  });})
        ),
      ],
    );
  }

  Widget titleField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("What is the title of your contract?", style: TextStyle(fontSize: 20)),
        Container(height: 5),
        TextFormField(
          decoration: InputDecoration(
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
          style: TextStyle(fontSize: 20),
          controller: widget.titleController,
        )
      ],
    );
  }

  Widget providerField(TextEditingController textController) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("What is the name of the contract provider?", style: TextStyle(fontSize: 20)),
        Container(height: 5),
        TextFormField(
          decoration: InputDecoration(
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
          style: TextStyle(fontSize: 20),
          controller: textController,
        )
      ],
    );
  }

  Widget requesterField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("What is the name of the contract requester?", style: TextStyle(fontSize: 20)),
        Container(height: 5),
        TextFormField(
          decoration: InputDecoration(
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
          style: TextStyle(fontSize: 20),
          controller: widget.requesterController,
        )
      ],
    );
  }

  Widget _addPartyButton() {
    return GestureDetector(
      child: Row(
        children: [
          Icon(Icons.add_circle_outline, size: 40),
          Text("Click to add another contract provider", style: TextStyle(color: Colors.black, fontSize: 10)),
        ],
      ),
      onTap: () {
        setState(() {
          widget.providerControllers.add(TextEditingController());
        });
      },
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

  Widget startDateButton() {
    return Container(
      width: 160,
      height: 50,
      child: MaterialButton(
        color: Colors.blue,
        hoverColor: Colors.lightBlueAccent,
        child: startDate == null ? Text("Pick a Start Date", style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center)
                : Text(_formatDate(startDate), style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center),
        onPressed: () => chooseStartDate(),
      ),
    );
  }

  Widget endDateButton() {
    return Container(
      width: 160,
      height: 50,
      child: MaterialButton(
        color: Colors.blue,
        hoverColor: Colors.lightBlueAccent,
        child: endDate == null ? Text("Pick an End Date", style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center)
            : Text(_formatDate(endDate), style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center),
        onPressed: () => chooseEndDate(),
      ),
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

  Widget nextStepButton() {
    return Container(
      width: 150,
      height: 50,
      child: MaterialButton(
        color: Colors.green,
        hoverColor: Colors.lightGreen,
        child: Text("Next Step", style: TextStyle(color: Colors.white, fontSize: 30)),
        onPressed: () {
          setState(() {
            if(toggleStepOne == true) {
              toggleStepOne = false;
              toggleStepTwo = true;
              toggleStepThree = false;
            } else if(toggleStepTwo == true) {
              toggleStepOne = false;
              toggleStepTwo = false;
              toggleStepThree = true;
            }
          });
        },
      )
    );
  }

  Widget previousStepButton() {
    return Container(
        width: 150,
        height: 50,
        child: MaterialButton(
          color: Colors.grey,
          hoverColor: Colors.blueGrey,
          child: Text("Previous Step", style: TextStyle(color: Colors.white, fontSize: 30)),
          onPressed: () {
            setState(() {
              if(toggleStepOne == true) {
                toggleStepOne = true;
                toggleStepTwo = false;
                toggleStepThree = false;
              } else if(toggleStepTwo == true) {
                toggleStepOne = true;
                toggleStepTwo = false;
                toggleStepThree = false;
              } else if(toggleStepThree == true) {
                toggleStepOne = false;
                toggleStepTwo = true;
                toggleStepThree = false;
              }
            });
          },
        )
    );
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
