import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/custom_widgets/contract_partner_tile.dart';
import 'package:smashhit_ui/data/data_provider.dart';

class Dashboard extends StatefulWidget {
  final Function(int) changeScreen;
  User? user;

  Dashboard(this.changeScreen, this.user);

  @override
  _DashboardState createState() => new _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  List<String> contractIdList = []; //API first gives us all IDs.
  List<Contract> contractList = []; //With the IDs we then get the specific contract.
  DataProvider dataProvider = DataProvider();

  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;

    return ListView(
      children: [
        ContractPartnerTile(),
        ContractPartnerTile(),
        ContractPartnerTile(),
        ContractPartnerTile(),
        ContractPartnerTile(),
        ContractPartnerTile()
      ],
    );
  }

  void fetchContractIds() {

  }
}
