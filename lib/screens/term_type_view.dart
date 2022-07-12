import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import 'package:smashhit_ui/custom_widgets/term_type_tile.dart';

class TermTypeViewPage extends StatefulWidget {
  final Function(int, [String]) changeScreen;
  final User? user;
  final bool offlineMode;

  TermTypeViewPage(this.changeScreen, this.user, this.offlineMode);

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
          return TermTypeTile(termType: termTypeList![index], removeTermType: removeTermType, changeScreen: widget.changeScreen);
        }
      )
    );
  }

  void removeTermType(String termTypeId) {
    setState(() {
      termTypeList!.removeWhere((element) => element.id!.compareTo(termTypeId) == 0);
    });
  }

  Widget noTermTypesText() {
    return Expanded(
        child: Center(
            child: Text("There are currently no existing term types. Please create a new term type before creating a contract.")));
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