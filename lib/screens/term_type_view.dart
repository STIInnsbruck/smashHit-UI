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
                          ? Center(child: Text("No TermTypes")) : termTypeListWidget()
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return Center(child: CircularProgressIndicator());
              }
          ),
          Align(
            alignment: Alignment.bottomRight,
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
                    print("confirmed term type deletion");
                  }
              ),
            ],
          );
        });
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