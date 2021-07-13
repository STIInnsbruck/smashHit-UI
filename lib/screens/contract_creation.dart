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
  int _selectedRoleIndex = -1;//Used to highlight the selected role when adding a new party.
  String _selectedPartyRole = "";//Used to set the label above a party textfield.
  List<User> users = [];
  DataProvider dataProvider = new DataProvider();
  Contract contract = new Contract();
  String? contractDropDownType;

  final TextEditingController _youFieldController = new TextEditingController();
  final TextEditingController _otherFieldController = new TextEditingController();
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _descriptionController = new TextEditingController();
  final TextEditingController _startController = new TextEditingController();
  final TextEditingController _endController = new TextEditingController();


  @override
  void initState() {
    super.initState();
    contract = Contract();
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                  ContractForm()
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
                        textFieldCount==0?
                            Text("Currently No Parties Added", style: TextStyle(color: Colors.black, fontSize: 20), textAlign: TextAlign.center)
                            : Text("Parties", style: TextStyle(color: Colors.black, fontSize: 20)),
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
                  )
              ),
            ),
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: _addPartyButton(),
          ),
          contractEntityField(),
          contractTypeMenu(),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
            child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightGreenAccent,
                  onPrimary: Colors.white,
                ),
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: _confirmContractButton()
                )
            ),
          )
        ],
      ),
    );
  }

  Widget partyField(int index, String? role) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Text("$role"),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: TextFormField(
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
          decoration: BoxDecoration(
              color: Colors.white
          ),
          child: TextFormField(
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
                hintText: "Enter contract type"
            ),
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
      items: <String>['Written Contract', 'Verbal Contract', 'Mutual Contract', 'Transferable Contract']
          .map<DropdownMenuItem<String>>((String value) {
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
          decoration: BoxDecoration(
              color: Colors.white
          ),
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

  _confirmContractButton() {
    return GestureDetector(
      child: Text("Confirm & Send\nContract", style: TextStyle(color: Colors.black, fontSize: 20), textAlign: TextAlign.center),
      onTap: () {
        dataProvider.getContracts();
      },
    );
  }

  _selectPartyRole() {
    showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
           return AlertDialog(
             title: Text("Select a role for the new party.", textAlign: TextAlign.center),
             content: Row(
               children: [
                 _roleButton(Icons.person, "Primary", 0, setState),
                 _roleButton(Icons.person, "Secondary", 1, setState),
                 _roleButton(Icons.person, "Third", 2, setState),
                 _roleButton(Icons.person, "On behalf of...", 3, setState),
               ],
             ),
             actions: [
               TextButton(onPressed: () {
                 _selectedRoleIndex = -1;
                 Navigator.of(context).pop();
               }, child: Text("CANCEL")),
               TextButton(onPressed: () {
                 _selectedRoleIndex==-1?
                 null :
                 setState(() {
                   users.add(new User(_selectedPartyRole));
                   _incrementTextFieldCounter();
                 });
                 _selectedRoleIndex = -1;
                 Navigator.of(context).pop();
                  }, child: Text("CONFIRM", style: TextStyle(color: _selectedRoleIndex!=-1? Colors.blue : Colors.grey)))
             ],
           );
          }
        )
    );
  }

  _roleButton(IconData icon, String subscript, int index, StateSetter setState) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(icon: Icon(icon), onPressed: () {
          setState(() {
            _selectedRoleIndex = index;
          });
          _selectedPartyRole = subscript;
        }, iconSize: 100, color: _selectedRoleIndex==index? Colors.green : Colors.grey),
        Text("$subscript"),
      ],
    );
  }

  _incrementTextFieldCounter() {
    setState(() {
      textFieldCount++;
    });
  }
}