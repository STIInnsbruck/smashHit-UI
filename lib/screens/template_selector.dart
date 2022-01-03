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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    bool isWide = _isWideScreen(screenWidth);

    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Scrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              children: [
                Text('Select a Template for Your Contract', style: TextStyle(fontSize: 32), textAlign: TextAlign.center),
                SizedBox(height: 20),
                isWide
                    ? bigScreenLayout(screenWidth, screenHeight)
                    : mediumScreenLayout(screenWidth)
              ]),
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
              templateTile('Generic Template', Icons.description, 'Generate a customizable generic contract.', Colors.white, screenWidth, widget.changeScreen),
              templateTile('E-Commerce Template', Icons.attach_money, 'Generate a sales related contract for selling or buying.', Colors.grey, screenWidth),
              templateTile('Games and Sports Template', Icons.sports_basketball, 'Generate a contract/clearance for players in a sports team.', Colors.grey, screenWidth)
            ]
        ),
        SizedBox(height: screenHeight / 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            templateTile('Education Template', Icons.school, 'Generate an educational contract, e.g. a study admission contract.', Colors.grey, screenWidth),
            templateTile('Government Template', Icons.account_balance_outlined, 'Generate a government related contract.', Colors.grey, screenWidth),
            templateTile('Personal Data Processing', Icons.person_search, 'Generate a contract for personal data processing.', Colors.grey, screenWidth)
          ],
        ),
      ],
    );
  }

  Widget mediumScreenLayout(double screenWidth) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              templateTile('Generic Template', Icons.description, 'Generate a customizable generic contract.', Colors.white, screenWidth, widget.changeScreen),
              templateTile('E-Commerce Template', Icons.attach_money, 'Generate a sales related contract for selling or buying.', Colors.grey, screenWidth),

            ]
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            templateTile('Games and Sports Template', Icons.sports_basketball, 'Generate a contract/clearance for players in a sports team.', Colors.grey, screenWidth),
            templateTile('Education Template', Icons.school, 'Generate an educational contract, e.g. a study admission contract.', Colors.grey, screenWidth),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            templateTile('Government Template', Icons.account_balance_outlined, 'Generate a government related contract.', Colors.grey, screenWidth),
            templateTile('Personal Data Processing', Icons.person_search, 'Generate a contract for personal data processing.', Colors.grey, screenWidth)
          ],
        ),
      ],
    );
  }

  bool _isWideScreen(double width) {
    if (width < 500) {
      return false;
    } else {
      return true;
    }
  }

  Widget templateTile(String templateType, IconData icon, String tooltipMessage, Color color, double width, [Function(int)? func]) {
    bool isWide = _isWideScreen(width);
    return Tooltip(
      message: tooltipMessage,
      child: MaterialButton(
        child: Expanded(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            height: isWide? 150 : width / 3,
            width: isWide? 150 : width / 3,
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
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(templateType, textAlign: TextAlign.center),
                Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraint) {
                        return Icon(
                          icon,
                          size: constraint.biggest.height
                        );
                      }
                    )
                ),
              ],
            ),
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