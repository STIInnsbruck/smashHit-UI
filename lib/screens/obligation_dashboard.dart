import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import 'package:smashhit_ui/custom_widgets/obligation_tile.dart';

class ObligationsDashboard extends StatefulWidget {
  final Function(int, [String]) changeScreen;
  final String? searchId;
  final User? user;
  final bool offlineMode;

  ObligationsDashboard(this.changeScreen, this.user, this.searchId, this.offlineMode);

  @override
  _ObligationDashboardState createState() => new _ObligationDashboardState();
}

class _ObligationDashboardState extends State<ObligationsDashboard> {
  DataProvider dataProvider = DataProvider();

  late Future<List<Obligation>> futureObligations;
  List<Obligation>? obligationList = [];
  String? searchId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    searchId = widget.searchId;
    return Container(
      child: FutureBuilder<List<Obligation>> (
        future: futureObligations = fetchAllObligationsOfUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            obligationList = snapshot.data!;
            return Column(
              children: [
                listHeader(),
                obligationList!.isEmpty
                  ? noContractsText()
                  : obligationListWidget()
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(child: CircularProgressIndicator());
        }
      )
    );
  }

  ListTile listHeader() {
    return ListTile(
      title: Row(
        children: [
          Spacer(),
          Expanded(flex: 2, child: Text("Type", textAlign: TextAlign.left)),
          Expanded(flex: 8, child: Text("ID")),
          Expanded(flex: 16, child: Text("Description")),
          Expanded(flex: 2, child: Text("End Date", textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text("Status", textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget noContractsText() {
    return Expanded(
        child: Center(
            child: Text(
                "You have no contracts. Create a contract in the drawer menu to the left.")));
  }

  Widget obligationListWidget() {
    return Expanded(
      child: ListView.builder(
        itemCount: obligationList!.length,
        itemBuilder: (BuildContext context, int index) {
          if (searchId == null) {
            return ObligationTile(widget.changeScreen, obligationList![index], widget.user!.id, index+1);
          } else {
            if (obligationList![index].id!.contains(searchId!)) {
              return ObligationTile(widget.changeScreen, obligationList![index], widget.user!.id, index+1);
            } else {
              return Container();
            }
          }
        },
      )
    );
  }

  Future<List<Obligation>> fetchAllObligationsOfUser() async {
    //fetch all contracts of the user
    List<Contract> contractList = await dataProvider.fetchContractsByContractorId(widget.user!.id!, widget.user!.token!);
    List<Obligation> oblList = [];

    //search all obligations in each contract
    for (Contract contract in contractList) {
      for (String oblId in contract.obligations) {
        Obligation tmpObligation = await dataProvider.fetchObligationById(oblId);
        //only add obligations if it belongs to the user
        if (tmpObligation.contractorId == widget.user!.id!) {
          oblList.add(tmpObligation);
        }
      }
    }

    return oblList;
  }

  bool _isSmallScreen(double width) {
    if (width <= 500.0) {
      return true;
    }
    return false;
  }
}
