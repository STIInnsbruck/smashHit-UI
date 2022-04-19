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

    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text('Select a Template for Your Contract',
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            bigScreenLayout(screenWidth, screenHeight)
          ]),
    );
  }

  Widget bigScreenLayout(double screenWidth, double screenHeight) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            children: [
              Spacer(flex: 3),
              templateTile(
                  'Generic Template',
                  Icons.description,
                  "Generate a customizable generic contract.",
                  Colors.white,
                  widget.changeScreen),
              Spacer(),
              templateTile(
                  'E-Commerce Template',
                  Icons.attach_money,
                  "Generate a sales related contract for selling or buying",
                  Colors.grey),
              Spacer(),
              templateTile(
                  'Games and Sports Template',
                  Icons.sports_basketball,
                  "Generate a contract / clearance for players in a sports team.",
                  Colors.grey),
              Spacer(flex: 3),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 3),
              templateTile(
                  'Education Template',
                  Icons.school,
                  "Generate an education contract.",
                  Colors.grey,
                  widget.changeScreen),
              Spacer(),
              templateTile(
                  'Government Template',
                  Icons.account_balance,
                  "Generate a government related contract.",
                  Colors.grey),
              Spacer(),
              templateTile(
                  'Personal Data',
                  Icons.person_search,
                  "Generate a contract for personal data processing or sharing.",
                  Colors.grey),
              Spacer(flex: 3),
            ],
          ),
          Spacer(flex: 4)
        ],
      ),
    );
  }

  Widget templateTile(
      String templateType, IconData icon, String tooltipMessage, Color color,
      [Function(int)? onClick]) {
    return Expanded(
      flex: 2,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Tooltip(
          message: tooltipMessage,
          child: Container(
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
            child: MaterialButton(
              onPressed: () {
                if (onClick != null) {
                  onClick(1);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(templateType, textAlign: TextAlign.center),
                  LayoutBuilder(builder: (context, constraint) {
                    return Icon(icon, size: constraint.biggest.width - 30);
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
