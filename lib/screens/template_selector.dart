import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';

class TemplateSelector extends StatefulWidget {
  final Function(int) changeScreen;
  final User? user;

  TemplateSelector(this.changeScreen, this.user);

  @override
  _TemplateSelectorState createState() => new _TemplateSelectorState();
}

class _TemplateSelectorState extends State<TemplateSelector> {

  static const BIG_SCREEN = 0;
  static const MEDIUM_SCREEN = 1;
  static const SMALL_SCREEN = 2;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    int screenSize = _checkScreenSize(screenWidth);

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
                  Text('Select a Template for Your Contract', style: TextStyle(fontSize: 32)),
                  Container(height: 20),
                  screenSize == 0
                  ? bigScreenLayout(screenWidth, screenHeight)
                      : screenSize == 1
                  ? mediumScreenLayout(screenWidth, screenHeight)
                      : smallScreenLayout(screenWidth, screenHeight)
                ]),
          ),
        ),
      ),
    );
  }

  Widget bigScreenLayout(double screenWidth, double screenHeight) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              templateTile('Generic Template', Icons.description, 'Generate a customizable generic contract.', Colors.white, widget.changeScreen),
              Container(width: screenWidth / 25),
              templateTile('E-Commerce Template', Icons.attach_money, 'Generate a sales related contract for selling or buying.', Colors.grey),
              Container(width: screenWidth / 25),
              templateTile('Games and Sports Template', Icons.sports_basketball, 'Generate a contract/clearance for players in a sports team.', Colors.grey)
            ]
        ),
        Container(height: screenHeight / 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            templateTile('Education Template', Icons.school, 'Generate an educational contract, e.g. a study admission contract.', Colors.grey),
            Container(width: screenWidth / 25),
            templateTile('Government Template', Icons.account_balance_outlined, 'Generate a government related contract.', Colors.grey),
            Container(width: screenWidth / 25),
            templateTile('Personal Data Processing', Icons.person_search, 'Generate a contract for personal data processing.', Colors.grey)
          ],
        ),
      ],
    );
  }

  Widget mediumScreenLayout(double screenWidth, double screenHeight) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              templateTile('Generic Template', Icons.description, 'Generate a customizable generic contract.', Colors.white, widget.changeScreen),
              templateTile('E-Commerce Template', Icons.attach_money, 'Generate a sales related contract for selling or buying.', Colors.grey),

            ]
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            templateTile('Games and Sports Template', Icons.sports_basketball, 'Generate a contract/clearance for players in a sports team.', Colors.grey),
            templateTile('Education Template', Icons.school, 'Generate an educational contract, e.g. a study admission contract.', Colors.grey),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            templateTile('Government Template', Icons.account_balance_outlined, 'Generate a government related contract.', Colors.grey),
            templateTile('Personal Data Processing', Icons.person_search, 'Generate a contract for personal data processing.', Colors.grey)
          ],
        ),
      ],
    );
  }

  Widget smallScreenLayout(double screenWidth, double screenHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            templateTile('Generic Template', Icons.description, 'Generate a customizable generic contract.', Colors.white, widget.changeScreen),
            SizedBox(height: 20),
            templateTile('E-Commerce Template', Icons.attach_money, 'Generate a sales related contract for selling or buying.', Colors.grey),
            SizedBox(height: 20),
            templateTile('Games and Sports Template', Icons.sports_basketball, 'Generate a contract/clearance for players in a sports team.', Colors.grey),
            SizedBox(height: 20),
            templateTile('Education Template', Icons.school, 'Generate an educational contract, e.g. a study admission contract.', Colors.grey),
            SizedBox(height: 20),
            templateTile('Government Template', Icons.account_balance_outlined, 'Generate a government related contract.', Colors.grey),
            SizedBox(height: 20),
            templateTile('Personal Data Processing', Icons.person_search, 'Generate a contract for personal data processing.', Colors.grey),
          ],
        ),
      ],
    );
  }

  int _checkScreenSize(double width) {
    if (width >= 705) {
      return BIG_SCREEN;
    } else if (width >= 450 && width < 705) {
      return MEDIUM_SCREEN;
    } else {
      return SMALL_SCREEN;
    }
  }

  Widget templateTile(String templateType, IconData icon, String tooltipMessage, Color color, [Function(int)? func]) {
    return Tooltip(
      message: tooltipMessage,
      child: MaterialButton(
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          height: 200,
          width: 200,
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
              Text(templateType, style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
              Spacer(),
              Icon((icon), size: 100),
              Spacer(flex: 2)
            ],
          ),
        ),
        onPressed: () {
          if(func != null) {
            func(1);
          }
        }
      ),
    );
  }

}