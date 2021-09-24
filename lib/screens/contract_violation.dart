import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/custom_widgets/claim_form.dart';


class ContractViolation extends StatefulWidget {
  final Function(int) changeScreen;
  User? user;

  ContractViolation(this.changeScreen, this.user);

  @override
  _ContractViolationState createState() => new _ContractViolationState();
}

class _ContractViolationState extends State<ContractViolation> {
  static ClaimForm claimForm = ClaimForm();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Scrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              claimForm
            ],
          ),
        ),
      ),
    );
  }

}