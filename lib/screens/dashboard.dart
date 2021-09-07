import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/custom_widgets/contract_partner_tile.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import 'package:smashhit_ui/custom_widgets/contract_tile.dart';

class Dashboard extends StatefulWidget {
  final Function(int) changeScreen;
  User? user;

  Dashboard(this.changeScreen, this.user);

  @override
  _DashboardState createState() => new _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  List<String> contractIdList = []; //API first gives us all IDs.
  DataProvider dataProvider = DataProvider();

  late Future<List<Contract>> futureContractList;
  List<Contract>? contractList = [];

  @override
  void initState() {
    super.initState();
    futureContractList = dataProvider.fetchAllContracts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      child: FutureBuilder<List<Contract>>(
        future: futureContractList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            contractList = snapshot.data;
            return ListView.builder(
                itemCount: contractList!.length,
                itemBuilder: (BuildContext context, int index) {
                  return ContractTile(contractList![index]);
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(child: CircularProgressIndicator());
        }
      ),
    );
  }

}
