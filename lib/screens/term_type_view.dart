import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/data/data_provider.dart';

class TermTypeViewPage extends StatefulWidget {
  final Function(int, [String]) changeScreen;
  final User? user;

  TermTypeViewPage(this.changeScreen, this.user);

  @override
  _TermTypeViewPage createState() => _TermTypeViewPage();
}

class _TermTypeViewPage extends State<TermTypeViewPage> {

  DataProvider dataProvider = new DataProvider();

  late Future<List<TermType>> futureTermTypeList = [] as Future<List<TermType>>;
  List<TermType>? termTypeList = [];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        children: [
          FutureBuilder<List<TermType>>(
              future: futureTermTypeList = dataProvider.fetchAllTermTypes(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  termTypeList = snapshot.data;
                  return Column(
                    children: [
                      snapshot.data!.isEmpty
                          ? noTermTypesText() : termTypeListWidget()
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return Center(child: CircularProgressIndicator());
              }
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: createTermTypeButton(),
          ),
        ],
      )
    );
  }

  Widget termTypeListWidget() {
    return Expanded(
      child: ListView.builder(
        itemCount: termTypeList!.length,
        itemBuilder: (BuildContext context, int index) {
          return termTypeTile(termTypeList![index]);
        }
      )
    );
  }

  Widget termTypeTile(TermType termType) {
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
        child: Row(
          children: [
            Expanded(flex: 2, child: Icon(Icons.description, size: 25)),
            Expanded(
                flex: 22,
                child: Text('Name: ${termType.name}\tID: ${termType.id}', overflow: TextOverflow.ellipsis)
            ),
            //Spacer(flex: 25),
            Spacer(flex: 3),
            editTermTypeButton(termType.id!),
            Spacer(),
            deleteTermTypeButton(termType.id!),
            Spacer()
          ],
        )
      )
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
                      setState(() {
                        termTypeList!.removeWhere((element) => element.id!.compareTo(termTypeId) == 0);
                      });
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

  Widget noTermTypesText() {
    return Expanded(
        child: Center(
            child: Text("There are currently no existing term types. Please create a new term type before creating a contract.")));
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

  Widget createTermTypeButton() {
    return Container(
      child: MaterialButton(
          minWidth: 125,
          onPressed: () async {
            widget.changeScreen(9);
          },
          color: Colors.green,
          hoverColor: Colors.lightGreen,
          child: Text("Create A New Type", style: TextStyle(color: Colors.white))
      ),
    );
  }

}