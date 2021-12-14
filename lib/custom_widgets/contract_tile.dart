import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/data/data_provider.dart';

class ContractTile extends StatefulWidget {
  final Function(int, [String]) changeScreen;
  final Function() refresh;
  Contract? contract;

  ContractTile(this.changeScreen, this.refresh, this.contract);

  @override
  _ContractTileState createState() => _ContractTileState();
}

class _ContractTileState extends State<ContractTile> {

  DataProvider dataProvider = new DataProvider();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Material(
      child: InkWell(
        //TODO: fix splash effect, currently it is behind the container
        splashColor: Colors.white,
        child: _isSmallScreen(screenWidth)? smallContractTile() : bigContractTile(),
        onTap: () {
          widget.changeScreen(2, '${_formatContractUri(widget.contract!.contractId!)}');
        },
      ),
    );
  }

  bool _isSmallScreen(double width) {
    if (width <= 500.0) {
      return true;
    }
    return false;
  }

  Container bigContractTile() {
    return Container(
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
            Expanded(
                flex: 24,
                child: Text('${_formatContractUri(widget.contract!.contractId!)}', overflow: TextOverflow.ellipsis)
            ),
            //Spacer(flex: 25),
            statusIconByContractStatus(),
            Spacer(flex: 3),
            editContractButton(_formatContractUri(widget.contract!.contractId!)),
            Spacer(),
            deleteContractButton(_formatContractUri(widget.contract!.contractId!)),
            Spacer()
          ],
        ),
      ),
    );
  }

  Container smallContractTile() {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      width: 125,
      //height: height / 8,
      height: 150,
      decoration: BoxDecoration(color: Colors.grey[400], boxShadow: [
        BoxShadow(
            color: Colors.black45,
            blurRadius: 2.0,
            spreadRadius: 1.0,
            offset: Offset(2.0, 2.0))
      ]),
      child: Center(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Icon(Icons.folder_shared, size: 75),
                  SizedBox(width: 200,child: Text('${_formatContractUri(widget.contract!.contractId!)}', overflow: TextOverflow.ellipsis))
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1)
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Status:"),
                          statusIconByContractStatus(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(width: 1),
                          )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Actions:"),
                            editContractButton(_formatContractUri(widget.contract!.contractId!)),
                            deleteContractButton(_formatContractUri(widget.contract!.contractId!)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget editContractButton(String contractId) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.edit, size: 30),
      onPressed: () {
        widget.changeScreen(6, contractId);
      },
    );
  }

  Widget deleteContractButton(String contractId) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.delete, size: 30),
      onPressed: () {
        showConfirmDeletionDialog(contractId);
      },
    );
  }

  showConfirmDeletionDialog(String contractId) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning, size: 40, color: Colors.red),
                Container(height: 20),
                Text("Are you sure you want to delete the contract: $contractId?"),
              ],
            ),
            actions: [
              MaterialButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              MaterialButton(
                  child: Text('Delete', style: TextStyle(color: Colors.white)),
                  color: Colors.red,
                  onPressed: () async {
                    if (await dataProvider.deleteContractById(contractId)) {
                      Navigator.of(context).pop();
                      showSuccessfulDeletionDialog(contractId);
                    } else {
                      Navigator.of(context).pop();
                      showFailedDeletionDialog(contractId);
                    }
                  }
              ),
            ],
          );
        });
  }

  showSuccessfulDeletionDialog(String contractId) {
    widget.refresh();
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Success!', textAlign: TextAlign.center),
          contentPadding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            Text('The contract $contractId was successfully deleted!', textAlign: TextAlign.center),
            MaterialButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],

        );
      }
    );
  }

  showFailedDeletionDialog(String contractId) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Error!'),
            children: [
              Icon(Icons.error, color: Colors.red, size: 60),
              Text('The contract $contractId could not be deleted!'),
              MaterialButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],

          );
        }
    );
  }

  String _formatContractUri(String contractUri) {
    int length = contractUri.length;
    return contractUri.substring(45, length);
  }

  Widget statusIconByContractStatus() {
    switch (widget.contract!.getContractStatusAsInt()) {
      case 0:
        return Icon(Icons.description, color: Colors.grey, size: 30);
      case 1:
        return Icon(Icons.work, color: Colors.grey, size: 30);
      case 2:
        return Icon(Icons.check_circle, color: Colors.green, size: 30);
      case 5:
        return Icon(Icons.report, color: Colors.red, size: 30);
    }
    return Icon(Icons.check_circle, color: Colors.green, size: 30);
  }

}