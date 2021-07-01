import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/custom_widgets/contract_status_bar.dart';
import 'package:smashhit_ui/custom_widgets/contract_form.dart';

import '../custom_widgets/contract_status_bar.dart';

class ContractCreation extends StatefulWidget {

  final Function(int) changeScreen;
  User? user;

  ContractCreation(this.changeScreen, this.user);

  @override
  _ContractCreationState createState() => new _ContractCreationState();
}

class _ContractCreationState extends State<ContractCreation> {

  int textFieldCount = 2; //Minimum of two parties in all contracts
  final TextEditingController _youFieldController = new TextEditingController();
  final TextEditingController _otherFieldController = new TextEditingController();
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _descriptionController = new TextEditingController();
  final TextEditingController _startController = new TextEditingController();
  final TextEditingController _endController = new TextEditingController();




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
                    height: 125,
                    child: ContractStatusBar(),
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
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      width: width / 5,
      color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: height * 0.65
            ),
            child: Scrollbar(
              child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Container(
                    child: Column(
                      children: [
                        Text("Parties", style: TextStyle(color: Colors.black, fontSize: 25)),
                        ListView.builder(
                          itemCount: textFieldCount,
                          itemBuilder: (BuildContext context, int index) {
                            return partyField(index);
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
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: _addPartyButton(),
          ),
          ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: Colors.lightGreenAccent,
                onPrimary: Colors.white,
              ),
              child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text("Confirm Contract", style: TextStyle(color: Colors.black, fontSize: 30))
              )
          )
        ],
      ),
    );
  }

  Widget partyField(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: index == 0? Text("You") : Text("Other party"),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: TextFormField(
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
                hintText: "Enter name"
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
        setState(() {
          textFieldCount++;
        });
      },
    );
  }
}