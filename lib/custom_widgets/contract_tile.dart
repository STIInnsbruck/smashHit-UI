import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';

class ContractTile extends StatefulWidget {
  final Function(int, [String]) changeScreen;
  Contract? contract;

  ContractTile(this.changeScreen, this.contract);

  @override
  _ContractTileState createState() => _ContractTileState();
}

class _ContractTileState extends State<ContractTile> {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        //TODO: fix splash effect, currently it is behind the container
        splashColor: Colors.white,
        child: Container(
          margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
          width: 125,
          //height: height / 8,
          height: 100,
          decoration: BoxDecoration(color: Colors.grey[400], boxShadow: [
            BoxShadow(
                color: Colors.black45,
                blurRadius: 2.0,
                spreadRadius: 1.0,
                offset: Offset(2.0, 2.0))
          ]),
          child: Center(
            child: Row(
              children: [
                Icon(Icons.folder_shared, size: 75),
                Text('${widget.contract!.contractId}'),
              ],
            ),
          ),
        ),
        onTap: () {
          print('${widget.contract!.contractId!.substring(45, widget.contract!.contractId!.length)}');
          widget.changeScreen(2, '${widget.contract!.contractId!.substring(45, widget.contract!.contractId!.length)}');
        },
      ),
    );
  }


}