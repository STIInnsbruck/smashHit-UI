import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';

class UpdateForm extends StatefulWidget {
  Function (int) changeScreen;
  final Contract contract;

  UpdateForm(this.changeScreen, this.contract);

  @override
  _UpdateFormState createState() => new _UpdateFormState();


}

class _UpdateFormState extends State<UpdateForm> {


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}