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
                Text('Contract ID: ${_formatContractUri(widget.contract!.contractId!)}'),
                Spacer(),

              ],
            ),
          ),
        ),
        onTap: () {
          widget.changeScreen(2, '${_formatContractUri(widget.contract!.contractId!)}');
        },
      ),
    );
  }

  Widget editContractButton(String contractId) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        print("trying to edit contract $contractId");
      },
    );
  }

  Widget deleteContractButton(String contractId) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        print("trying to delete contract $contractId");
      },
    );
  }

  showConfirmDeletionDialog() {
    //TODO: display a reassurance dialog to delete a contract.
  }

  String _formatContractUri(String contractUri) {
    int length = contractUri.length;
    return contractUri.substring(45, length);
  }

}