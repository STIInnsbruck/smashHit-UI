import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/data/data_provider.dart';

class ViewContract extends StatefulWidget {
  final Function(int) changeScreen;
  User? user;

  ViewContract(this.changeScreen, this.user);

  @override
  _ContractCreationState createState() => new _ContractCreationState();
}

class _ContractCreationState extends State<ViewContract> {
  List<User> users = [];
  DataProvider dataProvider = new DataProvider();
  Contract contract = new Contract(null, null);
  String? contractDropDownType;

  @override
  void initState() {
    super.initState();
    contract = Contract(null, null);
    contract.contractStatus = "Done";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Expanded(
          child: Scrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
                Row(
                  children: [
                    Spacer(),
                    partiesTile(screenWidth, screenHeight),
                    Spacer(),
                    TOSTile(screenWidth, screenHeight),
                    Spacer(flex: 4),
                  ],
                ),
                Container(height: 20),
                Row(
                  children: [
                    Spacer(),
                    contractedEntitiesTile(screenWidth, screenHeight),
                    Spacer(),
                    statusTile(screenWidth, screenHeight),
                    Spacer(flex: 4)
                  ],
                )
              ]),
            ),
          ),
        ),
      ],
    );
  }

  Widget partiesTile(double width, double height) {
    return Container(
      height: height / 4,
      width: width / 4,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black45,
                blurRadius: 5,
                spreadRadius: 2.5,
                offset: Offset(2.5, 2.5))
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Involved Parties:"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              partyEntity("Primary"),
              partyEntity("On behalf of"),
              partyEntity("Primary"),
            ],
          )
        ],
      ),
    );
  }

  Widget partyEntity(String partyRole) {
    return Container(
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 22,
              child: Icon(Icons.person),
            ),
          ),
          Text("name"),
          Text(partyRole, style: TextStyle(color: Colors.grey, fontSize: 15))
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget TOSTile(double width, double height) {
    return Container(
      height: height / 4,
      width: width / 4,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black45,
                blurRadius: 5,
                spreadRadius: 2.5,
                offset: Offset(2.5, 2.5))
          ]),
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text("Terms of Service"),
          ),
          Container(
            color: Colors.grey[300],
            height: height / 40,
            width: width / 5,
          ),
          Container(
            color: Colors.grey[300],
            height: height / 40,
            width: width / 10,
          ),
          Container(
            color: Colors.grey[300],
            height: height / 40,
            width: width / 8,
          ),
        ],
      ),
    );
  }

  Widget statusTile(double width, double height) {
    return Container(
      height: height / 4,
      width: width / 4,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black45,
                blurRadius: 5,
                spreadRadius: 2.5,
                offset: Offset(2.5, 2.5))
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Contract Status:"),
          statusIconByContractStatus(height),
        ],
      ),
    );
  }

  /// Takes the current Contract's status and returns the appropriate icon.
  Icon statusIconByContractStatus(double height) {
    switch (contract.getContractStatusAsInt()) {
      case 0:
        return Icon(Icons.description, color: Colors.grey, size: height / 6);
      case 1:
        return Icon(Icons.work, color: Colors.grey, size: height / 6);
      case 2:
        return Icon(Icons.check_circle, color: Colors.green, size: height / 6);
    }
    return Icon(Icons.check_circle, color: Colors.green, size: height / 6);
  }

  Widget contractedEntitiesTile(double width, double height) {
    return Container(
      height: height / 4,
      width: width / 4,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black45,
                blurRadius: 5,
                spreadRadius: 2.5,
                offset: Offset(2.5, 2.5))
          ]),
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Contracted Entities"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                child: Icon(Icons.person),
                radius: height / 15,
              ),
              Icon(Icons.compare_arrows, size: height / 8),
              CircleAvatar(
                child: Icon(Icons.person),
                radius: height / 15,
              )
            ],
          )
        ],
      ),
    );
  }
}
