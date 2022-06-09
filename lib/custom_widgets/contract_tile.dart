import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/data/data_provider.dart';

class ContractTile extends StatefulWidget {
  final Function(int, [String]) changeScreen;
  final Function() refresh;
  final Contract? contract;

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
          widget.changeScreen(2, '${widget.contract!.contractId!}');
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
      height: 75,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.black45,
            blurRadius: 2.0,
            spreadRadius: 1.0,
            offset: Offset(2.0, 2.0))
      ]),
      child: Center(
        child: Row(
          children: [
            Expanded(flex: 2, child: Icon(Icons.folder_shared, size: 25)),
            Expanded(
                flex: 10,
                child: Text('${widget.contract!.contractId!}', overflow: TextOverflow.ellipsis)
            ),
            //Spacer(flex: 25),
            Expanded(
              flex: 11,
              child: Text('${widget.contract!.purpose}', overflow: TextOverflow.ellipsis)
            ),
            contractIconByStatus(widget.contract!.contractStatus!),
            Spacer(flex: 3),
            editContractButton(widget.contract!.contractId!),
            Spacer(),
            deleteContractButton(widget.contract!.contractId!),
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
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
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
                  SizedBox(width: 200,child: Text('${widget.contract!.contractId!}', overflow: TextOverflow.ellipsis))
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
                          contractIconByStatus(widget.contract!.contractStatus!),
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
                            editContractButton(widget.contract!.contractId!),
                            deleteContractButton(widget.contract!.contractId!),
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

  Tooltip contractIconByStatus(String status) {
    if (status.compareTo("hasCreated") == 0) {
      return Tooltip(
          message: "The contract has recently been created.",
          child: Icon(Icons.new_releases, color: Colors.blue, size: 30));
    } else if (status.compareTo("hasPending") == 0) {
      return Tooltip(
          message: "The contract is still awaiting signatures.",
          child: Icon(Icons.pending, color: Colors.grey, size: 30));
    } else if (status.compareTo("hasSigned") == 0) {
      return Tooltip(
          message: "The contract has been signed by all parties.",
          child: Icon(Icons.thumb_up, color: Colors.blue, size: 30));
    } else if (status.compareTo("hasTerminated") == 0) {
      return Tooltip(
          message: "The contract has been terminated.",
          child: Icon(Icons.do_not_disturb, color: Colors.yellow, size: 30));
    } else if (status.compareTo("hasRenewed") == 0) {
      return Tooltip(
          message: "The contract has been renewed.",
          child: Icon(Icons.history, color: Colors.blue, size: 30));
    } else if (status.compareTo("hasExpired") == 0) {
      return Tooltip(
          message: "The contract has expired.",
          child: Icon(Icons.hourglass_bottom, color: Colors.blue, size: 30));
    } else {
      return Tooltip(
          message: "The contract has recently been created.",
          child: Icon(Icons.new_releases, color: Colors.blue, size: 30));
    }
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
                    _dismissDialog();
                    _showDeletingDialog();
                    if (await dataProvider.deleteContractById(contractId)) {
                      _dismissDialog();
                      showSuccessfulDeletionDialog(contractId);
                    } else {
                      _dismissDialog();
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

  _showDeletingDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Deleting...', textAlign: TextAlign.center),
            contentPadding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
            children: [
              Icon(Icons.schedule, color: Colors.green, size: 100),
              Text('Your contract is being deleted.', textAlign: TextAlign.center),
              Container(height: 5),
              Center(child: CircularProgressIndicator())
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

  _dismissDialog() {
    Navigator.pop(context);
  }

}