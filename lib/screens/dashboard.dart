import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import 'package:smashhit_ui/custom_widgets/contract_tile.dart';

class Dashboard extends StatefulWidget {
  final Function(int, [String]) changeScreen;
  final String? userId;
  final String? searchId;

  Dashboard(this.changeScreen, this.userId, this.searchId);

  @override
  _DashboardState createState() => new _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  List<String> contractIdList = []; //API first gives us all IDs.
  DataProvider dataProvider = DataProvider();

  late Future<List<Contract>> futureContractList = [] as Future<List<Contract>>;
  List<Contract>? contractList = [];
  String? searchId;

  @override
  void initState() {
    super.initState();
    //futureContractList = dataProvider.fetchAllContracts();
    futureContractList = dataProvider.fetchContractsByProviderId(widget.userId!);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    searchId = widget.searchId;
    return Container(
      child: FutureBuilder<List<Contract>>(
        future: futureContractList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            contractList = snapshot.data;
            return Column(
              children: [
                _isSmallScreen(screenWidth)? Container() : listHeader(),
                contractList!.isEmpty
                  ? noContractsText() : contractListWidget()
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(child: CircularProgressIndicator());
        }
      ),
    );
  }

  ListTile listHeader() {
    return ListTile(
      title: Row(
        children: [
          Container(width: 75, child: Text("Type")),
          Text("ID"),
          Spacer(flex: 28),
          Text("Status"),
          Spacer(flex: 5),
          Text("Actions"),
          Spacer(flex: 2)
        ],
      ),
    );
  }

  Widget noContractsText() {
    return Expanded(child: Center(child: Text("You have no contracts. Create a contract in the drawer menu to the left.")));
  }

  Widget contractListWidget() {
    return Expanded(
      child: ListView.builder(
          itemCount: contractList!.length,
          itemBuilder: (BuildContext context, int index) {
            if (searchId == null) {
              return ContractTile(widget.changeScreen, refreshContractList, contractList![index]);
            } else {
              if (contractList![index].contractId!.contains(searchId!)) {
                return ContractTile(widget.changeScreen, refreshContractList, contractList![index]);
              } else {
                return Container();
              }
            }
          }),
    );
  }

  bool _isSmallScreen(double width) {
    if (width <= 500.0) {
      return true;
    }
    return false;
  }

  void refreshContractList() {
    setState(() {
      futureContractList = dataProvider.fetchAllContracts();
    });
  }
}
