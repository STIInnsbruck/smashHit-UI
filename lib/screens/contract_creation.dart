import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/custom_widgets/contract_form.dart';
import 'package:smashhit_ui/data/data_provider.dart';

class ContractCreation extends StatefulWidget {
  final Function(int, [String]) changeScreen;
  final User? user;
  final bool offlineMode;

  ContractCreation(this.changeScreen, this.user, this.offlineMode);

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
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Scrollbar(
            child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    ContractForm(widget.changeScreen, null, widget.user!)
                  ],
                )
            )
        ),
      ],
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
