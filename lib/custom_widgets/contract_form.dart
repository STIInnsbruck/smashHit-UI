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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 25.0,
            spreadRadius: 5.0,
            offset: Offset(
              10.0,
              10.0
            )
          )
        ]
      ),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      width: screenWidth * 0.50,
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              titleField(),
              Container(
                height: 20,
              ),
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
          child: TextFormField(
              style: TextStyle(fontSize: 20)
          ),
        )
      ],
    );
  }

  Widget descriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Contract Terms: ", style: TextStyle(fontSize: 25)),
        Container(
          height: 400,
          color: Colors.white70,
          child: TextField(
            maxLines: null,
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
                hintText: "Enter contract details here...",
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
              child: TextField(
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20)
              ),
            ),
            Spacer(),
            Text("End date: ", style: TextStyle(fontSize: 25)),
            Expanded(
              child: TextField(
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20)
              ),
            ),
          ],
        )
      ],
    );
  }
}