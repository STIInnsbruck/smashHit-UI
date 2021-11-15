import 'package:flutter/material.dart';
import 'package:smashhit_ui/misc/legal_term_texts.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import 'package:country_state_city_pro/country_state_city_pro.dart';

enum ContractType { Written, Mutual, Verbal, Transferable }

class ContractForm extends StatefulWidget {
  final Function(int, [String]) changeScreen;
  Function(int?)? toggleEditing;
  int step;
  Contract? contract;
  DateTime? startDate;
  DateTime? effectiveDate;
  DateTime? executionDate;
  DateTime? endDate;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<TextEditingController> requesterControllers = [];
  List<TextEditingController> providerControllers = [];
  List<TextEditingController> termControllers = [];
  String? contractDropDownType;

  ContractForm(this.changeScreen, this.step, this.contract, [this.toggleEditing]);

  @override
  _ContractFormState createState() => new _ContractFormState();
}

class _ContractFormState extends State<ContractForm> {

  //------------------- General Variables --------------------------------------
  DateTime? startDate;
  DateTime? effectiveDate;
  DateTime? endDate;
  DateTime? executionDate;

  ContractType? _type;

  DataProvider dataProvider = DataProvider();

  //------------------- CheckBox Booleans --------------------------------------
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



  //------------------- StepNavigation Booleans --------------------------------
  bool toggleStepOne = true;
  bool toggleStepTwo = false;
  bool toggleStepThree = false;
  bool toggleStepFour = false;
  bool toggleStepFinal = false;
  bool toggleRequester = true;
  bool toggleProvider = false;

  //------------------- StepValidation Booleans --------------------------------
  bool stepOneComplete = false;
  bool stepTwoComplete = false;
  bool stepThreeComplete = false;
  bool stepFourComplete = false;

  //------------------- Validation Keys ----------------------------------------
  final step1Key = GlobalKey<FormState>();
  List<GlobalKey<FormState>> step2Keys = [];
  List<GlobalKey<FormState>> step3Keys = [];
  final _step4Key = GlobalKey<FormState>();

  //------------------- Other Variables ----------------------------------------
  List<User> requesters = [];
  int currentRequesterIndex = 0;
  List<User> providers = [];
  int currentProviderIndex = 0;
  static List<User> contractors = [];
  Contract? tmpContract;

