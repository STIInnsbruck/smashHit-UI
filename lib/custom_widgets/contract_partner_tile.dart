import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';

class ContractPartnerTile extends StatelessWidget {
  User? partner;

  static List<Widget> contractList = [
    contractTile(Icons.car_rental),
    contractTile(Icons.home),
    contractTile(Icons.person_search_rounded),
    contractTile(Icons.work)
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenHeight / 4,
      width: screenWidth,
      margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      color: Colors.grey,
      child: Column(
        children: [
          Container(
            child: tileHeader("Name Surname"),
          ),
          Spacer(),
          Container(
            child: contractsScroller(),
          ),
          Spacer()
        ],
      ),
    );
  }

  Row tileHeader(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 22,
            child: Icon(Icons.person),
          ),
        ),
        Text(name)
      ],
    );
  }

  Widget contractsScroller() {
    return Row(
      children: [
        IconButton(icon: Icon(Icons.chevron_left), onPressed: () {}),
        Expanded(
          child: Scrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  contractTile(Icons.car_rental),
                  contractTile(Icons.home),
                  contractTile(Icons.person_search_rounded),
                  contractTile(Icons.work)
                ],
              ),
            ),
          ),
        ),
        IconButton(icon: Icon(Icons.chevron_right), onPressed: () {})
      ],
    );
  }

  static Widget contractTile(IconData iconData) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      width: 150,
      height: 100,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.black45,
            blurRadius: 2.0,
            spreadRadius: 1.0,
            offset: Offset(2.0, 2.0))
      ]),
      child: Center(
        child: Icon(iconData, size: 75),
      ),
    );
  }
}
