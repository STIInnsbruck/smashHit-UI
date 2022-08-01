import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/data/data_provider.dart';

class ObligationTile extends StatefulWidget {
  final Function(int, [String]) changeScreen;
  final Obligation? obligation;
  final String? userId;
  final int? index;

  ObligationTile(this.changeScreen, this.obligation, this.userId, this.index);

  @override
  _ObligationTileState createState() => _ObligationTileState();
}

class _ObligationTileState extends State<ObligationTile> {
  DataProvider dataProvider = new DataProvider();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Material(
      child: InkWell(
        //TODO: fix splash effect, currently it is behind the container
        splashColor: Colors.white,
        child: _isSmallScreen(screenWidth)
            ? smallContractTile()
            : bigContractTile(),
        onTap: () {
          widget.changeScreen(2, '${widget.obligation!.contractId!}');
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
            Expanded(child: Center(child: Text("${widget.index}."))),
            Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: Text("Obligation"))),
            Expanded(
                flex: 8,
                child: Text('${widget.obligation!.id!}',
                    overflow: TextOverflow.ellipsis)),
            Expanded(
                flex: 16,
                child: Text('${widget.obligation!.description}',
                    overflow: TextOverflow.ellipsis)),
            Expanded(flex: 2, child: Text('${widget.obligation!.endDate!.toIso8601String().substring(0,10)}', textAlign: TextAlign.left,)),
            Expanded(flex: 2, child: obligationIconByStatus(widget.obligation!.state!)),
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
                  SizedBox(
                      width: 200,
                      child: Text('${widget.obligation!.contractId!}',
                          overflow: TextOverflow.ellipsis))
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration:
                BoxDecoration(border: Border(top: BorderSide(width: 1))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Status:"),
                          obligationIconByStatus(
                              widget.obligation!.state!),
                        ],
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

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }


  Tooltip obligationIconByStatus(String status) {
    if (status.contains("Pending") || status.contains("pending")) {
      return Tooltip(
          message: "Clause is pending.",
          child: Icon(Icons.pending, color: Colors.grey, size: 30));
    } else if (status.contains("Invalid") || status.contains("invalid")) {
      return Tooltip(
          message: "Clause is invalid.",
          child: Icon(Icons.warning, color: Colors.yellow, size: 30));
    } else if (status.contains("Fulfilled") || status.contains("fulfilled")) {
      return Tooltip(
          message: "Clause is fulfilled.",
          child: Icon(Icons.check_circle, color: Colors.green, size: 30));
    } else if (status.contains("Valid") || status.contains("valid")) {
      return Tooltip(
          message: "Clause is valid.",
          child: Icon(Icons.done, color: Colors.green, size: 30));
    } else {
      return Tooltip(
          message: "Clause status could not be read.",
          child: Icon(Icons.question_mark, color: Colors.grey, size: 30));
    }
  }
}