  @override
  void initState() {
    super.initState();

    // Add at least one contract requester & one provider.
    addRequester();
    addProvider();

    //Initialize the term controllers.
    initTermControllers();

    // Add minimum amount of keys for each initial textFormField.
    addStep2Keys();
    addStep3Keys();
    setStep();
    if (widget.contract != null) {
      setFormFields();
      //tmpContract = widget.contract;
    } else {

    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(children: [
      Container(
          child: Scrollbar(
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
            contractStep1Header(screenWidth * 0.5),
            toggleStepOne == true
                ? contractStep1(screenWidth * 0.5)
                : Container(),
            contractStep2Header(screenWidth * 0.5),
            toggleStepTwo == true
                ? contractStep2(screenWidth * 0.5, currentRequesterIndex)
                : Container(),
            contractStep3Header(screenWidth * 0.5),
            toggleStepThree == true
                ? contractStep3(screenWidth * 0.5, currentProviderIndex)
                : Container(),
            contractStep4Header(screenWidth * 0.5),
            toggleStepFour == true
                ? contractStep4(screenWidth * 0.5)
                : Container(),
            contractStepFinalHeader(screenWidth * 0.5),
            toggleStepFinal == true
                ? contractStepFinal(screenWidth * 0.5)
                : Container(),
          ])))),
      Align(
        alignment: Alignment.centerRight,
        child: widget.contract != null? Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            nextStepButton(),
            confirmEditButton()
          ],
        ) : nextStepButton(),
      ),
      Align(
        alignment: Alignment.bottomLeft,
        child: previousStepButton(),
      )
    ]);
  }

  //------------------ STEP HEADERS --------------------------------------------
  Widget contractStep1Header(double width) {
    return MaterialButton(
        child: Container(
          width: width,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              color: stepOneComplete == false ? Colors.grey : Colors.green,
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
                  Expanded(
                      child: Text("Step 1. Contract Base Information",
                          style: TextStyle(fontSize: 30, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          maxLines: 1)),
                  Container(width: 10),
                  stepOneComplete == false
                      ? Container()
                      : Icon(Icons.check, color: Colors.white, size: 30)
                ],
              ),
              alignment: Alignment.centerLeft),
        ),
        onPressed: () => setStepOne());
  }

  Widget contractStep2Header(double width) {
    return MaterialButton(
        child: Container(
          width: width,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              color: stepTwoComplete == true
                  ? Colors.green
                  : Colors.grey,
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
                  Expanded(
                      child: Text("Step 2. Data Controller(s) Details",
                          style: TextStyle(fontSize: 30, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          maxLines: 1)),
                  Container(width: 10),
                  stepTwoComplete == true
                      ? Icon(Icons.check, color: Colors.white, size: 30)
                      : Container(),
                ],
              ),
              alignment: Alignment.centerLeft),
        ),
        onPressed: () async {
          setStepTwo();
        });
  }

  Widget contractStep3Header(double width) {
    return MaterialButton(
        child: Container(
          width: width,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              color: stepThreeComplete == true
                  ? Colors.green
                  : Colors.grey,
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
                  Expanded(
                      child: Text("Step 3. Data Processor(s) Details",
                          style: TextStyle(fontSize: 30, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          maxLines: 1)),
                  Container(width: 10),
                  stepThreeComplete == true
                      ? Icon(Icons.check, color: Colors.white, size: 30)
                      : Container()
                ],
              ),
              alignment: Alignment.centerLeft),
        ),
        onPressed: () async  {
          setStepThree();
        });
  }

  Widget contractStep4Header(double width) {
    return MaterialButton(
      child: Container(
        width: width,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
            color: stepFourComplete == true
                ? Colors.green
                : Colors.grey,
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
                Expanded(
                    child: Text("Step 4. Terms & Conditions of the Contract",
                        style: TextStyle(fontSize: 30, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1)),
                Container(width: 10),
                stepFourComplete == true
                    ? Icon(Icons.check, color: Colors.white, size: 30)
                    : Container(),
              ],
            ),
            alignment: Alignment.centerLeft),
      ),
      onPressed: () => setStepFour(),
    );
  }

  Widget contractStepFinalHeader(double width) {
    return MaterialButton(
      child: Container(
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
            child: Row(
              children: [
                Expanded(
                    child: Text("Final Step - Overview",
                        style: TextStyle(fontSize: 30, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1)),
              ],
            ),
            alignment: Alignment.centerLeft),
      ),
      onPressed: () => setStepFinal(),
    );
  }

  //------------------ STEP BLOCKS ---------------------------------------------

  /// The contract creation is done primarily in 4 steps. This is the first step
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
            ],
          ),
        ),
      ),
    );
  }

  /// The contract creation is done primarily in 4 steps. This is the second
  /// step block. In the second step the user has to fill in the details about
  /// all requester actors in the contract.
  /// [index] is the requester in the list of requesters.
  Widget contractStep2(double width, int index) {
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
              Text("Role: Data Controller ${index + 1}",
                  style: TextStyle(fontSize: 25)),
              // Every Requester has 7 Fields. Assign each field the right controller.
              requesterFieldSuggestor((index * 7) + 0),
              requesterEmailField((index * 7) + 1),
              requesterAddressField((index * 7) + 2),
              Container(height: 10),
              requesterCSCDropDownList((index * 7) + 3),
              Container(height: 10),
              requesterPhoneField((index * 7) + 6),
              Container(height: 10),
              /**Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  currentRequesterIndex - 1 >= 0
                      ? previousRequesterButton()
                      : Container(width: 40),
                  addRequesterButton(),
                  currentRequesterIndex > 0
                      ? removeRequesterButton()
                      : Container(),
                  currentRequesterIndex + 1 < requesters.length
                      ? nextRequesterButton()
                      : Container(width: 40),
                ],
              ),*/
              Container(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  /// The contract creation is done primarily in 4 steps. This is the third step
  /// block. In the third step the user has to fill in the details about all
  /// provider actors in the contract.
  /// [index] is the provider in the list of providers.
  Widget contractStep3(double width, int index) {
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
              Text("Role: Data Processor ${index + 1}",
                  style: TextStyle(fontSize: 25)),
              providerFieldSuggestor((index * 7) + 0),
              providerEmailField((index * 7) + 1),
              providerAddressField((index * 7) + 2),
              Container(height: 10),
              providerCSCDropDownList((index * 7) + 3),
              Container(height: 10),
              providerPhoneField((index * 7) + 6),
              Container(height: 10),
              /**Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  currentProviderIndex - 1 >= 0
                      ? previousProviderButton()
                      : Container(width: 40),
                  addProviderButton(),
                  currentProviderIndex > 0
                      ? removeProviderButton()
                      : Container(),
                  currentProviderIndex + 1 < providers.length
                      ? nextProviderButton()
                      : Container(width: 40),
                ],
              ),*/
              Container(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  /// The contract creation is done primarily in 4 steps. This is the fourth
  /// step block. In the fourth step the user has to fill in the terms and
  /// conditions of the contract.
  Widget contractStep4(double width) {
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
                  checkBoxElement(
                      'Amendment', 'Has an amendment', AMENDMENT, isAmendment, widget.termControllers[0], width / 4),
                  checkBoxElement(
                      'ConfidentialityObligation',
                      'Is there a confidentiality obligation?',
                      CONFIDENTIALITY_OBLIGATION,
                      isConfidentialObligation, widget.termControllers[1], width / 4),
                  checkBoxElement(
                      'DataController',
                      'Is there a data controller?',
                      DATA_CONTROLLER,
                      isDataController, widget.termControllers[2], width / 4),
                  checkBoxElement(
                      'DataProtection',
                      'Does the contract contain data protection?',
                      DATA_PROTECTION,
                      isDataProtection, widget.termControllers[3], width / 4),
                  checkBoxElement(
                      'LimitationOnUse',
                      'Is there a limitation on use?',
                      LIMITATION_ON_USE,
                      isLimitationOnUse, widget.termControllers[4], width / 4),
                  checkBoxElement('MethodOfNotice', 'Has method of notice?',
                      METHOD_OF_NOTICE, isMethodOfNotice, widget.termControllers[5], width / 4),
                  checkBoxElement(
                      'NoThirdPartyBeneficiaries',
                      'Are there third party beneficiaries?',
                      NO_THIRD_PARTY_BENEFICIARIES,
                      isNoThirdPartyBeneficiaries, widget.termControllers[6], width / 4),
                  checkBoxElement(
                      'PermittedDisclosure',
                      'Is there a permitted disclosure?',
                      PERMITTED_DISCLOSURE,
                      isPermittedDisclosure, widget.termControllers[7], width / 4),
                  checkBoxElement(
                      'ReceiptOfNotice',
                      'Is there a receipt of notice?',
                      RECEIPT_OF_NOTICE,
                      isReceiptOfNotice, widget.termControllers[8], width / 4),
                  checkBoxElement('Severability', 'Is there a severability?',
                      SEVERABILITY, isSeverability, widget.termControllers[9], width / 4),
                  checkBoxElement(
                      'TerminationForInsolvency',
                      'Is there a termination for insolvency?',
                      TERMINATION_FOR_INSOLVENCY,
                      isTerminationForInsolvency, widget.termControllers[10], width / 4),
                  checkBoxElement(
                      'TerminationForMaterialBreach',
                      'Is there a termination for material breach?',
                      TERMINATION_FOR_MATERIAL_BREACH,
                      isTerminationForMaterialBreach, widget.termControllers[11], width / 4),
                  checkBoxElement(
                      'TerminationOnNotice',
                      'Is there a termination on notice?',
                      TERMINATION_ON_NOTICE,
                      isTerminationOnNotice, widget.termControllers[12], width / 4),
                  checkBoxElement('Waiver', 'Waiver', WAIVER, isWaiver, widget.termControllers[13], width / 4),
                ],
              ),
              Container(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      startDate == null
                          ? Container()
                          : Text("Chosen Start Date:", style: TextStyle(fontSize: width / 50)),
                      startDateButton(width / 6),
                    ],
                  ),
                  Column(
                    children: [
                      effectiveDate == null
                          ? Container()
                          : Text("Chosen Effective Date:", style: TextStyle(fontSize: width / 50)),
                      effectiveDateButton(width / 6),
                    ],
                  ),
                  Column(
                    children: [
                      executionDate == null
                          ? Container()
                          : Text("Chosen Execution Date:", style: TextStyle(fontSize: width / 50)),
                      executionDateButton(width / 6),
                    ],
                  ),
                  Column(
                    children: [
                      endDate == null ? Container() : Text("Chosen End Date:", style: TextStyle(fontSize: width / 50)),
                      endDateButton(width / 6),
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

  /// The contract creation has a final step for the user to overview their
  /// created contract and confirm their input.
  Widget contractStepFinal(double width) {
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
      padding: EdgeInsets.fromLTRB(60, 20, 60, 20),
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${widget.titleController.text}',
              style: TextStyle(
                  fontSize: 25, decoration: TextDecoration.underline),
              textAlign: TextAlign.center),
          Container(height: 20),
          Align(
            child: Text('Contract Type: $_type',
                style: TextStyle(fontSize: 15)),
            alignment: Alignment.centerLeft,
          ),
          Container(height: 10),
          Row(
            children: [
              Text('Data Controller(s):', style: TextStyle(fontSize: 15)),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${widget.requesterControllers[0].text}')
                ],
              )
            ],
          ),
          Container(height: 10),
          Row(
            children: [
              Text('Data Processor(s):', style: TextStyle(fontSize: 15)),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${widget.providerControllers[0].text}')
                ],
              )
            ],
          ),
          Container(height: 20),
          Text('Terms & Conditions',
              style: TextStyle(
                  fontSize: 20, decoration: TextDecoration.underline)),
          Container(height: 20),
          Container(
            //padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: Text('${widget.descriptionController.text}',
                  textAlign: TextAlign.justify)),
          Container(height: 20),
          Text('Amendment',
              style: TextStyle(
                  fontSize: 15, decoration: TextDecoration.underline)),
          displayTermElementInfo(isAmendment, widget.termControllers[0]),

          Container(height: 20),
          Text('Confidentiality Obligation',
              style: TextStyle(
                  fontSize: 15, decoration: TextDecoration.underline)),
          displayTermElementInfo(isConfidentialObligation, widget.termControllers[1]),

          Container(height: 20),
          Text('Data Controller',
              style: TextStyle(
                  fontSize: 15, decoration: TextDecoration.underline)),
          displayTermElementInfo(isDataController, widget.termControllers[2]),

          Container(height: 20),
          Text('Data Protection',
              style: TextStyle(
                  fontSize: 15, decoration: TextDecoration.underline)),
          displayTermElementInfo(isDataProtection, widget.termControllers[3]),

          Container(height: 20),
          Text('Limitation On Use',
              style: TextStyle(
                  fontSize: 15, decoration: TextDecoration.underline)),
          displayTermElementInfo(isLimitationOnUse, widget.termControllers[4]),

          Container(height: 20),
          Text('Method Of Notice',
              style: TextStyle(
                  fontSize: 15, decoration: TextDecoration.underline)),
          displayTermElementInfo(isMethodOfNotice, widget.termControllers[5]),

          Container(height: 20),
          Text('Third Party Beneficiaries',
              style: TextStyle(
                  fontSize: 15, decoration: TextDecoration.underline)),
          displayTermElementInfo(isNoThirdPartyBeneficiaries, widget.termControllers[6]),

          Container(height: 20),
          Text('Permitted Disclosure',
              style: TextStyle(
                  fontSize: 15, decoration: TextDecoration.underline)),
          displayTermElementInfo(isPermittedDisclosure, widget.termControllers[7]),

          Container(height: 20),
          Text('Receipt of Notice',
              style: TextStyle(
                  fontSize: 15, decoration: TextDecoration.underline)),
          displayTermElementInfo(isConfidentialObligation, widget.termControllers[8]),

          Container(height: 20),
          Text('Severability',
              style: TextStyle(
                  fontSize: 15, decoration: TextDecoration.underline)),
          displayTermElementInfo(isSeverability, widget.termControllers[9]),

          Container(height: 20),
          Text('Termination Of Insolvency',
              style: TextStyle(
                  fontSize: 15, decoration: TextDecoration.underline)),
          displayTermElementInfo(isTerminationForInsolvency, widget.termControllers[10]),

          Container(height: 20),
          Text('Termination For Material Breach',
              style: TextStyle(
                  fontSize: 15, decoration: TextDecoration.underline)),
          displayTermElementInfo(isTerminationForMaterialBreach, widget.termControllers[11]),

          Container(height: 20),
          Text('Termination On Notice',
              style: TextStyle(
                  fontSize: 15, decoration: TextDecoration.underline)),
          displayTermElementInfo(isTerminationOnNotice, widget.termControllers[12]),

          Container(height: 20),
          Text('Waiver',
              style: TextStyle(
                  fontSize: 15, decoration: TextDecoration.underline)),
          displayTermElementInfo(isWaiver, widget.termControllers[13]),

          Container(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Start Date: ${_formatDate(startDate)}'),
              Text('Effective Date: ${_formatDate(effectiveDate)}'),
              Text('Execution Date: ${_formatDate(executionDate)}'),
              Text('End Date: ${_formatDate(endDate)}'),
            ],
          ),
          Container(height: 40),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                displaySignatureFields(widget.requesterControllers),
                displaySignatureFields(widget.providerControllers)
              ],
            ),
          )
        ],
      ),
    );
  }

  //------------------- REQUESTER FIELDS ---------------------------------------
  Widget requesterField(int index) {
    return Form(
      key: step2Keys[index],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "What is the name of the contract data controller ${currentRequesterIndex + 1}?",
              style: TextStyle(fontSize: 16)),
          Container(height: 5),
          TextFormField(
            decoration: InputDecoration(
              isDense: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.blue)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.black, width: 1.0)),
            ),
            style: TextStyle(fontSize: 16),
            controller: widget.requesterControllers[index],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name.';
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  Widget requesterFieldSuggestor(int index) {
    return Form(
      key: step2Keys[index],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "What is the name of the contract data controller ${currentRequesterIndex + 1}?",
              style: TextStyle(fontSize: 16)),
          Container(height: 5),
          Autocomplete(
            displayStringForOption: _displayStringForOption,
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<User>.empty();
              }
              return contractors.where((User option) {
                return option.toString().contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (User selection) {
              _fillRequesterForm(selection, index);
            },
            fieldViewBuilder: (
              BuildContext context,
              TextEditingController fieldTextEditingController,
              FocusNode fieldFocusNode,
              VoidCallback onFieldSubmitted
            ) {
              fieldTextEditingController.text = widget.requesterControllers[index].text;
              return TextField(
                controller: fieldTextEditingController,
                focusNode: fieldFocusNode,
                decoration: InputDecoration(
                  isDense: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      borderSide: BorderSide(color: Colors.blue)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      borderSide: BorderSide(color: Colors.black, width: 1.0)),
                ),
                style: TextStyle(fontSize: 16),
              );
            },
          )
        ],
      ),
    );
  }

  static String _displayStringForOption(User option) => option.name!;

  Widget requesterEmailField(int index) {
    return Form(
      key: step2Keys[index],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("E-mail:", style: TextStyle(fontSize: 16)),
          Container(height: 5),
          TextFormField(
            decoration: InputDecoration(
              isDense: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.blue)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.black, width: 1.0)),
            ),
            style: TextStyle(fontSize: 16),
            controller: widget.requesterControllers[index],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a email.';
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  Widget requesterAddressField(int index) {
    return Form(
      key: step2Keys[index],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("House number and Street Name:", style: TextStyle(fontSize: 16)),
          Container(height: 5),
          TextFormField(
            decoration: InputDecoration(
              isDense: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.blue)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.black, width: 1.0)),
            ),
            style: TextStyle(fontSize: 16),
            controller: widget.requesterControllers[index],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an address.';
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  Widget requesterCSCDropDownList(int index) {
    return CountryStateCityPicker(
      state: widget.requesterControllers[index],
      city: widget.requesterControllers[index + 1],
      country: widget.requesterControllers[index + 2],
      textFieldInputBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2.0),
          borderSide: BorderSide(color: Colors.black, width: 2.0)),
    );
  }

  Widget requesterPhoneField(int index) {
    return Form(
      key: step2Keys[index - 3],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Phone number:", style: TextStyle(fontSize: 16)),
          Container(height: 5),
          TextFormField(
            decoration: InputDecoration(
              isDense: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.blue)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.black, width: 1.0)),
            ),
            style: TextStyle(fontSize: 16),
            controller: widget.requesterControllers[index],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a phone number.';
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  //------------------- PROVIDER FIELDS ----------------------------------------
  Widget providerField(int index) {
    return Form(
      key: step3Keys[index],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("What is the name of the data processor ${index + 1}?",
              style: TextStyle(fontSize: 16)),
          Container(height: 5),
          TextFormField(
            decoration: InputDecoration(
              isDense: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.blue)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.black, width: 1.0)),
            ),
            style: TextStyle(fontSize: 16),
            controller: widget.providerControllers[index],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name.';
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  Widget providerFieldSuggestor(int index) {
    return Form(
      key: step3Keys[index],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "What is the name of the contract data processor ${currentProviderIndex + 1}?",
              style: TextStyle(fontSize: 16)),
          Container(height: 5),
          Autocomplete(
            displayStringForOption: _displayStringForOption,
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<User>.empty();
              }
              return contractors.where((User option) {
                return option.toString().contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (User selection) {
              _fillProviderForm(selection, index);
            },
            fieldViewBuilder: (
                BuildContext context,
                TextEditingController fieldTextEditingController,
                FocusNode fieldFocusNode,
                VoidCallback onFieldSubmitted
                ) {
              fieldTextEditingController.text = widget.providerControllers[index].text;
              return TextField(
                controller: fieldTextEditingController,
                focusNode: fieldFocusNode,
                decoration: InputDecoration(
                  isDense: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      borderSide: BorderSide(color: Colors.blue)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      borderSide: BorderSide(color: Colors.black, width: 1.0)),
                ),
                style: TextStyle(fontSize: 16),
              );
            },
          )
        ],
      ),
    );
  }

  Widget providerEmailField(int index) {
    return Form(
      key: step3Keys[index],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("E-mail:", style: TextStyle(fontSize: 16)),
          Container(height: 5),
          TextFormField(
            decoration: InputDecoration(
              isDense: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.blue)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.black, width: 1.0)),
            ),
            style: TextStyle(fontSize: 16),
            controller: widget.providerControllers[index],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email.';
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  Widget providerAddressField(int index) {
    return Form(
      key: step3Keys[index],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("House number and Street name:", style: TextStyle(fontSize: 16)),
          Container(height: 5),
          TextFormField(
            decoration: InputDecoration(
              isDense: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.blue)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.black, width: 1.0)),
            ),
            style: TextStyle(fontSize: 16),
            controller: widget.providerControllers[index],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an address.';
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  Widget providerCSCDropDownList(int index) {
    return CountryStateCityPicker(
      state: widget.providerControllers[index],
      city: widget.providerControllers[index + 1],
      country: widget.providerControllers[index + 2],
      textFieldInputBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2.0),
          borderSide: BorderSide(color: Colors.black, width: 2.0)),
    );
  }

  Widget providerPhoneField(int index) {
    return Form(
      key: step3Keys[index - 3],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Phone number:", style: TextStyle(fontSize: 16)),
          Container(height: 5),
          TextFormField(
            decoration: InputDecoration(
              isDense: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.blue)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.black, width: 1.0)),
            ),
            style: TextStyle(fontSize: 16),
            controller: widget.providerControllers[index],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a phone number.';
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  //------------------- CONTRACT FIELDS ----------------------------------------
  Widget descriptionField() {
    return Form(
      key: _step4Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("What are the Terms & Conditions of the Contract?",
              style: TextStyle(fontSize: 25)),
          Container(
            height: 400,
            color: Colors.white54,
            child: TextFormField(
              controller: widget.descriptionController,
              maxLines: null,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: "Enter Contract details here...",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the terms and conditions of the contract.';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  //------------------ OTHER ELEMENTS ------------------------------------------
  Widget contractTypeMenu() {
    return Row(
      children: [
        Text("What type of contract is being formed?",
            style: TextStyle(fontSize: 20)),
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
        Text("What type of contract is being formed?",
            style: TextStyle(fontSize: 20)),
        ListTile(
            title: Text("Written Contract",
                style: TextStyle(fontSize: 15, color: Colors.black)),
            leading: Radio(
                value: ContractType.Written,
                groupValue: _type,
                onChanged: (ContractType? value) {
                  setState(() {
                    _type = value;
                  });
                })),
        ListTile(
            title: Text("Verbal Contract",
                style: TextStyle(fontSize: 15, color: Colors.black)),
            leading: Radio(
                value: ContractType.Verbal,
                groupValue: _type,
                onChanged: (ContractType? value) {
                  setState(() {
                    _type = value;
                  });
                })),
        ListTile(
            title: Text("Mutual Contract",
                style: TextStyle(fontSize: 15, color: Colors.black)),
            leading: Radio(
                value: ContractType.Mutual,
                groupValue: _type,
                onChanged: (ContractType? value) {
                  setState(() {
                    _type = value;
                  });
                })),
        ListTile(
            title: Text("Transferable Contract",
                style: TextStyle(fontSize: 15, color: Colors.black)),
            leading: Radio(
                value: ContractType.Transferable,
                groupValue: _type,
                onChanged: (ContractType? value) {
                  setState(() {
                    _type = value;
                  });
                })),
      ],
    );
  }

  Widget titleField() {
    return Form(
      key: step1Key,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("What is the title of your contract?",
              style: TextStyle(fontSize: 20)),
          Container(height: 5),
          TextFormField(
            decoration: InputDecoration(
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.blue)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.black, width: 1.0)),
            ),
            style: TextStyle(fontSize: 20),
            controller: widget.titleController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title for your contract.';
              }
              return null;
            },
          )
        ],
      ),
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
  Widget checkBoxElement(String contractElement, String checkBoxTitle,
      String tooltipMessage, CheckBoxBoolean isChecked, TextEditingController textController, double width) {
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
                  }),
              Container(width: 5),
              Text(checkBoxTitle, style: TextStyle(fontSize: width / 10)),
              Container(width: 5),
              Tooltip(
                textStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontStyle: FontStyle.italic),
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
          isChecked.value == true
              ? Container(
                  height: 200,
                  color: Colors.white54,
                  child: TextField(
                    controller: textController,
                    maxLines: null,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      hintText:
                          ("Please enter the $checkBoxTitle details here..."),
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0),
                          borderSide: BorderSide(color: Colors.blue)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0),
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0)),
                    ),
                  ))
              : Container()
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
          Text("Add Contract Element",
              style: TextStyle(color: Colors.black, fontSize: 10))
        ],
      ),
      onPressed: () {
        print("Add Contract Element - Pressed.");
      },
    );
  }

  Widget startDateButton(double width) {
    return Container(
      width: width,
      height: 50,
      child: MaterialButton(
        color: Colors.blue,
        hoverColor: Colors.lightBlueAccent,
        child: startDate == null
            ? Text("Pick a Start Date",
                style: TextStyle(color: Colors.white, fontSize: width / 7),
                textAlign: TextAlign.center)
            : Text(_formatDate(startDate),
                style: TextStyle(color: Colors.white, fontSize: width / 7),
                textAlign: TextAlign.center),
        onPressed: () => chooseStartDate(),
      ),
    );
  }

  Widget effectiveDateButton(double width) {
    return Container(
      width: width,
      height: 50,
      child: MaterialButton(
        color: Colors.blue,
        hoverColor: Colors.lightBlueAccent,
        child: effectiveDate == null
            ? Text("Pick an Effective Date",
                style: TextStyle(color: Colors.white, fontSize: width / 7),
                textAlign: TextAlign.center)
            : Text(_formatDate(effectiveDate),
                style: TextStyle(color: Colors.white, fontSize: width / 7),
                textAlign: TextAlign.center),
        onPressed: () => chooseEffectiveDate(),
      ),
    );
  }

  Widget endDateButton(double width) {
    return Container(
      width: width,
      height: 50,
      child: MaterialButton(
        color: Colors.blue,
        hoverColor: Colors.lightBlueAccent,
        child: endDate == null
            ? Text("Pick an End Date",
                style: TextStyle(color: Colors.white, fontSize: width / 7),
                textAlign: TextAlign.center)
            : Text(_formatDate(endDate),
                style: TextStyle(color: Colors.white, fontSize: width / 7),
                textAlign: TextAlign.center),
        onPressed: () => chooseEndDate(),
      ),
    );
  }

  Widget executionDateButton(double width) {
    return Container(
      width: width,
      height: 50,
      child: MaterialButton(
        color: Colors.blue,
        hoverColor: Colors.lightBlueAccent,
        child: executionDate == null
            ? Text("Pick an Execution Date",
                style: TextStyle(color: Colors.white, fontSize: width / 7),
                textAlign: TextAlign.center)
            : Text(_formatDate(executionDate),
                style: TextStyle(color: Colors.white, fontSize: width / 7),
                textAlign: TextAlign.center),
        onPressed: () => chooseExecutionDate(),
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

  Future<void> chooseEffectiveDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050, 1, 1),
    );
    if (pickedDate != null && endDate == null) {
      setState(() {
        effectiveDate = pickedDate;
        setWidgetStartDate();
      });
    } else if (pickedDate != null &&
        endDate != null &&
        pickedDate.isBefore(endDate!)) {
      setState(() {
        effectiveDate = pickedDate;
        setWidgetStartDate();
      });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text(
                  "Please select an effective date that is before the selected end date."),
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

  Future<void> chooseExecutionDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050, 1, 1),
    );
    if (pickedDate != null && endDate == null) {
      setState(() {
        executionDate = pickedDate;
        setWidgetStartDate();
      });
    } else if (pickedDate != null &&
        endDate != null &&
        pickedDate.isBefore(endDate!)) {
      setState(() {
        executionDate = pickedDate;
        setWidgetStartDate();
      });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text(
                  "Please select an execution date that is before the selected end date."),
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
          child: toggleStepFinal == true
              ? Text('Confirm & Submit',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center)
              : toggleStepFour == true
                  ? Text("Go To Overview",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center)
                  : Text("Next Step",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
          onPressed: () async {
            if (toggleStepOne == true) {
              setStepTwo();
            } else if (toggleStepTwo == true) {
              setStepThree();
            } else if (toggleStepThree == true) {
              setStepFour();
            } else if (toggleStepFour == true) {
              setStepFinal();
            } else if (toggleStepFinal == true) {
              setState(() {
                toggleStepFinal = false;
              });
              if (await dataProvider.createContract(
                  widget.titleController.text,
                  widget.descriptionController.text,
                  "Written",
                  startDate!,
                  endDate!,
                  widget.requesterControllers[0].text,
                  widget.providerControllers[0].text)) {
                _showCreateSuccessDialog();
                //TODO: change so that this navigation function is not in this widget but in a screen
                widget.changeScreen(2, widget.titleController.text.replaceAll(' ', ''));
              } else {
                _showCreateFailDialog();
              }
            }
          },
        ));
  }

  Widget confirmEditButton() {
    return Container(
      width: 150,
      height: 50,
      child: MaterialButton(
        color: Colors.grey,
        hoverColor: Colors.blueGrey,
        child: Text("Confirm Changes", style: TextStyle(color: Colors.white, fontSize: 20)),
        onPressed: () {
          setContract();
          print("Original contract ID: ${widget.contract!.contractId!}");
          setState(() {
            widget.contract = tmpContract;
            print("Modified contract ID: ${widget.contract!.contractId!}");
          });
          widget.toggleEditing!(null);
        }
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
          child: Text("Previous Step",
              style: TextStyle(color: Colors.white, fontSize: 20)),
          onPressed: () {
            setState(() {
              if (toggleStepOne == true) {
                setStepOne();
              } else if (toggleStepTwo == true) {
                setStepOne();
              } else if (toggleStepThree == true) {
                setStepTwo();
              } else if (toggleStepFour == true) {
                setStepThree();
              } else if (toggleStepFinal == true) {
                setStepFour();
              }
            });
          },
        ));
  }

  Widget addRequesterButton() {
    return Tooltip(
      message: "Add another data controller.",
      child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue,
          child: IconButton(
              icon: Icon(Icons.person_add),
              onPressed: () {
                setState(() {
                  addRequester();
                });
              })),
    );
  }

  Widget removeRequesterButton() {
    return Tooltip(
        message: "Remove this data controller.",
        child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue,
            child: IconButton(
                icon: Icon(Icons.person_remove),
                onPressed: () {
                  setState(() {
                    removeRequester(currentRequesterIndex);
                  });
                })));
  }

  Widget addProviderButton() {
    return Tooltip(
      message: "Add another data processor.",
      child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue,
          child: IconButton(
              icon: Icon(Icons.person_add),
              onPressed: () {
                setState(() {
                  addProvider();
                });
              })),
    );
  }

  Widget removeProviderButton() {
    return Tooltip(
        message: "Remove this data processor.",
        child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue,
            child: IconButton(
                icon: Icon(Icons.person_remove),
                onPressed: () {
                  setState(() {
                    removeProvider(currentProviderIndex);
                  });
                })));
  }

  Widget nextRequesterButton() {
    return Tooltip(
        message: "Proceed to the next data controller form.",
        child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue,
            child: IconButton(
                icon: Icon(Icons.navigate_next),
                onPressed: () {
                  setState(() {
                    currentRequesterIndex += 1;
                  });
                })));
  }

  Widget previousRequesterButton() {
    return Tooltip(
        message: "Go back to the previous data controller form.",
        child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue,
            child: IconButton(
                icon: Icon(Icons.navigate_before),
                onPressed: () {
                  setState(() {
                    currentRequesterIndex -= 1;
                  });
                })));
  }

  Widget nextProviderButton() {
    return Tooltip(
        message: "Proceed to the next data processor form.",
        child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue,
            child: IconButton(
                icon: Icon(Icons.navigate_next),
                onPressed: () {
                  setState(() {
                    currentProviderIndex += 1;
                  });
                })));
  }

  Widget previousProviderButton() {
    return Tooltip(
        message: "Go back to the previous data processor form.",
        child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue,
            child: IconButton(
                icon: Icon(Icons.navigate_before),
                onPressed: () {
                  setState(() {
                    currentProviderIndex -= 1;
                  });
                })));
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
          }),
    );
  }

  /// Widget to form a signature line with [name] of the corresponding person
  /// displayed under the signature line.
  Widget signatureField(String name) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
      children: [
        Text("_________________________"),
        Text(name, textAlign: TextAlign.center, style: TextStyle(fontSize: 10))
      ],
    ));
  }

  /// Function to dynamically display the correct amount of signature fields
  /// according to the amount of parties involved. [userList] is used to
  /// display the signatureFields for that type of users in that list.
  Widget displaySignatureFields(List<dynamic> userList) {

    List<Widget> fields = [];
    for(int i = 0; i < userList.length; i += 7) {
      fields.add(signatureField(userList[i].text));
    }

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
          itemCount: fields.length,
          itemBuilder: (BuildContext context, int index) {
            return fields[index];
          })
    );
  }

  void setContract() {
    tmpContract = new Contract(
      contractId: widget.titleController.text,
      description: widget.descriptionController.text,
      contracteeId: widget.providerControllers[0].text,
      contractorId: widget.requesterControllers[0].text,
      contractType: 'Written',
      executionDate: startDate,
      expireDate: endDate
    );
  }

  void setFormFields() async {
    contractors = await dataProvider.fetchAllUsers();
    setState(() {
      widget.titleController.text = displayStringWithoutUri(widget.contract!.contractId!);
      _type = ContractType.Written; //TODO: make this use real type -> this is hardcode!
      //TODO: this only takes the first data controller, make it take all existing ones.
      _fillRequesterForm(contractors.firstWhere((element) => element.id!.compareTo(displayStringWithoutUri(widget.contract!.contractorId!)) == 0), 0);
      //TODO: this only takes the first data processor, make it take all existing ones.
      _fillProviderForm(contractors.firstWhere((element) => element.id!.compareTo(displayStringWithoutUri(widget.contract!.contracteeId!)) == 0), 0);
      widget.descriptionController.text = widget.contract!.description!;
      startDate = widget.contract!.executionDate;
      effectiveDate = widget.contract!.executionDate;
      executionDate = widget.contract!.executionDate;
      endDate = widget.contract!.expireDate;
    });
  }

  /// Helper function to display contract value without the uri. This is just
  /// a DISPLAY function. It does NOT remove the uri in the value.
  String displayStringWithoutUri(String s) {
    return s.replaceAll('http://ontologies.atb-bremen.de/smashHitCore#', '');
  }

  void setFields() {}

  void setStep() {
    switch (widget.step) {
      case 1:
        setStepOne();
        break;
      case 2:
        setStepTwo();
        break;
      case 3:
        setStepThree();
        break;
      case 4:
        setStepFour();
        break;
      case 5:
        setStepFinal();
        break;
    }
  }

  void setStepOne() {
    validateStepTwo();
    validateStepThree();
    validateStepFour();
    setState(() {
      toggleStepOne = true;
      toggleStepTwo = false;
      toggleStepThree = false;
      toggleStepFour = false;
      toggleStepFinal = false;
    });
  }

  void setStepTwo() async {
    contractors = await dataProvider.fetchAllUsers();
    validateStepOne();
    validateStepThree();
    validateStepFour();
    setState(() {
      toggleStepOne = false;
      toggleStepTwo = true;
      toggleStepThree = false;
      toggleStepFour = false;
      toggleStepFinal = false;
    });
  }

  void setStepThree() async {
    contractors = await dataProvider.fetchAllUsers();
    validateStepOne();
    validateStepTwo();
    validateStepFour();
    setState(() {
      toggleStepOne = false;
      toggleStepTwo = false;
      toggleStepThree = true;
      toggleStepFour = false;
      toggleStepFinal = false;
    });
  }

  void setStepFour() {
    validateStepOne();
    validateStepTwo();
    validateStepThree();
    setState(() {
      toggleStepOne = false;
      toggleStepTwo = false;
      toggleStepThree = false;
      toggleStepFour = true;
      toggleStepFinal = false;
    });
  }

  void setStepFinal() {
    validateStepOne();
    validateStepTwo();
    validateStepThree();
    validateStepFour();
    if (stepOneComplete && stepTwoComplete && stepThreeComplete && stepFourComplete) {
      setState(() {
        toggleStepOne = false;
        toggleStepTwo = false;
        toggleStepThree = false;
        toggleStepFour = false;
        toggleStepFinal = true;
      });
    } else {
      print("you have not completed the contract.");
      showContractNotCompleteDialog();
    }
  }

  void showContractNotCompleteDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Icon(Icons.warning, size: 60, color: Colors.yellow)),
                Container(height: 10),
                Text('You have not filled out all contract details. Please complete the form before you move on to the final step.\nRevisit the following steps:'),
                Container(height: 10),
                stepOneComplete? Container() : Text('-    Step 1. Contract Base Information'),
                Container(height: 5),
                stepTwoComplete? Container() : Text('-    Step 2. Data Controller(s) Details'),
                Container(height: 5),
                stepThreeComplete? Container() : Text('-    Step 3. Data Processor(s) Details'),
                Container(height: 5),
                stepFourComplete? Container() : Text('-    Step 4. Terms & Conditions of the Contract'),
                Container(height: 5)
              ],
            ),
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

  _showCreateSuccessDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Success!', textAlign: TextAlign.center),
            contentPadding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 100),
              Text('The contract was successfully created!', textAlign: TextAlign.center),
              Container(height: 5),
              MaterialButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],

          );
        }
    );
  }

  _showCreateFailDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Error!'),
            children: [
              Icon(Icons.error, color: Colors.red, size: 60),
              Text('Ups! The contract could not be created!'),
              Container(height: 5),
              MaterialButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],

          );
        }
    );
  }

  void _fillProviderForm(User selected, int index) {
    widget.providerControllers[index].text = selected.name == null ? 'No name found' : selected.name!;
    widget.providerControllers[index+1].text = selected.email == null ? 'No email found' : selected.email!;
    widget.providerControllers[index+2].text = selected.streetAddress == null ? 'No street address found' : selected.streetAddress!;
    widget.providerControllers[index+3].text = selected.country == null ? 'No country found' : selected.country!;
    widget.providerControllers[index+4].text = selected.state == null ? 'No state found' : selected.state!;
    widget.providerControllers[index+5].text = selected.city == null ? 'No city found' : selected.city!;
    widget.providerControllers[index+6].text = selected.telephoneNumber == null ? 'No phone number found' : selected.telephoneNumber!;
  }

  void _fillRequesterForm(User selected, int index) {
    widget.requesterControllers[index].text = selected.name == null ? 'No name found' : selected.name!;
    widget.requesterControllers[index+1].text = selected.email == null ? 'No email found' : selected.email!;
    widget.requesterControllers[index+2].text = selected.streetAddress == null ? 'No street address found' : selected.streetAddress!;
    widget.requesterControllers[index+3].text = selected.country == null ? 'No country found' : selected.country!;
    widget.requesterControllers[index+4].text = selected.state == null ? 'No state found' : selected.state!;
    widget.requesterControllers[index+5].text = selected.city == null ? 'No city found' : selected.city!;
    widget.requesterControllers[index+6].text = selected.telephoneNumber == null ? 'No phone number found' : selected.telephoneNumber!;
  }

  void validateStepOne() {
    // step1Key.currentState is null when we edit the contract in a step greater than 1.
    if (toggleStepOne == true && step1Key.currentState != null) {
      if (step1Key.currentState!.validate() == true) {
        setState(() {
          stepOneComplete = true;
        });
      } else {
        setState(() {
          stepOneComplete = false;
        });
      }
    } else { //TODO: this is a temp work-around. This case only comes up during an edit attempt.
      setState(() {
        stepOneComplete = true;
      });
    }
  }

  /// Function that checks every textFormField in the second step of the
  /// contract to validate if each field has content in it.
  void validateStepTwo() {
    if (toggleStepTwo == true) {
      var flag = step2Keys.every((element) => element.currentState!.validate() == true);

      if (flag) {
        setState(() {
          stepTwoComplete = true;
        });
      } else {
        setState(() {
          stepTwoComplete = false;
        });
      }
    }
  }

  /// Function that checks every textFormField in the third step of the
  /// contract to validate if each field has content in it.
  void validateStepThree() {
    if (toggleStepThree == true) {
      var flag = step3Keys.every((element) => element.currentState!.validate() == true);

      if (flag) {
        setState(() {
          stepThreeComplete = true;
        });
      } else {
        setState(() {
          stepThreeComplete = false;
        });
      }
    }
  }

  /// Function that checks every textFormField in the fourth step of the
  /// contract to validate if each field has content in it.
  /// Checked fields:
  ///   - Terms & Conditions Field
  ///   - Start Date
  ///   - Effective Date
  ///   - Execution Date
  ///   - End Date
  void validateStepFour() {
    if (toggleStepFour == true) {
      if (_step4Key.currentState!.validate() == true && startDate != null &&
          effectiveDate != null && executionDate != null && endDate != null) {
        setState(() {
          stepFourComplete = true;
        });
      } else {
        setState(() {
          stepFourComplete = false;
        });
      }
    }
  }

  bool validateAllPreviousSteps() {
    if (stepOneComplete && stepTwoComplete && stepThreeComplete && stepFourComplete) {
      return true;
    } else {
      return false;
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

  void setWidgetEffectiveDate() {
    widget.effectiveDate = effectiveDate;
  }

  void setWidgetExecutionDate() {
    widget.executionDate = executionDate;
  }

  void setWidgetEndDate() {
    widget.endDate = endDate;
  }

  Widget displayTermElementInfo(CheckBoxBoolean isChecked, TextEditingController controller) {
    if (controller.text.compareTo("") == 0 || isChecked.value == false) {
      return Text('None.', textAlign: TextAlign.justify);
    } else {
      return Text('${controller.text}', textAlign: TextAlign.justify);
    }
  }

  /// Helper function to add a new requester into the form. Each requester has
  /// 7 TextFields. That is why we add 7 TextEditingController, one for each
  /// field.
  void addRequester() {
    setState(() {
      for (int i = 0; i < 7; i++) {
        widget.requesterControllers.add(TextEditingController());
      }
      requesters.add(User(role: "Primary"));
    });
  }

  /// Helper function to remove a requester form. Each requester has 7
  /// TextFields. That is why we remove 7 TextEditingControllers.
  /// [index] represents the current selected requester.
  void removeRequester(int index) {
    setState(() {
      for (int i = (index * 7) + 6; i >= (index * 7); i--) {
        widget.requesterControllers.removeAt(i);
      }
      requesters.removeAt(index);
      currentRequesterIndex -= 1;
    });
  }

  /// Helper function to remove a provider form. Each provider has 7
  /// TextFields. That is why we remove 7 TextEditingControllers.
  /// [index] represents the current selected provider.
  void removeProvider(int index) {
    setState(() {
      for (int i = (index * 7) + 6; i >= (index * 7); i--) {
        widget.providerControllers.removeAt(i);
      }
      providers.removeAt(index);
      currentProviderIndex -= 1;
    });
  }

  /// Helper function to add a new provider into the form. Each provider has
  /// 7 TextFields. That is why we add 7 TextEditingController, one for each
  /// field.
  void addProvider() {
    setState(() {
      for (int i = 0; i < 7; i++) {
        widget.providerControllers.add(TextEditingController());
      }
      providers.add(User(role: "Secondary"));
    });
  }

  void initTermControllers() {
    setState(() {
      for (int i = 0; i < 14; i++) {
        widget.termControllers.add(TextEditingController());
      }
    });
  }

  /// Helper function to add 7 keys to validate each textFormField in the
  /// second step of the contract creation.
  void addStep2Keys() {
    setState(() {
      for (int i = 0; i < 4; i++) {
        step2Keys.add(GlobalKey<FormState>());
      }
    });
  }

  /// Helper function to add 7 keys to validate each textFormField in the
  /// third step of the contract creation.
  void addStep3Keys() {
    setState(() {
      for (int i = 0; i < 4; i++) {
        step3Keys.add(GlobalKey<FormState>());
      }
    });
  }
}

class CheckBoxBoolean {
  bool value = false;
}
