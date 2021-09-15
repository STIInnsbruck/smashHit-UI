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
                                templateTile(screenWidth, screenHeight, 'Generic Template', Icons.description, 'Generate a customizable generic contract.', Colors.white),
                                Container(width: screenWidth / 20),
                                templateTile(screenWidth, screenHeight, 'E-Commerce Template', Icons.attach_money, 'Generate a sales related contract for selling or buying.', Colors.grey),
                                Container(width: screenWidth / 20),
                                templateTile(screenWidth, screenHeight, 'Games and Sports Template', Icons.sports_basketball, 'Generate a contract/clearance for players in a sports team.', Colors.grey)

                              ]
                          ),
                          Container(height: screenHeight / 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              templateTile(screenWidth, screenHeight, 'Education Template', Icons.school, 'Generate an educational contract, e.g. a study admission contract.', Colors.grey),
                              Container(width: screenWidth / 20),
                              templateTile(screenWidth, screenHeight, 'Government Template', Icons.account_balance_outlined, 'Generate a government related contract.', Colors.grey),
                              Container(width: screenWidth / 20),
                              templateTile(screenWidth, screenHeight, 'Personal Data Processing', Icons.person_search, 'Generate a contract for personal data processing.', Colors.grey)
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

  Widget templateTile(double width, double height, String templateType, IconData icon, String tooltipMessage, Color color) {
    return Tooltip(
      message: tooltipMessage,
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        height: height / 4,
        width: width / 5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
            color: color,
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
            Text(templateType, style: TextStyle(fontSize: 20)),
            Spacer(),
            Icon((icon), size: height / 8),
            Spacer(flex: 2)
          ],
        ),
      ),
    );
  }

}