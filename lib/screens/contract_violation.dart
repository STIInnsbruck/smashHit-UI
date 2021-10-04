import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/custom_widgets/claim_form.dart';
import 'package:smashhit_ui/data/data_provider.dart';


class ContractViolation extends StatefulWidget {
  final Function(int) changeScreen;
  final String contractId;
  User? user;

  ContractViolation(this.changeScreen, this.contractId, this.user);

  @override
  _ContractViolationState createState() => new _ContractViolationState();
}

class _ContractViolationState extends State<ContractViolation> {
  late Future<Contract> futureContract;
  Contract? contract;
  ClaimForm? claimForm;
  DataProvider dataProvider = new DataProvider();

  @override
  void initState() {
    super.initState();
    futureContract = dataProvider.fetchContractById(widget.contractId);
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<Contract>(
      future: futureContract,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          contract = snapshot.data;
          return Center(
            child: Scrollbar(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClaimForm(widget.changeScreen, contract!)
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Error; fetching contract by ID: ${widget.contractId}'),
              ],
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      }
    );
  }

}