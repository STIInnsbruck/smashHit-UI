import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/data/data_provider.dart';

class TermTypeTile extends StatefulWidget {
  final Function(String) removeTermType;
  final TermType termType;

  TermTypeTile({required this.termType, required this.removeTermType});

  @override
  _TermTypeTileState createState() => _TermTypeTileState();
}

class _TermTypeTileState extends State<TermTypeTile> {

  bool expand = false;
  DataProvider dataProvider = new DataProvider();

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
                Expanded(
                  flex: 28,
                  child: MaterialButton(
                    height: double.infinity,
                    onPressed: () {
                      setState(() {
                        expand = !expand;
                      });
                    },
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: Icon(Icons.description, size: 25)),
                        Expanded(
                            flex: 22,
                            child: Text('Name: ${widget.termType.name}\tID: ${widget.termType.id}', overflow: TextOverflow.ellipsis)
                        ),
                        //Spacer(flex: 25),
                        Spacer(flex: 3),
                      ],
                    ),
                  ),
                ),
                editTermTypeButton(widget.termType.id!),
                Spacer(),
                deleteTermTypeButton(widget.termType.id!),
                Spacer()
              ],
            ),
        )
    );
  }

  Widget editTermTypeButton(String contractId) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.edit, size: 30),
      onPressed: () {
        print("edit term type pressed.");
      },
    );
  }

  Widget deleteTermTypeButton(String termTypeId) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.delete, size: 30),
      onPressed: () {
        showConfirmDeletionDialog(termTypeId);
      },
    );
  }

  showConfirmDeletionDialog(String termTypeId) async {
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
                Text("Are you sure you want to delete the term type: $termTypeId?"),
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
                    if (await dataProvider.deleteTermTypeById(termTypeId)) {
                      widget.removeTermType(widget.termType.id!);
                      Navigator.of(context).pop();
                      showSuccessfulDeletionDialog(termTypeId);
                    } else {
                      Navigator.of(context).pop();
                      showFailedDeletionDialog(termTypeId);
                    }
                  }
              ),
            ],
          );
        });
  }

  showSuccessfulDeletionDialog(String termTypeId) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Success!', textAlign: TextAlign.center),
            contentPadding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 100),
              Text('The term type $termTypeId was successfully deleted!', textAlign: TextAlign.center),
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

  showFailedDeletionDialog(String termTypeId) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Error!'),
            children: [
              Icon(Icons.error, color: Colors.red, size: 60),
              Text('The term type $termTypeId could not be deleted!'),
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

}

