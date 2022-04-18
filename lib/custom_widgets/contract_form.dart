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
  TextEditingController considerationDescController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController considerationValController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<TextEditingController> contractorControllers = [];
  List<TextEditingController> requesterControllers = [];
  List<TextEditingController> providerControllers = [];
  List<TextEditingController> termControllers = [];
  String? contractDropDownType;
  User user;

  ContractForm(this.changeScreen, this.step, this.contract, this.user, [this.toggleEditing]);

  @override
  _ContractFormState createState() => new _ContractFormState();
}

class _ContractFormState extends State<ContractForm> {

  //------------------- General Variables --------------------------------------
  DateTime? startDate;
  DateTime? effectiveDate;
  DateTime? endDate;
  DateTime? executionDate;

  String? contractType;
  String? contractCategory;

  DataProvider dataProvider = DataProvider();

  //------------------- StepNavigation Booleans --------------------------------
  bool toggleStepOne = true;
  bool toggleStepTwo = false;
  bool toggleStepFour = false;
  bool toggleStepObligation = false;
  bool toggleStepFinal = false;

  //------------------- StepValidation Booleans --------------------------------
  bool stepOneComplete = false;
  bool stepTwoComplete = false;
  bool stepObligationComplete = false;
  bool stepFourComplete = false;

  //------------------- Validation Keys ----------------------------------------
  final step1Key = GlobalKey<FormState>();
  List<GlobalKey<FormState>> step2Keys = [];
  List<GlobalKey<FormState>> step3Keys = [];
  final _step4Key = GlobalKey<FormState>();

  //------------------- Other Variables ----------------------------------------
  static List<User> contractors = [];
  int currentContractorIndex = 0;
  int addedContractorsIndex = 0;
  Contract? tmpContract;
  List<TermType> _termTypeList = [];
  Map<String, TermWidget> _termList = {};
  Contract contract = new Contract();


