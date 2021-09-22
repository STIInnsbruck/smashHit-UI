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
  bool toggleRequester = true;
  bool toggleProvider = false;

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

    return Stack(
      children: [
        Container(
            child: Scrollbar(
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          contractStep1Header(screenWidth * 0.5),
                          toggleStepOne == true? contractStep1(screenWidth * 0.5) : Container(),
                          contractStep2Header(screenWidth * 0.5),
                          toggleStepTwo == true? contractStep2(screenWidth * 0.5) : Container(),
                          contractStep3Header(screenWidth * 0.5),
                          toggleStepThree == true? contractStep3(screenWidth * 0.5) : Container(),
                        ]
                    )
                )
            )
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: nextStepButton(),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: previousStepButton(),
        )
      ]
    );
  }

  //------------------ STEP HEADERS --------------------------------------------
  Widget contractStep1Header(double width) {
    return MaterialButton(
      child: Container(
        width: width,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
            color: toggleStepOne == true? Colors.grey : Colors.green,
            boxShadow: [
              BoxShadow(
                  color: Colors.black45,
                  blurRadius: 25.0,
                  spreadRadius: 5.0,
                  offset: Offset(10.0, 10.0))
            ]),
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Align(
            child: Row(
              children: [
                Text("Contract Base Information", style: TextStyle(fontSize: 30, color: Colors.white)),
                Container(width: 10),
                toggleStepOne == true?
                    Container() :
                    Icon(Icons.check, color: Colors.white, size: 30)
              ],
            ),
            alignment: Alignment.centerLeft),
      ),
      onPressed: () => setStepOne()
    );
  }

  Widget contractStep2Header(double width) {
    return MaterialButton(
      child: Container(
        width: width,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
            color: toggleStepOne == false && toggleStepTwo == false ? Colors.green : Colors.grey,
            boxShadow: [
              BoxShadow(
                  color: Colors.black45,
                  blurRadius: 25.0,
                  spreadRadius: 5.0,
                  offset: Offset(10.0, 10.0))
            ]),
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Align(
            child: Row(
              children: [
                Text("Fill in Contract Party Details", style: TextStyle(fontSize: 30, color: Colors.white)),
                Container(width: 10),
                toggleStepOne == false && toggleStepTwo == false?
                Icon(Icons.check, color: Colors.white, size: 30) :
                Container()
              ],
            ),
            alignment: Alignment.centerLeft),
      ),
      onPressed: () => setStepTwo()
    );
  }

  Widget contractStep3Header(double width) {
    return MaterialButton(
      child: Container(
        width: width,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
            color: toggleStepOne == false && toggleStepTwo == false && toggleStepThree == false ? Colors.green : Colors.grey,
            boxShadow: [
              BoxShadow(
                  color: Colors.black45,
                  blurRadius: 25.0,
                  spreadRadius: 5.0,
                  offset: Offset(10.0, 10.0))
            ]),
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Align(
            child: Row(
              children: [
                Text("Terms & Conditions of the Contract", style: TextStyle(fontSize: 30, color: Colors.white)),
                Container(width: 10),
                toggleStepOne == false && toggleStepTwo == false && toggleStepThree == false ?
                Icon(Icons.check, color: Colors.white, size: 30) :
                Container()
              ],
            ),
            alignment: Alignment.centerLeft),
      ),
      onPressed: () => setStepThree(),
    );
  }

  //------------------ STEP BLOCKS ---------------------------------------------

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

  /// The contract creation is done primarily in 3 steps. This is the second
  /// step block. In the second step the user has to fill in the details about
  /// all actors in the contract.
  Widget contractStep2(double width) {
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
              toggleRequester == true ?
              Text("Role: Requester", style: TextStyle(fontSize: 25)) : Text("Role: Provider", style: TextStyle(fontSize: 25)),
              toggleRequester == true ?
              requesterField() : providerField(widget.providerControllers[0]),
              toggleRequester == true ?
              requesterEmailField() : providerEmailField(),
              toggleRequester == true ?
              requesterAddressField() : providerAddressField(),
              toggleRequester == true ?
              requesterStateField() : providerStateField(),
              toggleRequester == true ?
              requesterRegionField() : providerRegionField(),
              toggleRequester == true ?
              requesterCountryField() : providerCountryField(),
              toggleRequester == true ?
              requesterPhoneField() : providerPhoneField(),
              Container(height: 10),
              toggleRequester == true ? Align(
                alignment: Alignment.centerRight,
                child: nextRoleButton(),
              ) : Container(),
              toggleProvider == true ? Align(
                alignment: Alignment.centerLeft,
                child: previousRoleButton(),
              ) : Container(),
              Container(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  /// The contract creation is done primarily in 3 steps. This is the third step
  /// block. In the third step the user has to fill in the terms and conditions
  /// of the contract.
  Widget contractStep3(double width) {
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
              descriptionField(),
              Container(height: 10),
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

  //------------------- REQUESTER FIELDS ---------------------------------------
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

  Widget requesterEmailField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Requester's e-mail:", style: TextStyle(fontSize: 20)),
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

  Widget requesterAddressField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Requester's address:", style: TextStyle(fontSize: 20)),
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

  Widget requesterCountryField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Requester's country:", style: TextStyle(fontSize: 20)),
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

  Widget requesterStateField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Requester's state:", style: TextStyle(fontSize: 20)),
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

  Widget requesterRegionField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Requester's region:", style: TextStyle(fontSize: 20)),
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

  Widget requesterPhoneField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Requester's phone number:", style: TextStyle(fontSize: 20)),
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

  //------------------- PROVIDER FIELDS ---------------------------------------
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

  Widget providerEmailField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Provider's e-mail:", style: TextStyle(fontSize: 20)),
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

  Widget providerAddressField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Provider's address:", style: TextStyle(fontSize: 20)),
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

  Widget providerCountryField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Provider's country:", style: TextStyle(fontSize: 20)),
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

  Widget providerStateField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Provider's state:", style: TextStyle(fontSize: 20)),
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

  Widget providerRegionField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Provider's region:", style: TextStyle(fontSize: 20)),
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

  Widget providerPhoneField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Provider's phone number:", style: TextStyle(fontSize: 20)),
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


  Widget descriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("What are the Terms & Conditions of the Contract?", style: TextStyle(fontSize: 25)),
        Container(
          height: 400,
          color: Colors.white54,
          child: TextField(
            controller: widget.descriptionController,
            maxLines: null,
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
              hintText: "Enter Contract details here...",
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
              Text(checkBoxTitle, style: TextStyle(fontSize: 20)),
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
            height: 200,
            color: Colors.white54,
            child: TextField(
              controller: widget.descriptionController,
              maxLines: null,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: ("Please enter the amendment details here..."),
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
        child: Text("Next Step", style: TextStyle(color: Colors.white, fontSize: 20)),
        onPressed: () {
          setState(() {
            if(toggleStepOne == true) {
              setStepTwo();
            } else if(toggleStepTwo == true) {
              setStepThree();
            } else if(toggleStepThree = true) {
              toggleStepOne = false;
              toggleStepTwo = false;
              toggleStepThree = false;
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
          child: Text("Previous Step", style: TextStyle(color: Colors.white, fontSize: 20)),
          onPressed: () {
            setState(() {
              if(toggleStepOne == true) {
                setStepOne();
              } else if(toggleStepTwo == true) {
                setStepOne();
              } else if(toggleStepThree == true) {
                setStepTwo();
              } else if(toggleStepOne == false && toggleStepTwo == false && toggleStepThree == false) {
                setStepThree();
              }
            });
          },
        )
    );
  }

  Widget nextRoleButton() {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.green,
      child: IconButton(
        icon: Icon(Icons.navigate_next),
        onPressed: () {
          setState(() {
            toggleRequester = false;
            toggleProvider = true;
          });
        },
      ),
    );
  }

  Widget previousRoleButton() {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.grey,
      child: IconButton(
        icon: Icon(Icons.navigate_before),
        onPressed: () {
          setState(() {
            toggleProvider = false;
            toggleRequester = true;
          });
        }
      ),
    );
  }

  void setStepOne() {
    setState(() {
      toggleStepOne = true;
      toggleStepTwo = false;
      toggleStepThree = false;
    });
  }

  void setStepTwo() {
    setState(() {
      toggleStepOne = false;
      toggleStepTwo = true;
      toggleStepThree = false;
    });
  }

  void setStepThree() {
    setState(() {
      toggleStepOne = false;
      toggleStepTwo = false;
      toggleStepThree = true;
    });
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
