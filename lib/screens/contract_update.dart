import 'package:flutter/material.dart';
import 'package:smashhit_ui/custom_widgets/contract_form.dart';
import 'package:smashhit_ui/custom_widgets/update_form.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/data/data_provider.dart';

class UpdateScreen extends StatefulWidget {
  final Function(int, [String]) changeScreen;
  final String contractId;
  final User? user;
  final bool offlineMode;

  UpdateScreen(this.changeScreen, this.contractId, this.user, this.offlineMode);

  @override
  _UpdateScreenState createState() => new _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {

  bool isEditing = false;
  int currentStep = 1;

  late Future<Contract> futureContract;
  Contract? contract;
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
    return FutureBuilder<Contract>(
      future: futureContract,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          contract = snapshot.data;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                isEditing? Expanded(child: ContractForm(widget.changeScreen, contract!, widget.user!, toggleEditing)) : Expanded(child: UpdateForm(widget.changeScreen, toggleEditing, contract!))
              ],
            )
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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

  void toggleEditing([int? x]) {
    if(x != null) {setStep(x);}
    print("Updatable Contrac ID: ${contract!.id}");
    setState(() {
      isEditing = !isEditing;
    });
  }

  void setStep(int x) {
    setState(() {
      currentStep = x;
    });
  }

}