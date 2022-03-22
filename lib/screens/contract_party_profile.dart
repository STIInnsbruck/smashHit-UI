import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import 'package:smashhit_ui/data/models.dart';

class ContractPartyProfile extends StatefulWidget {
  final Function(int, [String]) changeScreen;
  final String userId;

  ContractPartyProfile(this.changeScreen, this.userId);

  @override
  _ContractPartyProfileState createState() => _ContractPartyProfileState();
}

class _ContractPartyProfileState extends State<ContractPartyProfile> {

  DataProvider dataProvider = new DataProvider();
  late Future<User> futureUser = User() as Future<User>;
  User? user;

  @override
  void initState() {
    super.initState();

    futureUser = dataProvider.fetchUserById(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
    );
  }


}