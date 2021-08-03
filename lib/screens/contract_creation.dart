import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/custom_widgets/contract_status_bar.dart';
import 'package:smashhit_ui/custom_widgets/contract_form.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import '../custom_widgets/contract_status_bar.dart';

class ContractCreation extends StatefulWidget {
  final Function(int) changeScreen;
  User? user;

  ContractCreation(this.changeScreen, this.user);

  @override
  _ContractCreationState createState() => new _ContractCreationState();
}

class _ContractCreationState extends State<ContractCreation> {
  int textFieldCount = 0; //Minimum of two parties in all contracts
  int _selectedRoleIndex =
      -1; //Used to highlight the selected role when adding a new party.
  String _selectedPartyRole =
      ""; //Used to set the label above a party textfield.
  int _selectedEntityIndex =
      -1; //Used to highlight the selected entity to be contracted.
  String _selectedEntityLabel =
      ""; //Used to set the label of what entity is being contracted and insert it into the sidebar.
  List<User> users = [];
  DataProvider dataProvider = DataProvider();
  Contract contract = Contract(null, null);
  String? contractDropDownType;
  bool isFormComplete = false; //boolean used to toggle the Confirm&Send Button
  ContractForm contractForm = ContractForm();

  //-------------------------------------------------- TextEditingControllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<TextEditingController> textControllers = []; //for dynamic amount of parties

  @override
  void initState() {
    super.initState();
    contract = Contract(null, null);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    _checkIfFormComplete();

    return Row(
      children: [
        _sideBar(screenWidth, screenHeight),
        Container(width: 10),
        Expanded(
          child: Scrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: screenWidth * 0.66,
                    height: 100,
                    child: ContractStatusBar(contract.getContractStatusAsInt()),
                  ),
                  contractForm
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sideBar(double width, double height) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
      width: width / 5,
      color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: height * 0.45,
              minHeight: height * 0.45,
            ),
            child: Scrollbar(
              child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Container(
                    child: Column(
                      children: [
                        textFieldCount == 0
                            ? Text("Currently No Parties Added",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                                textAlign: TextAlign.center)
                            : Text("Parties",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20)),
                        ListView.builder(
                          itemCount: textFieldCount,
                          itemBuilder: (BuildContext context, int index) {
                            return partyField(index, users[index].role);
                          },
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: _addPartyButton(),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: _addEntityButton(),
          ),
          contractTypeMenu(),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
            color: isFormComplete? Colors.lightGreenAccent : Colors.grey[400],
            width: width,
            child: FittedBox(
                fit: BoxFit.fitWidth, child: _confirmContractButton()),
          )
        ],
      ),
    );
  }

