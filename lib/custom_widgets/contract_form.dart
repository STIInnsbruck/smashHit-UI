import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smashhit_ui/misc/legal_term_texts.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:smashhit_ui/custom_widgets/contract_step_header.dart';
import 'package:smashhit_ui/custom_widgets/contract_step_body.dart';
import 'package:smashhit_ui/custom_widgets/term_widget.dart';
import 'package:smashhit_ui/misc/contract_categories.dart';
import 'package:smashhit_ui/misc/contract_types.dart';
import 'package:smashhit_ui/custom_widgets/obligation_widget.dart';

class ContractForm extends StatefulWidget {
  final Function(int, [String]) changeScreen;
  Function(int?)? toggleEditing;
  Contract? contract;
  DateTime? startDate;
  DateTime? effectiveDate;
  DateTime? executionDate;
  DateTime? endDate;
  String? contractDropDownType;
  User user;

  ContractForm(this.changeScreen, this.contract, this.user,
      [this.toggleEditing]);

  @override
  _ContractFormState createState() => new _ContractFormState();
}

class _ContractFormState extends State<ContractForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController considerationDescController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController considerationValController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController signatureController = TextEditingController();
  List<TextEditingController> contractorControllers = [];

  //------------------- General Variables --------------------------------------
  DateTime? startDate;
  DateTime? effectiveDate;
  DateTime? endDate;
  DateTime? executionDate;

  String? contractType;
  String? contractCategory;

  DataProvider dataProvider = DataProvider();

  int contractStep = 1;

  //------------------- StepValidation Booleans --------------------------------
  bool stepOneComplete = false;
  bool stepTwoComplete = false;
  bool stepObligationComplete = false;
  bool stepFourComplete = false;
  bool loading = false;

  //------------------- Validation Keys ----------------------------------------
  final step1Key = GlobalKey<FormState>();
  List<GlobalKey<FormState>> step2Keys = [];
  List<GlobalKey<FormState>> step3Keys = [];
  final _step4Key = GlobalKey<FormState>();
  final _signatureKey = GlobalKey<FormState>();

  //------------------- Other Variables ----------------------------------------
  static List<User> contractors = []; //list of all existing contractors
  List<User> addedContractors = []; //list of contractors added to the form
  int currentContractorIndex = 0;
  int addedContractorsIndex = 0;
  Contract? tmpContract;
  List<TermType> _termTypeList = []; //list of all existing termTypes
  Map<String, TermWidget> _termMap = {};
  Map<String, ObligationWidget> _obligationMap = {};
  Contract contract = new Contract();
  bool _hasSigned = false;

  @override
  void initState() {
    super.initState();

    //get offline existing termTypes
    //getTermType();

    //Fetch all online existing termTypes
    fetchAllTermTypes();

    // Add at least one contractor
    addContractor();
    // Fetch all existing contractors for the suggestion field
    fetchAllContractors();

    if (widget.contract != null) {
      //tmpContract = widget.contract;
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double formWidth =
        screenWidth * (_isWideScreen(screenWidth, screenHeight) ? 0.7 : 1);

    return Stack(children: [
      Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        contractStepOne(formWidth),
        contractStepTwo(formWidth),
        contractStepFour(formWidth),
        contractStepObligation(formWidth),
        contractStepFinal(formWidth),
      ])),
      Container(
        height: screenHeight,
        width: screenWidth,
        child: Align(
          alignment: Alignment.center,
          child: Row(children: [
            previousStepButton(),
            Spacer(),
            contractStep == 5 ? createContractButton() : nextStepButton()
          ]),
        ),
      )
    ]);
  }

  //------------------ STEP BLOCKS ---------------------------------------------
  Widget contractStepOne(double width) {
    return Column(
      children: [
        ContractStepHeader(
          width: width,
          name: "Step 1. Contract Base Information",
          stepComplete: stepOneComplete,
          onPressed: () => setStepOne(),
        ),
        contractStep == 1
            ? ContractStepBody(width: width, children: [
                titleField(),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    contractTypeDropDown(),
                    contractCategoryDropDown(),
                  ],
                ),
                SizedBox(height: 10),
                _wideScreenDateButtonsLayout()
              ])
            : Container(),
      ],
    );
  }

  Widget contractStepTwo(double width) {
    return Column(
      children: [
        ContractStepHeader(
            width: width,
            name: "Step 2. Add Contractual Parties",
            stepComplete: stepTwoComplete,
            onPressed: () async {
              setStepTwo();
            }),
        contractStep == 2
            ? ContractStepBody(width: width, children: [
                Text("Add Contractual Party ${currentContractorIndex + 1}",
                    style: TextStyle(fontSize: 20)),
                // Every Contractor has 7 Fields. Assign each field the right contractor.
                contractorFieldSuggestor((currentContractorIndex * 7) + 0),
                contractorEmailField((currentContractorIndex * 7) + 1),
                contractorAddressField((currentContractorIndex * 7) + 2),
                SizedBox(height: 10),
                contractorCSCDropDownList((currentContractorIndex * 7) + 3),
                SizedBox(height: 10),
                contractorPhoneField((currentContractorIndex * 7) + 6),
                SizedBox(height: 10),
                Row(
                  children: [
                    currentContractorIndex != 0
                        ? Expanded(child: previousContractorButton())
                        : Expanded(child: Container()),
                    currentContractorIndex != 0
                        ? Expanded(flex: 2, child: removeContractorButton())
                        : Expanded(child: Container()),
                    Expanded(flex: 2, child: addContractorButton()),
                    currentContractorIndex < (addedContractorsIndex - 1)
                        ? Expanded(child: nextContractorButton())
                        : Expanded(child: Container())
                  ],
                ),
              ])
            : Container()
      ],
    );
  }

  Widget contractStepFour(double width) {
    return Column(children: [
      ContractStepHeader(
          width: width,
          name: "Step 3. Terms & Conditions of the Contract",
          stepComplete: stepFourComplete,
          onPressed: () {
            setStepFour();
          }),
      contractStep == 3
          ? ContractStepBody(width: width, children: [
              Text("Add Terms to Your Contract",
                  style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _termMap.length,
                  itemBuilder: (BuildContext context, int index) {
                    String key = _termMap.keys.elementAt(index);
                    return _termMap[key]!;
                  }),
              Text("Add a term to the contract"),
              addTermButton(),
            ])
          : Container()
    ]);
  }

  Widget contractStepObligation(double width) {
    return Column(children: [
      ContractStepHeader(
          width: width,
          name: "Step 4. Clauses of the Contract",
          stepComplete: stepObligationComplete,
          onPressed: () async {
            setStepObligation();
          }),
      contractStep == 4
          ? ContractStepBody(
              width: width,
              children: _termMap.keys.length > 0
                  ? [
                      Text(
                          "You have ${_termMap.keys.length} term(s), you can add clauses to each term.",
                          style: TextStyle(fontSize: 20)),
                      SizedBox(height: 10),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _obligationMap.length,
                        itemBuilder: (BuildContext context, int index) {
                          String key = _obligationMap.keys.elementAt(index);
                          return _obligationMap[key]!;
                        },
                      ),
                      SizedBox(height: 10),
                      addObligationButton(),
                    ]
                  : [
                      Text(
                          "You have not added any terms in the previous step. To add clauses you must have terms in your contract.",
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center),
                    ])
          : Container()
    ]);
  }

  Widget contractStepFinal(double width) {
    return Column(
      children: [
        ContractStepHeader(
            width: width,
            name: "Final Step - Overview",
            onPressed: () => setStepFinal()),
        contractStep == 5
            ? ContractStepBody(width: width, children: [
                Text('${titleController.text}',
                    style: TextStyle(
                        fontSize: 25, decoration: TextDecoration.underline),
                    textAlign: TextAlign.center),
                SizedBox(height: 20),
                Align(
                  child: Text('Contract Type: $contractType',
                      style: TextStyle(fontSize: 15)),
                  alignment: Alignment.centerLeft,
                ),
                SizedBox(height: 10),
                Column(
                  children: displayAllContractorsInfo(),
                ),
                Align(
                    child: Text(
                        "Consideration: ${considerationDescController.text}"),
                    alignment: Alignment.centerLeft),
                SizedBox(height: 10),
                Column(
                  children: displayAllTerms(),
                ),
                SizedBox(height: 10),
                Align(
                    child: Text("Contract Category: $contractCategory",
                        style: TextStyle(fontSize: 15)),
                    alignment: Alignment.centerLeft),
                SizedBox(height: 10),
                Column(
                  children: displayAllSignatureFields(),
                ),
                SizedBox(height: 10),
                contractDates()
              ])
            : Container()
      ],
    );
  }

  Widget contractDates() {
    return Row(
      children: [
        Expanded(
            child: Text("Effective Date: ${_formatDate(effectiveDate)}",
                textAlign: TextAlign.center)),
        Expanded(
            child: Text("Execution Date: ${_formatDate(executionDate)}",
                textAlign: TextAlign.center)),
        Expanded(
            child: Text("End Date: ${_formatDate(endDate)}",
                textAlign: TextAlign.center)),
      ],
    );
  }

  List<Widget> displayAllContractorsInfo() {
    List<Widget> widgets = [];
    for (int i = 0; i < addedContractors.length; i++) {
      widgets.add(contractorInfo(i));
      widgets.add(SizedBox(height: 10));
    }
    return widgets;
  }

  Widget contractorInfo(int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contractual Party-${index + 1}:', style: TextStyle(fontSize: 15)),
        SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${contractorControllers[index * 7 + 0].text}"),
            Text("${contractorControllers[index * 7 + 1].text}"),
            Text("${contractorControllers[index * 7 + 2].text}"),
            Text("${contractorControllers[index * 7 + 3].text}"),
            Text("${contractorControllers[index * 7 + 4].text}"),
            Text("${contractorControllers[index * 7 + 5].text}"),
            Text("${contractorControllers[index * 7 + 6].text}"),
          ],
        )
      ],
    );
  }

  List<Widget> displayAllSignatureFields() {
    List<Widget> widgets = [];
    for (int i = 0; i < addedContractors.length; i++) {
      if (addedContractors[i].id == widget.user.id) {
        widgets.add(ownSignatureField(i, _hasSigned));
      } else {
        widgets.add(otherContractorSignatureField(i));
      }
      widgets.add(SizedBox(height: 10));
    }
    return widgets;
  }

  Widget ownSignatureField(int index, bool hasSigned) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Signature of Contractual Party-${index + 1}:',
            style: TextStyle(fontSize: 15)),
        SizedBox(width: 10),
        Expanded(
            child: hasSigned
                ? MaterialButton(
                    elevation: 0,
                    enableFeedback: false,
                    child: Text("You Have Signed This Contract",
                        style: TextStyle(fontSize: 15, color: Colors.green)),
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: null,
                  )
                : MaterialButton(
                    child: Text("Click To Legally Apply Your Signature",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      _confirmSignatureDialog();
                    },
                  )),
        SizedBox(width: 10),
        //The viewing date is the signing date.
        hasSigned
            ? Expanded(
                child: Text(
                    'Signing Date: ${DateTime.now().toIso8601String().substring(0, 10)}'))
            : Expanded(child: Text('Signing Date: Awaiting Signature'))
      ],
    );
  }

  void signContract() {
    setState(() {
      _hasSigned = true;
    });
  }

  Signature createSignatureObject(String contractId) {
    return Signature(
      contractId: contractId,
      contractorId: widget.user.id,
      createDate: DateTime.now(),
      signatureText: signatureController.text
    );
  }

  Widget otherContractorSignatureField(int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Signature of Contractual Party-${index + 1}:',
            style: TextStyle(fontSize: 15)),
        SizedBox(width: 10),
        Expanded(
          child: MaterialButton(
            elevation: 0,
            enableFeedback: false,
            child: Text(
                "${addedContractors[index].name} must sign on their behalf",
                style: TextStyle(fontSize: 15, color: Colors.grey)),
            color: Colors.grey,
            onPressed: null,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        SizedBox(width: 10),
        Spacer()
      ],
    );
  }

  List<Widget> displayAllTerms() {
    List<Widget> widgets = [];
    int index = 0;
    _termMap.values.forEach((element) {
      widgets.add(termInfo(element, index));
      widgets.add(SizedBox(height: 20));
      index++;
    });
    return widgets;
  }

  List<Widget> displayATermsObligations(Term term) {
    List<Widget> widgets = [];
    int index = 0;
    _obligationMap.values.forEach((element) {
      if (element.term.termTypeId == term.termTypeId) {
        widgets.add(obligationInfo(element, index));
        widgets.add(SizedBox(height: 20));
        index++;
      }
    });
    return widgets;
  }

  Widget termInfo(TermWidget termWidget, int index) {
    return Column(
      children: [
        Text("${index + 1} ${termWidget.term.name}",
            style:
                TextStyle(fontSize: 20, decoration: TextDecoration.underline)),
        SizedBox(height: 10),
        Text("${termWidget.textController.text}", textAlign: TextAlign.justify),
        SizedBox(height: 10),
        Column(
          children: displayATermsObligations(termWidget.term),
        )
      ],
    );
  }

  Widget obligationInfo(ObligationWidget obligationWidget, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Clause-${index + 1}:", style: TextStyle(fontSize: 15)),
        SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Description: ${obligationWidget.textController.text}",
                textAlign: TextAlign.justify),
            Text(
                "Execution Date: ${obligationWidget.obligation.getExecutionDateAsString()}"),
            Text(
                "End Date: ${obligationWidget.obligation.getEndDateAsString()}"),
          ],
        ),
      ],
    );
  }

  Widget _wideScreenDateButtonsLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(flex: 2, child: effectiveDateButton()),
        Spacer(),
        Expanded(
          flex: 2,
          child: executionDateButton(),
        ),
        Spacer(),
        Expanded(
          flex: 2,
          child: endDateButton(),
        ),
      ],
    );
  }

  Widget _slimScreenDateButtonsLayout() {
    return Column(
      children: [
        effectiveDateButton(),
        SizedBox(height: 10),
        executionDateButton(),
        SizedBox(height: 10),
        endDateButton(),
      ],
    );
  }

  //------------------- CONTRACTOR FIELDS ---------------------------------------
  Form contractorInfoFieldForm(int index, String fieldText, String fieldHint) {
    return Form(
      key: step2Keys[index],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$fieldText", style: TextStyle(fontSize: 15)),
          SizedBox(height: 5),
          TextFormField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.blue)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.black, width: 1.0)),
            ),
            style: TextStyle(fontSize: 15),
            controller: contractorControllers[index],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$fieldHint';
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  Widget contractorFieldSuggestor(int index) {
    return Form(
      key: step2Keys[index],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Name", style: TextStyle(fontSize: 15)),
          SizedBox(height: 5),
          Autocomplete(
            displayStringForOption: _displayStringForOption,
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<User>.empty();
              }
              return contractors.where((User option) {
                return option
                    .toString()
                    .contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (User selection) {
              if (!addedContractors.contains(selection)) {
                _fillRequesterForm(selection, index);
                addedContractors.insert(currentContractorIndex, selection);
                print("insert response");
              }
            },
            fieldViewBuilder: (BuildContext context,
                TextEditingController fieldTextEditingController,
                FocusNode fieldFocusNode,
                VoidCallback onFieldSubmitted) {
              fieldTextEditingController.text =
                  contractorControllers[index].text;
              return TextField(
                controller: fieldTextEditingController,
                focusNode: fieldFocusNode,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      borderSide: BorderSide(color: Colors.blue)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      borderSide: BorderSide(color: Colors.black, width: 1.0)),
                ),
                style: TextStyle(fontSize: 15),
              );
            },
          )
        ],
      ),
    );
  }

  static String _displayStringForOption(User option) => option.name!;

  Widget contractorEmailField(int index) {
    return contractorInfoFieldForm(index, "E-mail:", "Please enter an e-mail.");
  }

  Widget contractorAddressField(int index) {
    return contractorInfoFieldForm(
        index, "House Number and Street Name:", "Please enter an address.");
  }

  Widget contractorCSCDropDownList(int index) {
    return CountryStateCityPicker(
      country: contractorControllers[index],
      state: contractorControllers[index + 1],
      city: contractorControllers[index + 2],
      textFieldInputBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2.0),
          borderSide: BorderSide(color: Colors.black, width: 2.0)),
    );
  }

  Widget contractorPhoneField(int index) {
    return contractorInfoFieldForm(
        index, "Phone number:", "Please enter a phone number.");
  }

  //------------------- CONTRACT FIELDS ----------------------------------------
  Widget descriptionField() {
    return Form(
      key: _step4Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("What are the Terms & Conditions of the Contract?",
              style: TextStyle(fontSize: 15)),
          TextFormField(
            controller: descriptionController,
            maxLines: null,
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

  Widget titleField() {
    return Form(
      key: step1Key,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("What is the title of your contract?",
              style: TextStyle(fontSize: 15)),
          SizedBox(height: 5),
          TextFormField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.blue)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.black, width: 1.0)),
            ),
            controller: titleController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title for your contract.';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          Text("What is the consideration of your contract?",
              style: TextStyle(fontSize: 15)),
          SizedBox(height: 5),
          TextFormField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.blue)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.black, width: 1.0)),
            ),
            controller: considerationDescController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a consideration for your contract.';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          Text("What is the value of your contract?",
              style: TextStyle(fontSize: 15)),
          SizedBox(height: 5),
          TextFormField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.blue)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.black, width: 1.0)),
            ),
            controller: considerationValController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a value for your contract.';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget contractTypeDropDown() {
    return Column(
      children: [
        Text("What type of contract is being formed?",
            style: TextStyle(fontSize: 15)),
        DropdownButton(
            items: contractTypes,
            hint: Text("Select a type"),
            value: contractType,
            onChanged: (String? value) {
              setState(() {
                contractType = value!;
              });
            })
      ],
    );
  }

  Widget contractCategoryDropDown() {
    return Column(
      children: [
        Text("What is the category of your contract?",
            style: TextStyle(fontSize: 15)),
        DropdownButton(
            items: contractCategories,
            hint: Text("Select a category"),
            value: contractCategory,
            onChanged: (String? value) {
              setState(() {
                contractCategory = value!;
              });
            })
      ],
    );
  }

  removeTermWidget(String id) {
    setState(() {
      _obligationMap
          .removeWhere((key, value) => value.term.id == _termMap[id]!.term.id);
      _termMap.remove(id);
    });
    validateStepFour();
    validateStepObligation();
  }

  removeObligationWidget(String id) {
    setState(() {
      _obligationMap.remove(id);
    });
    validateStepObligation();
  }

  Widget effectiveDateButton() {
    return Container(
      height: 50,
      child: MaterialButton(
        color: Colors.blue,
        hoverColor: Colors.lightBlueAccent,
        child: effectiveDate == null
            ? Text("Pick an Effective Date",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center)
            : Text("Effective Date: ${_formatDate(effectiveDate)}",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center),
        onPressed: () => chooseEffectiveDate(),
      ),
    );
  }

  Widget endDateButton() {
    return Container(
      height: 50,
      child: MaterialButton(
        color: Colors.blue,
        hoverColor: Colors.lightBlueAccent,
        child: endDate == null
            ? Text("Pick an End Date",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center)
            : Text("End Date: ${_formatDate(endDate)}",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center),
        onPressed: () => chooseEndDate(),
      ),
    );
  }

  Widget executionDateButton() {
    return Container(
      height: 50,
      child: MaterialButton(
        color: Colors.blue,
        hoverColor: Colors.lightBlueAccent,
        child: executionDate == null
            ? Text("Pick an Execution Date",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center)
            : Text("Execution Date: ${_formatDate(executionDate)}",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center),
        onPressed: () => chooseExecutionDate(),
      ),
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
        effectiveDate != null &&
        pickedDate.isAfter(effectiveDate!)) {
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
      child: MaterialButton(
        minWidth: 125,
        onPressed: () {
          setState(() {
            if (contractStep < 5) {
              setNextStep();
            }
          });
        },
        color: Colors.blue,
        hoverColor: Colors.lightBlue,
        child: Text("Next Step", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget createContractButton() {
    return Container(
      child: MaterialButton(
        minWidth: 125,
        onPressed: () async {
          _showCreatingDialog();
          await performContractCreation();
          _dismissDialog();
        },
        color: Colors.green,
        hoverColor: Colors.lightGreen,
        child: Text("Create Contract", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Future<void> performContractCreation() async {
    _toggleLoading();
    setBaseContractDetails();
    //create contract
    contract.contractId = await dataProvider.createBaseContract(contract);
    //add signature if already signed by contract creator
    if (_hasSigned) {
      Signature tmpSignature = await dataProvider.createSignature(createSignatureObject(contract.contractId!));
      contract.signatures.add(tmpSignature.id!);
    }
    //create a term associated to the created base contract.
    _termMap.forEach((key, value) async {
      Term tempTerm = await dataProvider.createTerm(contract.contractId!,
          value.textController.text, value.term.termTypeId!);
      value.term.id = tempTerm.id;
      contract.terms.add(tempTerm.id!);
      //create an obligation associated to the previously created term
      _obligationMap.forEach((key, obl) async {
        if (obl.term.termTypeId == value.term.termTypeId) {
          obl.obligation.termId = value.term.id;
          obl.obligation.contractorId = obl.selectedContractor!.id;
          obl.obligation.description = obl.textController.text;
          obl.obligation.state = "statePending";
          obl.obligation.contractId = contract.contractId;
          Obligation tmpObligation =
              await dataProvider.createObligation(contract, obl.obligation);
          contract.obligations.add(tmpObligation.id!);
          await dataProvider.updateContract(contract);
        }
        if (contract.obligations.length == _obligationMap.values.length) {
          //all obligations have been added, stop loading
          _toggleLoading();
          //navigate to contract viewing page
          widget.changeScreen(2, '${contract.contractId!}');
        }
      });
    });
  }

  void _toggleLoading() {
    setState(() {
      loading = !loading;
    });
  }

  Widget previousStepButton() {
    return Container(
      child: MaterialButton(
        minWidth: 125,
        onPressed: () {
          setState(() {
            if (contractStep > 1) {
              contractStep--;
            }
          });
        },
        color: Colors.blue,
        hoverColor: Colors.lightBlue,
        child: Text("Previous Step", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget confirmEditButton() {
    //TODO: adjust to new api
    return Container(
        child: MaterialButton(
            color: Colors.grey,
            hoverColor: Colors.blueGrey,
            child:
                Text("Confirm Changes", style: TextStyle(color: Colors.white)),
            onPressed: () {
              print("Original contract ID: ${widget.contract!.contractId!}");
              setState(() {
                widget.contract = tmpContract;
                print("Modified contract ID: ${widget.contract!.contractId!}");
              });
              widget.toggleEditing!(null);
            }));
  }

  Widget addContractorButton() {
    return Tooltip(
      message: "Add another contracting party.",
      child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue,
          child: IconButton(
              icon: Icon(Icons.person_add),
              onPressed: () {
                setState(() {
                  addContractor();
                });
              })),
    );
  }

  Widget removeContractorButton() {
    return Tooltip(
        message: "Remove this contracting party.",
        child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue,
            child: IconButton(
                icon: Icon(Icons.person_remove),
                onPressed: () {
                  setState(() {
                    removeContractor(currentContractorIndex);
                  });
                })));
  }

  Widget nextContractorButton() {
    return Tooltip(
        message: "Proceed to the next contractor form.",
        child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue,
            child: IconButton(
                icon: Icon(Icons.navigate_next),
                onPressed: () {
                  setState(() {
                    currentContractorIndex += 1;
                  });
                })));
  }

  Widget previousContractorButton() {
    return Tooltip(
        message: "Go back to the previous contractor form.",
        child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue,
            child: IconButton(
                icon: Icon(Icons.navigate_before),
                onPressed: () {
                  setState(() {
                    currentContractorIndex -= 1;
                  });
                })));
  }

  Widget addTermButton() {
    return PopupMenuButton(
      tooltip: "Add a term",
      child: Icon(Icons.add),
      onSelected: (TermType termType) {
        //getTerm(termTypeId.toString());
        createTerm(termType);
      },
      itemBuilder: (BuildContext context) {
        return _termTypeList.map((TermType element) {
          return PopupMenuItem<TermType>(
              value: element, child: Text(element.name!));
        }).toList();
      },
    );
  }

  Widget addObligationButton() {
    List<PopupMenuItem> items = [];
    return PopupMenuButton(
      tooltip: "Add a clause",
      child: Icon(Icons.add),
      onSelected: (Term term) {
        addObligation(term);
      },
      itemBuilder: (BuildContext context) {
        return _termMap.values.map((TermWidget tw) {
          return PopupMenuItem<Term>(
              value: tw.term, child: Text(tw.term.name!));
        }).toList();
      },
    );
  }

  void addObligation(Term term) {
    setState(() {
      //Must be unique, otherwise deletion of all obligations with same termId
      String id = UniqueKey().toString();
      _obligationMap.putIfAbsent(
          id,
          () => ObligationWidget(term, "SAMPLE NAME", addedContractors,
              removeObligationWidget, id, effectiveDate, endDate));
    });
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
            Text(name,
                textAlign: TextAlign.center, style: TextStyle(fontSize: 10))
          ],
        ));
  }

  /// Function to dynamically display the correct amount of signature fields
  /// according to the amount of parties involved. [userList] is used to
  /// display the signatureFields for that type of users in that list.
  Widget displaySignatureFields(List<dynamic> userList) {
    List<Widget> fields = [];
    for (int i = 0; i < userList.length; i += 7) {
      fields.add(signatureField(userList[i].text));
    }

    return Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: fields.length,
            itemBuilder: (BuildContext context, int index) {
              return fields[index];
            }));
  }

  /// Helper function to display contract value without the uri. This is just
  /// a DISPLAY function. It does NOT remove the uri in the value.
  String displayStringWithoutUri(String s) {
    return s.replaceAll('http://ontologies.atb-bremen.de/smashHitCore#', '');
  }

  void setNextStep() {
    switch (contractStep) {
      case 1:
        if (validateStepOne()) {
          incrementContractStep();
        }
        break;
      case 2:
        if (validateStepTwo()) {
          incrementContractStep();
        }
        break;
      case 3:
        if (validateStepFour()) {
          incrementContractStep();
        }
        break;
      case 4:
        if (validateStepObligation()) {
          incrementContractStep();
        }
        break;
    }
  }

  void incrementContractStep() {
    setState(() {
      contractStep++;
    });
  }

  void setStepOne() {
    setState(() {
      contractStep = 1;
    });
  }

  void setStepTwo() {
    validateStepOne();
  }

  void setStepFour() {
    validateStepTwo();
  }

  void setStepObligation() {
    validateStepFour();
  }

  void setStepFinal() {
    validateStepFour();
    if (stepOneComplete &&
        stepTwoComplete &&
        stepFourComplete &&
        stepObligationComplete) {
    } else {
      //Display dialog to notify user that the contract has not been completed.
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
                Center(
                    child: Icon(Icons.warning, size: 60, color: Colors.yellow)),
                Container(height: 10),
                Text(
                    'You have not filled out all contract details. Please complete the form before you move on to the final step.\nRevisit the following steps:'),
                Container(height: 10),
                stepOneComplete
                    ? Container()
                    : Text('-    Step 1. Contract Base Information'),
                Container(height: 5),
                stepTwoComplete
                    ? Container()
                    : Text('-    Step 2. Data Controller(s) Details'),
                Container(height: 5),
                stepFourComplete
                    ? Container()
                    : Text('-    Step 4. Terms & Conditions of the Contract'),
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

  void showStep1NotCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Icon(Icons.warning, size: 60, color: Colors.yellow)
              ),
              SizedBox(height: 10),
              Text('Please fill out the following details to continue:'),
              contractCategory == null
                ? Text('-    Select A Contract Category')
                : Container(),
              contractType == null
                  ? Text('-    Select A Contract Type')
                  : Container(),
              effectiveDate == null
                  ? Text('-    Select An Effective Date')
                  : Container(),
              executionDate == null
                  ? Text('-    Select An Execution Date')
                  : Container(),
              endDate == null
                  ? Text('-    Select An End Date')
                  : Container(),
            ]
          ),
          children: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              }
            )
          ],
        );
      }
    );
  }

  void showStep2NotCompleteDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Icon(Icons.warning, size: 60, color: Colors.yellow)
                  ),
                  SizedBox(height: 10),
                  Text('Please fill out the following details to continue:'),
                  addedContractors.length == 0
                      ? Text('-    You have no contracting parties. Please add at least 2 or more contracting parties to the contract.')
                      : Container(),
                  addedContractors.length == 1
                      ? Text('-    You only have one contracting party in the contract. Please add at least 1 or more contracting parties to the contract.')
                      : Container(),
                ]
            ),
            children: <Widget>[
              TextButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
              )
            ],
          );
        }
    );
  }

  void showStep3NotCompleteDialog(bool? flag) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Icon(Icons.warning, size: 60, color: Colors.yellow)
                  ),
                  SizedBox(height: 10),
                  Text('Please fill out the following details to continue:'),
                  _termMap.keys.isEmpty
                      ? Text('-    You have not added any terms to the contract. Please add at least 1 term to the contract.')
                      : Container(),
                  flag != null
                      ? Text('-    Not all terms contain text. Please fill out the text for each term added to the contract.')
                      : Container(),
                ]
            ),
            children: <Widget>[
              TextButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
              )
            ],
          );
        }
    );
  }

  Future<void> getTermType() async {
    _termTypeList.clear();
    var jsonString = await rootBundle.loadString('assets/term_type.json');
    List<dynamic> body = jsonDecode(jsonString);
    setState(() {
      _termTypeList = body.map((dynamic e) => TermType.fromJson(e)).toList();
    });
  }

  Future<void> fetchAllContractors() async {
    contractors = await dataProvider.fetchAllUsers();
  }

  Future<void> fetchAllTermTypes() async {
    _termTypeList = await dataProvider.fetchAllTermTypes();
  }

  Future<void> getTerm(String termTypeId) async {
    List<Term> tempTerms = [];
    var jsonString = await rootBundle.loadString('assets/term.json');
    List<dynamic> body = jsonDecode(jsonString);

    tempTerms = body.map((dynamic e) => Term.fromTemplateJson(e)).toList();
    tempTerms.forEach((element) {
      if (element.termTypeId == termTypeId) {
        setState(() {
          String id = UniqueKey().toString();
          _termMap.putIfAbsent(
              id,
              () =>
                  //termWidget(element, id)
                  TermWidget(element, removeTermWidget, id));
        });
      }
    });
  }

  void createTerm(TermType termType) {
    //Create term based on termType
    Term term = new Term(
      name: termType.name,
      termTypeId: termType.id,
      description: termType.description,
    );
    //Add created term into map with the id so that deleting it is easy.
    setState(() {
      String id = termType.id!;
      _termMap.putIfAbsent(id, () => TermWidget(term, removeTermWidget, id));
    });
  }

  _showCreatingDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Loading...', textAlign: TextAlign.center),
            contentPadding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
            children: [
              Icon(Icons.schedule, color: Colors.grey, size: 100),
              Text('Your contract is being created.',
                  textAlign: TextAlign.center),
              Container(height: 5),
              Center(child: CircularProgressIndicator())
            ],
          );
        });
  }

  _confirmSignatureDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Your Signature", textAlign: TextAlign.center),
          contentPadding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: _signatureKey,
                child: TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2.0),
                        borderSide: BorderSide(color: Colors.blue)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2.0),
                        borderSide: BorderSide(color: Colors.black, width: 1.0)),
                  ),
                  style: TextStyle(fontSize: 15),
                  controller: signatureController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a signature text to confirm your signature.";
                    }
                    return null;
                  },
                ),
              )
            ],
          ),
          actions: [
            MaterialButton(
              child: Text('Cancel'),
              onPressed: () {
                _dismissDialog();
              },
            ),
            MaterialButton(
              child: Text('Agree & Sign Contract', style: TextStyle(color: Colors.white)),
              color: Colors.blue,
              onPressed: () {
                if (_signatureKey.currentState!.validate() == true) {
                  signContract();
                  _dismissDialog();
                }
              },
            ),
          ],
        );
      }
    );
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
              Text('The contract was successfully created!',
                  textAlign: TextAlign.center),
              Container(height: 5),
              MaterialButton(
                child: Text('Okay'),
                onPressed: () {
                  _dismissDialog();
                },
              ),
            ],
          );
        });
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
                  _dismissDialog();
                },
              ),
            ],
          );
        });
  }

  void _fillRequesterForm(User selected, int index) {
    contractorControllers[index].text =
        selected.name == null ? 'No name found' : selected.name!;
    contractorControllers[index + 1].text =
        selected.email == null ? 'No email found' : selected.email!;
    contractorControllers[index + 2].text = selected.streetAddress == null
        ? 'No street address found'
        : selected.streetAddress!;
    contractorControllers[index + 3].text =
        selected.country == null ? 'No country found' : selected.country!;
    //State was unexpectedly removed from backend. Set to temporary not required for a contract agreement.
    contractorControllers[index + 4].text = 'State Currently Not Required';
    contractorControllers[index + 5].text =
        selected.city == null ? 'No city found' : selected.city!;
    contractorControllers[index + 6].text =
        selected.phone == null ? 'No phone number found' : selected.phone!;
  }

  bool validateStepOne()  {
    //Check if form is completed by user.
    var flag = step1Key.currentState!.validate() == true;
    if (flag &&
        contractCategory != null &&
        contractType != null &&
        effectiveDate != null &&
        executionDate != null &&
        endDate != null) {
      setState(() {
        stepOneComplete = true;
      });
      return true;
    } else {
      setState(() {
        stepOneComplete = false;
      });
      //Only display completion dialog if the form is complete.
      if(flag) {
        showStep1NotCompleteDialog();
      }
      return false;
    }
  }

  void setBaseContractDetails() {
    contract.considerationDescription = considerationDescController.text;
    contract.considerationValue = considerationValController.text;
    contract.contractCategory = contractCategory;
    contract.contractStatus = "hasCreated";
    contract.contractType = contractType;
    for (User user in addedContractors) {
      contract.contractors.add(user.id);
    }
    contract.effectiveDate = effectiveDate;
    contract.endDate = endDate;
    contract.executionDate = executionDate;
    contract.purpose = titleController.text;
  }

  /// In the [contractors] list all of the existing contractors in the system
  /// are listed. After the user sets enters the contractor's details in the UI
  /// the contractor's ID must be attained based on the email entered.
  void setContractor(String email) {
    String id = contractors
        .firstWhere(
            (User contractor) => contractor.email!.compareTo(email) == 0)
        .id!;
    contract.contractors.add(id);
  }

  /// Function that checks every textFormField in the second step of the
  /// contract to validate if each field has content in it.
  bool validateStepTwo() {
    var flag = true;
    if (addedContractors.length >= 2) {
      setState(() {
        stepTwoComplete = true;
      });
      return true;
    } else {
      setState(() {
        stepTwoComplete = false;
      });
      showStep2NotCompleteDialog();
      return false;
    }
  }

  bool validateStepObligation() {
    bool textFlag = true;
    bool dateFlag = true;
    bool contractorFlag = true;
    if (_obligationMap.keys.isNotEmpty) {
      _obligationMap.values.forEach((element) {
        if (textFlag && dateFlag && contractorFlag) {
          textFlag = element.textController.text.isNotEmpty;
          dateFlag = obligationHasBothDates(element);
          contractorFlag = element.selectedContractor != null;
        }
      });
      if (textFlag && dateFlag && contractorFlag) {
        setState(() {
          stepObligationComplete = true;
        });
        return true;
      } else {
        setState(() {
          stepObligationComplete = false;
        });
        return false;
      }
    } else {
      setState(() {
        stepObligationComplete = false;
      });
      return false;
    }
  }

  bool obligationHasBothDates(ObligationWidget ow) {
    if (ow.obligation.executionDate == null || ow.obligation.endDate == null) {
      return false;
    } else {
      return true;
    }
  }

  /// Function that checks every textFormField in the fourth step of the
  /// contract to validate if each field has content in it.
  /// Checked fields:
  ///   - Terms & Conditions Field
  bool validateStepFour() {
    bool flag = true;
    if (_termMap.keys.isNotEmpty) {
      _termMap.values.forEach((element) {
        if (flag) {
          flag = element.textController.text.isNotEmpty;
        }
      });
      if (flag) {
        setState(() {
          stepFourComplete = true;
        });
        return true;
      } else {
        setState(() {
          stepFourComplete = false;
        });
        showStep3NotCompleteDialog(flag);
        return false;
      }
    } else {
      setState(() {
        stepFourComplete = false;
      });
      showStep3NotCompleteDialog(null);
      return false;
    }
  }

  bool _isWideScreen(double width, double height) {
    if (width < height) {
      return false;
    } else {
      return true;
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

  /// Helper function to add a new contractor into the form. Each contractor has
  /// 7 TextFields. That is why we add 7 TextEditingController, one for each
  /// field.
  void addContractor() {
    setState(() {
      addedContractorsIndex++;
      addStep2Keys();
      for (int i = 0; i < 7; i++) {
        contractorControllers.add(TextEditingController());
      }
    });
  }

  /// Helper function to remove a contractor form. Each contractor has 7
  /// TextFields. That is why we remove 7 TextEditingControllers.
  /// [index] represents the current selected contractor.
  void removeContractor(int index) {
    setState(() {
      for (int i = (index * 7) + 6; i >= (index * 7); i--) {
        contractorControllers.removeAt(i);
      }
      addedContractors.removeAt(index);
      addedContractorsIndex -= 1;
      currentContractorIndex -= 1;
    } );
  }

  /// Helper function to add 6 keys to validate each textFormField in the
  /// second step of the contract creation.
  void addStep2Keys() {
    setState(() {
      for (int i = 0; i < 7; i++) {
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

  _dismissDialog() {
    Navigator.pop(context);
  }
}
