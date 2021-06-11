import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';

class ContractForm extends StatefulWidget {

  @override
  _ContractFormState createState() => new _ContractFormState();
}

class _ContractFormState extends State<ContractForm> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.blue,
      width: screenWidth / 2,
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              titleField(),
              descriptionField(),
              timeFrameField()
            ],
          ),
        ),
      ),
    );
  }

  Widget titleField() {
    return Row(
      children: [
        Text("Title: ", style: TextStyle(fontSize: 25)),
        Expanded(
          child: TextField(),
        ),
      ],
    );
  }

  Widget descriptionField() {
    return Column(
      children: [
        Text("Description: ", style: TextStyle(fontSize: 25)),
        Container(
          height: 500,
          color: Colors.white70,
          child: TextField(
            maxLines: null,
            decoration: InputDecoration(
                hintText: "Enter contract details here..."
            ),
          ),
        ),
      ],
    );
  }

  Widget timeFrameField() {
    return Column(
      children: [
        Row(
          children: [
            Text("Start date: ", style: TextStyle(fontSize: 25)),
            Expanded(
              child: TextField(),
            ),
            Text("End date: ", style: TextStyle(fontSize: 25)),
            Expanded(
              child: TextField(),
            ),
          ],
        )
      ],
    );
  }
}