import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';

class TemplateSelector extends StatefulWidget {
  final Function(int) changeScreen;
  User? user;

  TemplateSelector(this.changeScreen, this.user);

  @override
  _TemplateSelectorState createState() => new _TemplateSelectorState();
}

class _TemplateSelectorState extends State<TemplateSelector> {



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: screenHeight,
          minHeight: screenHeight,
        ),
        child: Scrollbar(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                genericTile(screenWidth, screenHeight),
                                Container(width: screenWidth / 20),
                                genericTile(screenWidth, screenHeight),
                              ]
                          ),
                          Container(height: screenHeight / 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              genericTile(screenWidth, screenHeight),
                              Container(width: screenWidth / 20),
                              genericTile(screenWidth, screenHeight),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  Widget genericTile(double width, double height) {
    return Tooltip(
      message: 'Generate a customizable generic contract.',
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        height: height / 3,
        width: width / 4,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black45,
                  blurRadius: 5,
                  spreadRadius: 2.5,
                  offset: Offset(2.5, 2.5))
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Generic Contract", style: TextStyle(fontSize: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //first 45 characters are the URI from the ontology
              ],
            )
          ],
        ),
      ),
    );
  }

}