import 'package:flutter/cupertino.dart';
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
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
        children: [
          Container(
              child: Scrollbar(
                  child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            updateFormBody(screenWidth * 0.5)
                          ]
                      )
                  )
              )
          ),
        ]
    );
  }

  Widget updateFormBody(double width) {
    return Container(
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black45,
                blurRadius: 25.0,
                spreadRadius: 5.0,
                offset: Offset(10.0, 10.0))
          ]),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Scrollbar(
          child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                      child: Text('Contract Violation Form', style: TextStyle(fontSize: 30, decoration: TextDecoration.underline))
                  ),
                  Container(height: 20),
                  Container(height: 20),
                  Container(height: 20),
                  contractInformationBlock(),
                  Container(height: 5),
                  contractRequesterBlock(),
                  Container(height: 5),
                  contractProviderBlock(),
                  Container(height: 10),
                  Text(widget.contract.description!, style: TextStyle(fontSize: 15), textAlign: TextAlign.justify),
                  Container(height: 20),
                  Container(height: 50),
                  Container(height: 20),
                  Container(height: 50),
                ],
              )
          )
      ),
    );
  }

  MaterialButton contractInformationBlock() {
    return MaterialButton(
      color: Colors.white,
      hoverColor: Colors.blue,
      onPressed: () { print("edit"); },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Text('Contract Information', style: TextStyle(fontSize: 25)),
          ),
          Text('Contract Type: ${widget.contract.formatContractType()}', style: TextStyle(fontSize: 15))
        ],
      ),
    );
  }

  MaterialButton contractRequesterBlock() {
    return MaterialButton(
      color: Colors.white,
      hoverColor: Colors.blue,
      onPressed: () { print("edit"); },
      child: Row(
        children: [
          Center(child: Text('Data Controller(s): ', style: TextStyle(fontSize: 15))),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.contract.formatContractor(), style: TextStyle(fontSize: 15))
            ],
          )
        ],
      ),
    );
  }

  MaterialButton contractProviderBlock() {
    return MaterialButton(
      color: Colors.white,
      hoverColor: Colors.blue,
      onPressed: () { print("edit"); },
      child: Row(
        children: [
          Center(child: Text('Data Processor(s): ', style: TextStyle(fontSize: 15))),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.contract.formatContractee(), style: TextStyle(fontSize: 15))
            ],
          )
        ],
      ),
    );
  }
}