  @override
  void initState() {
    super.initState();

    //get existing termTypes
    getTermType();

    // Add at least one contractor
    addContractor();
    // Fetch all existing contractors for the suggestion field
    fetchAllContractors();

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
    double screenHeight = MediaQuery.of(context).size.height;
    double formWidth = screenWidth * (_isWideScreen(screenWidth, screenHeight)? 0.7 : 1);

    return Stack(children: [
      Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                contractStepOne(formWidth),
                contractStepTwo(formWidth),
                contractStepFour(formWidth),
                contractStepObligation(formWidth),
                contractStepFinal(formWidth),
              ])),
      Align(
        alignment: Alignment.bottomRight,
        child: widget.contract != null? Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            nextStepButton(),
            SizedBox(height: 10),
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
        toggleStepOne == true
            ? ContractStepBody(
            width: width,
            children: [
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
            name: "Step 2. Add Contractors",
            stepComplete: stepTwoComplete,
            onPressed: () async {
              setStepTwo();
            }),
        toggleStepTwo == true
            ? ContractStepBody(
            width: width,
            children: [
              Text("Add Contractor ${currentContractorIndex + 1}",
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
    return Column(
      children: [
        ContractStepHeader(
            width: width,
            name: "Step 4. Terms & Conditions of the Contract",
            stepComplete: stepFourComplete,
            onPressed:  () {
              setStepFour();
            }
        ),
        toggleStepFour == true
          ? ContractStepBody(
            width: width,
            children: [
              Text("Add Terms to Your Contract", style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _termList.length,
                  itemBuilder: (BuildContext context, int index) {
                    String key = _termList.keys.elementAt(index);
                    return _termList[key]!;
                  }
              ),
              Text("Add a term to the contract"),
              addTermButton(),
            ]
        )
            : Container()
      ]
    );

  }

  Widget contractStepObligation(double width) {
    return Column(
      children: [
        ContractStepHeader(
            width: width,
            name: "Step 4. Obligations of the Contract",
            onPressed: () async {
              setStepObligation();
            }),
        toggleStepObligation == true
          ? ContractStepBody(
              width: width,
              children: _termList.keys.length > 0? [
                Text("You have ${_termList.keys.length} term(s), you can add obligations to each term.", style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                addObligationButton(),
              ] : [
                Text("You have not added any terms in the previous step. To add obligations you must have terms in your contract.", style: TextStyle(fontSize:20)),
              ]
        )
          : Container()
      ]
    );
  }

  Widget contractStepFinal(double width) {
    return Column(
      children: [
        ContractStepHeader(
            width: width,
            name: "Final Step - Overview",
            onPressed: () => setStepFinal()
        ),
        toggleStepFinal == true
            ? ContractStepBody(
            width: width,
            children: [
              Text('${widget.titleController.text}',
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
                child: Text("Consideration: ${widget.considerationDescController.text}"),
                alignment: Alignment.centerLeft
              ),
              SizedBox(height: 10),
              Column(
                children: displayAllTerms(),
              ),
              SizedBox(height: 10),
              Align(
                child: Text("Contract Category: $contractCategory", style: TextStyle(fontSize: 15)),
                alignment: Alignment.centerLeft
              ),
              SizedBox(height: 10),
              contractDates()
            ]
        )
            : Container()
      ],
    );
  }

  Widget contractDates() {
    return Row(
      children: [
        Expanded(child: Text("Effective Date: ${_formatDate(effectiveDate)}", textAlign: TextAlign.center)),
        Expanded(child: Text("Execution Date: ${_formatDate(executionDate)}", textAlign: TextAlign.center)),
        Expanded(child: Text("End Date: ${_formatDate(endDate)}", textAlign: TextAlign.center)),
      ],
    );
  }

  List<Widget> displayAllContractorsInfo() {
    List<Widget> widgets = [];
    for (int i = 0; i < addedContractorsIndex; i++) {
      widgets.add(contractorInfo(i));
      widgets.add(SizedBox(height: 10));
    }
    return widgets;
  }

  Widget contractorInfo(int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contractor-${index+1}:', style: TextStyle(fontSize: 15)),
        SizedBox(width: 5),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${widget.contractorControllers[index * 7 + 0].text}"),
            Text("${widget.contractorControllers[index * 7 + 1].text}"),
            Text("${widget.contractorControllers[index * 7 + 2].text}"),
            Text("${widget.contractorControllers[index * 7 + 3].text}"),
            Text("${widget.contractorControllers[index * 7 + 4].text}"),
            Text("${widget.contractorControllers[index * 7 + 5].text}"),
            Text("${widget.contractorControllers[index * 7 + 6].text}"),
          ],
        )
      ],
    );
  }

  List<Widget> displayAllTerms() {
    List<Widget> widgets = [];
    int index = 0;
    _termList.values.forEach((element) {
      widgets.add(termInfo(element, index));
      widgets.add(SizedBox(height: 20));
      index++;
    });
    return widgets;
  }

  Widget termInfo(TermWidget termWidget, int index) {
    return Column(
      children: [
        Text("${index+1} ${termWidget.term.name}", style: TextStyle(fontSize: 20, decoration: TextDecoration.underline)),
        SizedBox(height: 10),
        Text("${termWidget.textController.text}", textAlign: TextAlign.justify),
      ],
    );
  }

  Widget _wideScreenDateButtonsLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Column(
            children: [
              effectiveDate == null
                  ? Container()
                  : Text("Chosen Effective Date:"),
              effectiveDateButton(),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              executionDate == null
                  ? Container()
                  : Text("Chosen Execution Date:"),
              executionDateButton(),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              endDate == null ? Container() : Text("Chosen End Date:"),
              endDateButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _slimScreenDateButtonsLayout() {
    return Column(
      children: [
        Column(
          children: [
            effectiveDate == null
                ? Container()
                : Text("Chosen Effective Date:"),
            effectiveDateButton(),
          ],
        ),
        SizedBox(height: 10),
        Column(
          children: [
            executionDate == null
                ? Container()
                : Text("Chosen Execution Date:"),
            executionDateButton(),
          ],
        ),
        SizedBox(height: 10),
        Column(
          children: [
            endDate == null ? Container() : Text("Chosen End Date:"),
            endDateButton(),
          ],
        ),
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
          Text(
              "$fieldText",
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
            style: TextStyle(fontSize: 15),
            controller: widget.contractorControllers[index],
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
          Text(
              "Name", style: TextStyle(fontSize: 15)),
          SizedBox(height: 5),
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
              fieldTextEditingController.text = widget.contractorControllers[index].text;
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
    return contractorInfoFieldForm(index, "House Number and Street Name:", "Please enter an address.");
  }

  Widget contractorCSCDropDownList(int index) {
    return CountryStateCityPicker(
      state: widget.contractorControllers[index],
      city: widget.contractorControllers[index + 1],
      country: widget.contractorControllers[index + 2],
      textFieldInputBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2.0),
          borderSide: BorderSide(color: Colors.black, width: 2.0)),
    );
  }

  Widget contractorPhoneField(int index) {
    return contractorInfoFieldForm(index, "Phone number:", "Please enter a phone number.");
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
            controller: widget.descriptionController,
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
            controller: widget.titleController,
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
            controller: widget.considerationDescController,
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
            controller: widget.considerationValController,
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
        Text("What type of contract is being formed?", style: TextStyle(fontSize: 15)),
        DropdownButton(
            items: contractTypes,
            hint: Text("Select a type"),
            value: contractType,
            onChanged: (String? value) {
              setState(() {
                contractType = value!;
              });
            }
        )
      ],
    );
  }

  Widget contractCategoryDropDown() {
    return Column(
      children: [
        Text("What is the category of your contract?", style: TextStyle(fontSize: 15)),
        DropdownButton(
            items: contractCategories,
            hint: Text("Select a category"),
            value: contractCategory,
            onChanged: (String? value) {
              setState(() {
                contractCategory = value!;
              });
            }
        )
      ],
    );
  }

  removeTermWidget(String index) {
    setState(() {
      _termList.remove(index);
    });
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

  Widget startDateButton() {
    return Container(
      height: 50,
      child: MaterialButton(
        color: Colors.blue,
        hoverColor: Colors.lightBlueAccent,
        child: startDate == null
            ? Text("Pick a Start Date",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center)
            : Text(_formatDate(startDate),
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center),
        onPressed: () => chooseStartDate(),
      ),
    );
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
            : Text(_formatDate(effectiveDate),
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
            : Text(_formatDate(endDate),
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
            : Text(_formatDate(executionDate),
                style: TextStyle(color: Colors.white),
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
          color: Colors.green,
          hoverColor: Colors.lightGreen,
          child: toggleStepFinal == true
              ? Text('Confirm & Submit',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center)
              : toggleStepFour == true
                  ? Text("Go To Overview",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center)
                  : Text("Next Step",
                      style: TextStyle(color: Colors.white)),
          onPressed: () async {
            if (toggleStepOne == true) {
              setStepTwo();
            } else if (toggleStepTwo == true) {
              setStepFour();
            } else if (toggleStepFour == true) {
              setStepObligation();
            } else if (toggleStepObligation == true) {
              setStepFinal();
            } else if (toggleStepFinal == true) {
              setState(() {
                toggleStepFinal = false;
              });
              Contract createdContract = createContractObject();
              if (await dataProvider.createContract(createdContract)) {
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

  Contract createContractObject() {
    return Contract(
      contractId: widget.titleController.text,
      purpose: widget.descriptionController.text,
      contractType: contractType,
      executionDate: startDate!,
      endDate: endDate!
    );
  }

  Widget confirmEditButton() {
    //TODO: adjust to new api
    return Container(
      child: MaterialButton(
        color: Colors.grey,
        hoverColor: Colors.blueGrey,
        child: Text("Confirm Changes", style: TextStyle(color: Colors.white)),
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
        child: MaterialButton(
          color: Colors.grey,
          hoverColor: Colors.blueGrey,
          child: Text("Previous Step",
              style: TextStyle(color: Colors.white)),
          onPressed: () {
            setState(() {
              if (toggleStepOne == true) {
                setStepOne();
              } else if (toggleStepTwo == true) {
                setStepOne();
              } else if (toggleStepFour == true) {
                setStepTwo();
              } else if (toggleStepObligation == true) {
                setStepFour();
              } else if (toggleStepFinal == true) {
                setStepObligation();
              }
            });
          },
        ));
  }

  Widget addContractorButton() {
    return Tooltip(
      message: "Add another contractor.",
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
        message: "Remove this data controller.",
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
        onSelected: (termTypeId) {
          getTerm(termTypeId.toString());
        },
        itemBuilder: (BuildContext context) {
          return _termTypeList.map((element) {
            return PopupMenuItem<Object>(
              value: element.id,
              child: Text(element.name!)
            );
          }).toList();
        },
    );
  }

  Widget addObligationButton() {
    List<PopupMenuItem> items = [];
    return PopupMenuButton(
      tooltip: "Add an obligation",
      child: Icon(Icons.add),
      onSelected: (value) {
        print("first selection $value");
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<Object>(
              value: "value",
              child: PopupMenuButton(
                child: Text("nested button"),
                onSelected: (e) {
                  Text("second selection $e");
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(child: Text("item nested"),value: "second",)
                  ];
                },
              )
          )
        ];
      },
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

  List<String> setContractors() {
    List<String> contractors = [];
    contractors.add(widget.providerControllers[0].text);
    contractors.add(widget.providerControllers[0].text);
    return contractors;
  }

  void setContract() {
    tmpContract = new Contract(
      contractId: widget.titleController.text,
      purpose: widget.descriptionController.text,
      contractType: 'Written',
      executionDate: startDate,
      endDate: endDate,
    );
    tmpContract!.contractors= setContractors();
  }

  void setFormFields() async {
    contractors = await dataProvider.fetchAllUsers();
    setState(() {
      widget.titleController.text = displayStringWithoutUri(widget.contract!.contractId!);
      contractType = contractTypes[0].value; //TODO: make this use real type -> this is hardcode!
      //TODO: this only takes the first data controller, make it take all existing ones.
      _fillRequesterForm(contractors.firstWhere((element) => element.id!.compareTo(displayStringWithoutUri(widget.contract!.contractors[0])) == 0), 0);
      //TODO: this only takes the first data processor, make it take all existing ones.
      _fillProviderForm(contractors.firstWhere((element) => element.id!.compareTo(displayStringWithoutUri(widget.contract!.contractors[1])) == 0), 0);
      widget.descriptionController.text = widget.contract!.purpose!;
      startDate = widget.contract!.executionDate;
      effectiveDate = widget.contract!.executionDate;
      executionDate = widget.contract!.executionDate;
      endDate = widget.contract!.endDate;
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
        setStepObligation();
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
    validateStepFour();
    validateStepObligation();
    setState(() {
      toggleStepOne = true;
      toggleStepTwo = false;
      toggleStepFour = false;
      toggleStepObligation = false;
      toggleStepFinal = false;
    });
  }

  void setStepTwo() {
    validateStepOne();
    validateStepFour();
    validateStepObligation();
    setState(() {
      toggleStepOne = false;
      toggleStepTwo = true;
      toggleStepFour = false;
      toggleStepObligation = false;
      toggleStepFinal = false;
    });
  }

  void setStepFour() {
    validateStepOne();
    validateStepTwo();
    validateStepObligation();
    setState(() {
      toggleStepOne = false;
      toggleStepTwo = false;
      toggleStepFour = true;
      toggleStepObligation = false;
      toggleStepFinal = false;
    });
  }

  void setStepObligation() {
    validateStepOne();
    validateStepTwo();
    validateStepFour();
    setState(() {
      toggleStepOne = false;
      toggleStepTwo = false;
      toggleStepFour = false;
      toggleStepObligation = true;
      toggleStepFinal = false;
    });
  }

  void setStepFinal() {
    validateStepOne();
    validateStepTwo();
    validateStepFour();
    if (stepOneComplete && stepTwoComplete && stepFourComplete) {
      setState(() {
        toggleStepOne = false;
        toggleStepTwo = false;
        toggleStepFour = false;
        toggleStepObligation = false;
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

  Future<void> getTerm(String termTypeId) async {
    List<Term> tempTerms = [];
    var jsonString = await rootBundle.loadString('assets/term.json');
    List<dynamic> body = jsonDecode(jsonString);

    tempTerms = body.map((dynamic e) => Term.fromTemplateJson(e)).toList();
    tempTerms.forEach((element) {
      if(element.termTypeId == termTypeId) {
        setState(() {
          String id = UniqueKey().toString();
          _termList.putIfAbsent(id, () =>
              //termWidget(element, id)
              TermWidget(element, removeTermWidget, id)
          );
        });
      }
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
    widget.providerControllers[index+5].text = selected.city == null ? 'No city found' : selected.city!;
    widget.providerControllers[index+6].text = selected.phone == null ? 'No phone number found' : selected.phone!;
  }

  void _fillRequesterForm(User selected, int index) {
    widget.contractorControllers[index].text = selected.name == null ? 'No name found' : selected.name!;
    widget.contractorControllers[index+1].text = selected.email == null ? 'No email found' : selected.email!;
    widget.contractorControllers[index+2].text = selected.streetAddress == null ? 'No street address found' : selected.streetAddress!;
    widget.contractorControllers[index+3].text = selected.country == null ? 'No country found' : selected.country!;
    widget.contractorControllers[index+5].text = selected.city == null ? 'No city found' : selected.city!;
    widget.contractorControllers[index+6].text = selected.phone == null ? 'No phone number found' : selected.phone!;
  }

  void validateStepOne() async {
    // step1Key.currentState is null when we edit the contract in a step greater than 1.
    if (toggleStepOne == true) {
      var flag = step1Key.currentState!.validate() == true;
      if (flag && contractCategory != null && contractType != null) {
        setState(() {
          stepOneComplete = true;
        });
      } else {
        setState(() {
          stepOneComplete = false;
        });
      }
    }
  }

  void setBaseContractDetails() {
    contract.considerationDescription = widget.considerationDescController.text;
    contract.considerationValue = widget.considerationValController.text;
    contract.contractCategory = contractCategory;
    contract.contractType = contractType;
    contract.contractors.add(widget.user.id);
    contract.effectiveDate = effectiveDate;
    contract.endDate = endDate;
    contract.executionDate = executionDate;
    contract.purpose = widget.titleController.text;
  }

  /// In the [contractors] list all of the existing contractors in the system
  /// are listed. After the user sets enters the contractor's details in the UI
  /// the contractor's ID must be attained based on the email entered.
  void setContractor(String email) {
    String id = contractors.firstWhere((User contractor) => contractor.email!.compareTo(email) == 0).id!;
    contract.contractors.add(id);
  }

  /// Function that checks every textFormField in the second step of the
  /// contract to validate if each field has content in it.
  void validateStepTwo() {
    if (toggleStepTwo == true) {
      //var flag = step2Keys.every((element) => element.currentState!.validate() == true);
      var flag = true;

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

  void validateStepObligation() {
    if(toggleStepObligation == true) {
      var flag = true;

      if (flag) {
        setState(() {
          stepObligationComplete = true;
        });
      } else {
        setState(() {
          stepObligationComplete = false;
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
      setState(() {
        stepFourComplete = true;
      });
    }
      /**if (_step4Key.currentState!.validate() == true && effectiveDate != null && executionDate != null && endDate != null) {
        setState(() {
          stepFourComplete = true;
        });
      } else {
        setState(() {
          stepFourComplete = false;
        });
      }
    }*/
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
        widget.contractorControllers.add(TextEditingController());
      }
    });
  }

  /// Helper function to remove a contractor form. Each contractor has 7
  /// TextFields. That is why we remove 7 TextEditingControllers.
  /// [index] represents the current selected contractor.
  void removeContractor(int index) {
    setState(() {
      for (int i = (index * 7) + 6; i >= (index * 7); i--) {
        widget.contractorControllers.removeAt(i);
      }
      currentContractorIndex -= 1;
    });
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
}
