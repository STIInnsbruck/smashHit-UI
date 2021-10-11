import 'package:flutter/material.dart';
import 'package:smashhit_ui/custom_widgets/update_form.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/data/data_provider.dart';

class UpdateScreen extends StatefulWidget {
  Function(int) changeScreen;
  final String contractId;
  User? user;

  UpdateScreen(this.changeScreen, this.contractId, this.user);

  @override
  _UpdateScreenState createState() => new _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {

  late Future<Contract> futureContract;
  Contract? contract;
  UpdateForm? updateForm;
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
            child: Scrollbar(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    UpdateForm(widget.changeScreen, contract!)
                  ],
                ),
              ),
            )
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