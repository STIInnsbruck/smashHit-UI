import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/data/data_provider.dart';

class ContractorTile extends StatefulWidget {
  final Function(int, [String]) changeScreen;
  final User contractor;

  ContractorTile({required this.contractor, required this.changeScreen});

  @override
  _ContractorTileState createState() => _ContractorTileState();
}

class _ContractorTileState extends State<ContractorTile> {

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
        width: 125,
        height: 75,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black45,
              blurRadius: 2.0,
              spreadRadius: 1.0,
              offset: Offset(2.0, 2.0))
        ]),
        child: Center(
          child:
          Row(
            children: [
              Expanded(child: Text(widget.contractor.name!, textAlign: TextAlign.left)),
              Expanded(child: Text(widget.contractor.email!, textAlign: TextAlign.left)),
              Spacer(flex: 2)
            ],
          ),
        )
    );
  }
}

