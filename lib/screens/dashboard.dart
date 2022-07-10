import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import 'package:smashhit_ui/custom_widgets/contract_tile.dart';

class Dashboard extends StatefulWidget {
  final Function(int, [String]) changeScreen;
  final String? searchId;
  final User? user;
  final bool offlineMode;

  Dashboard(this.changeScreen, this.user, this.searchId, this.offlineMode);

  @override
  _DashboardState createState() => new _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  List<String> contractIdList = []; //API first gives us all IDs.
  DataProvider dataProvider = DataProvider();

  late Future<List<Contract>> futureContractList = [] as Future<List<Contract>>;
  List<Contract>? contractList = [];
  String? searchId;

  //Offline Variables
  List<User> usersList = [];
  List<Obligation> obligationsList = [];

  @override
  void initState() {
    super.initState();
    if(widget.offlineMode) {
      _generateOfflineData();
    }
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
        future: futureContractList = dataProvider.fetchContractsByContractorId(widget.user!.id!),
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
          Spacer(flex: 12),
          Text("Purpose"),
          Spacer(flex: 12),
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

  _generateOfflineData() {

  }

  _generateOfflineContractor(String id, String name, String email,
      String streetAddress, String country, String city, String phone, String role) {
    User user = new User(
      id: id,
      name: name,
      email: email,
      streetAddress: streetAddress,
      country: country,
      city: city,
      phone: phone,
      role: role
    );

    usersList.add(user);
  }

  _generateOfflineObligation(String obligationId, String contractId, String contractorId,
      String termId, String description, DateTime endDate,
      DateTime executionDate, String state) {
    Obligation obligation = new Obligation(
      id: obligationId,
      contractId: contractId,
      contractorId: contractorId,
      termId: termId,
      description: description,
      endDate: endDate,
      executionDate: executionDate,
      state: state
    );

    obligationsList.add(obligation);
  }

  _generateContract() {
    return null;
  }
}
