import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/custom_widgets/contract_status_bar.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import '../custom_widgets/contract_status_bar.dart';

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
                SizedBox(
                  width: screenWidth * 0.66,
                  height: 100,
                  child: ContractStatusBar(contract.getContractStatusAsInt()),
                ),
                partiesTile(screenWidth, screenHeight),
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
              partyEntity("Primary"),
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
}