  Widget partyField(int index, String? role) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Text("$role"),
            ),
            Spacer(),
            IconButton(icon: Icon(Icons.highlight_remove, size: 20),
              onPressed: () {
                _removeParty(index);
              },
              iconSize: 20,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints()
            )
          ],
        ),
        Container(
          margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
          height: 30,
          decoration: BoxDecoration(color: Colors.white),
          child: TextFormField(
            controller: textControllers.elementAt(index),
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              hintText: "Enter name",
            ),
          ),
        ),
      ],
    );
  }

  Widget contractTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Text("Contract Type"),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
          height: 30,
          decoration: BoxDecoration(color: Colors.white),
          child: TextFormField(
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(hintText: "Enter contract type"),
          ),
        ),
      ],
    );
  }

  Widget contractTypeMenu() {
    return DropdownButton(
      value: contractDropDownType,
      icon: const Icon(Icons.arrow_drop_down),
      hint: Text("Pick a contract type", style: TextStyle(fontSize: 15)),
      onChanged: (String? newValue) {
        setState(() {
          contractDropDownType = newValue;
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
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget contractEntityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Text("Contracted Entity"),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
          height: 30,
          decoration: BoxDecoration(color: Colors.white),
          child: TextFormField(
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              hintText: "What entity is being contracted?",
            ),
          ),
        ),
      ],
    );
  }

  Widget _addPartyButton() {
    return GestureDetector(
      child: Column(
        children: [
          Icon(Icons.add_circle_outline, size: 40),
          Text("Add Party", style: TextStyle(color: Colors.black, fontSize: 10))
        ],
      ),
      onTap: () {
        _selectPartyRole();
      },
    );
  }

  Widget _addEntityButton() {
    return GestureDetector(
      child: Column(
        children: [
          Icon(Icons.add_circle_outline, size: 40),
          Text("Add Contract Item",
              style: TextStyle(color: Colors.black, fontSize: 10))
        ],
      ),
      onTap: () {
        _selectContractedEntity();
      },
    );
  }

  _confirmContractButton() {
    return GestureDetector(
      child: Text("Confirm & Send\nContract",
          style: TextStyle(color: Colors.black, fontSize: 20),
          textAlign: TextAlign.center),
      onTap: () { isFormComplete ?
        dataProvider.createContract(
            "SampleContract",
            "This is a test of the smashHit flutter application. Insert Terms of Service here.",
            "string",
            DateTime.now(),
            DateTime.now())
      : null;
      },
    );
  }

  _selectPartyRole() {
    showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Text("Select a role for the new party.",
                    textAlign: TextAlign.center),
                content: Row(
                  children: [
                    _roleButton(Icons.person, "Primary", 0, setState),
                    _roleButton(Icons.person, "Secondary", 1, setState),
                    _roleButton(Icons.person, "Third", 2, setState),
                    _roleButton(Icons.person, "On behalf of...", 3, setState),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        _selectedRoleIndex = -1;
                        Navigator.of(context).pop();
                      },
                      child: Text("CANCEL")),
                  TextButton(
                      onPressed: () {
                        _selectedRoleIndex == -1
                            ? null
                            : setState(() {
                                users.add(new User(_selectedPartyRole));
                                textControllers.add(new TextEditingController());
                                _incrementTextFieldCounter();
                              });
                        _selectedRoleIndex = -1;
                        Navigator.of(context).pop();
                      },
                      child: Text("CONFIRM",
                          style: TextStyle(
                              color: _selectedRoleIndex != -1
                                  ? Colors.blue
                                  : Colors.grey)))
                ],
              );
            }));
  }

  _selectContractedEntity() {
    showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Text("Select an item that is being contracted.",
                    textAlign: TextAlign.center),
                content: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _entityButton(Icons.person_search_rounded,
                            "Personal Data", 0, setState),
                        _entityButton(Icons.work, "Work", 1, setState),
                        _entityButton(Icons.request_quote, "Subscription",
                            2, setState),
                        _entityButton(
                            Icons.description, "Insurance", 3, setState),
                      ],
                    ),
                    Spacer(),
                    Container(
                      height: 67,
                      child: Column(
                        children: [
                          Text("Does you contract item not fit in one of the above categories? Please specify it down below."),
                          TextField()
                        ],
                      ),
                    )
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        _selectedRoleIndex = -1;
                        Navigator.of(context).pop();
                      },
                      child: Text("CANCEL")),
                  TextButton(
                      onPressed: () {
                        _selectedRoleIndex == -1
                            ? null
                            : setState(() {
                                users.add(new User(_selectedPartyRole));
                                textControllers.add(new TextEditingController());
                                _incrementTextFieldCounter();
                              });
                        _selectedRoleIndex = -1;
                        Navigator.of(context).pop();
                      },
                      child: Text("CONFIRM",
                          style: TextStyle(
                              color: _selectedRoleIndex != -1
                                  ? Colors.blue
                                  : Colors.grey)))
                ],
              );
            }));
  }

  _roleButton(
      IconData icon, String subscript, int index, StateSetter setState) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            icon: Icon(icon),
            onPressed: () {
              setState(() {
                _selectedRoleIndex = index;
              });
              _selectedPartyRole = subscript;
            },
            iconSize: 100,
            color: _selectedRoleIndex == index ? Colors.green : Colors.grey),
        Text("$subscript"),
      ],
    );
  }

  _entityButton(
      IconData icon, String subscript, int index, StateSetter setState) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            icon: Icon(icon),
            onPressed: () {
              setState(() {
                _selectedEntityIndex = index;
              });
              _selectedEntityLabel = subscript;
            },
            iconSize: 100,
            color: _selectedRoleIndex == index ? Colors.green : Colors.grey),
        Text("$subscript"),
      ],
    );
  }

  _incrementTextFieldCounter() {
    setState(() {
      textFieldCount++;
    });
  }

  _removeParty(int index) {
    setState(() {
      users.removeAt(index);
      textControllers.removeAt(index);
      textFieldCount--;
    });
  }

  ///function to check if all textfields, and other necessary information for a
  ///contract are filled in with some value other than null (nothing).
  _checkIfFormComplete() {
    if(textControllers.isEmpty) {
      setState(() {
        isFormComplete = false;
      });
    } else {
      textControllers.forEach((element) {
        if(element.text.isNotEmpty) {
          if(_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty && contractForm.startDate != null && contractForm.endDate != null) {
            setState(() {
              isFormComplete = true;
            });
          }
        } else {
          setState(() {
            isFormComplete = false;
          });
        }
      });
    }
  }
}
