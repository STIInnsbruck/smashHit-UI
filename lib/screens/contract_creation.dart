import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/custom_widgets/contract_status_bar.dart';
import 'package:smashhit_ui/custom_widgets/contract_form.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import '../custom_widgets/contract_status_bar.dart';

class ContractCreation extends StatefulWidget {
  final Function(int, [String]) changeScreen;
  final User? user;

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
  Contract? contract;
  String? contractDropDownType;
  bool isFormComplete = false; //boolean used to toggle the Confirm&Send Button
  static ContractForm? contractForm;

  //-------------------------------------------------- TextEditingControllers
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  List<TextEditingController> textControllers =
      []; //for dynamic amount of parties

  @override
  void initState() {
    super.initState();
    contractForm  = ContractForm(widget.changeScreen, 1, null);
    _titleController = contractForm!.titleController;
    _descriptionController = contractForm!.descriptionController;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    _checkIfFormComplete();

    return Center(
      child: Scrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: screenWidth * 0.66,
                height: 100,
                child: ContractStatusBar(contract != null? contract!.getContractStatusAsInt() : 0),
              ),
              contractForm!
            ],
          ),
        ),
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
            IconButton(
                icon: Icon(Icons.highlight_remove, size: 20),
                onPressed: () {
                  _removeParty(index);
                },
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints())
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
      child: _selectedEntityLabel.compareTo("") == 0 ?
      Column(
        children: [
          Icon(Icons.add_circle_outline, size: 40),
          Text("Add Contract Item",
              style: TextStyle(color: Colors.black, fontSize: 10))
        ],
      )
      : selectedContractItem(),
      onTap: () {
        _selectContractedEntity();
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
                                users.add(new User(role: _selectedPartyRole));
                                textControllers
                                    .add(new TextEditingController());
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
              return SingleChildScrollView(
                child: AlertDialog(
                  title: Text(
                    "Select an item that is being contracted.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _entityButton(Icons.person_search_rounded,
                              "Personal Data", 0, setState),
                          _entityButton(Icons.work, "Work", 1, setState),
                          _entityButton(
                              Icons.request_quote, "Subscription", 2, setState),
                          _entityButton(
                              Icons.description, "Insurance", 3, setState),
                        ],
                      ),
                      Container(
                        height: 25,
                      ),
                      Container(
                        height: 70,
                        child: Column(
                          children: [
                            Text(
                                "Does you contract item not fit in one of the above categories? Please specify it down below.",
                                style: TextStyle(fontSize: 15)),
                            TextField()
                          ],
                        ),
                      )
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          _selectedEntityIndex = -1;
                          Navigator.of(context).pop();
                        },
                        child: Text("CANCEL")),
                    TextButton(
                        onPressed: () {
                          _selectedEntityIndex = -1;
                          Navigator.of(context).pop();
                        },
                        child: Text("CONFIRM",
                            style: TextStyle(
                                color: _selectedEntityIndex != -1
                                    ? Colors.blue
                                    : Colors.grey)))
                  ],
                ),
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
                _selectedPartyRole = subscript;
              });
            },
            iconSize: 100,
            color: _selectedRoleIndex == index ? Colors.green : Colors.grey),
        Text("$subscript"),
      ],
    );
  }

  _entityButton(
      IconData icon, String subscript, int index, StateSetter setStateT) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            icon: Icon(icon),
            onPressed: () {
              //Two setState methods are needed to update first the dialog which
              // needs its own Statesetter and then the sideBar widget with the
              // overall setState method.
              setStateT(() {
                _selectedEntityIndex = index;
                _selectedEntityLabel = subscript;
              });
              setState(() {
                _selectedEntityIndex = index;
                _selectedEntityLabel = subscript;
              });
            },
            iconSize: 50,
            color: _selectedEntityIndex == index ? Colors.green : Colors.grey),
        Text("$subscript", style: TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget selectedContractItem() {
    IconData itemIcon = Icons.assignment_outlined;
    switch(_selectedEntityLabel) {
      case "Personal Data":
        itemIcon = Icons.person_search_rounded;
        break;
      case "Work":
        itemIcon = Icons.work;
        break;
      case "Subscription":
        itemIcon = Icons.request_quote;
        break;
      case "Insurance":
        itemIcon = Icons.description;
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Icon(itemIcon, size: 40),
            Text("$_selectedEntityLabel")
          ],
        ),
        IconButton(
          onPressed: _selectContractedEntity,
          icon: Icon(Icons.edit),
        )
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
    if (textControllers.isEmpty) {
      setState(() {
        isFormComplete = false;
      });
    } else {
      textControllers.forEach((element) {
        if (element.text.isNotEmpty) {
          if (_titleController.text.isNotEmpty &&
              _descriptionController.text.isNotEmpty &&
              contractForm!.startDate != null &&
              contractForm!.endDate != null &&
              _selectedEntityLabel != "" &&
              contractDropDownType != null) {
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
