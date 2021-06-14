import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';

class ContractPartnerTile extends StatelessWidget {

  User? partner;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;



    return Container(
      height: screenHeight / 5,
      width: screenWidth,
      margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      color: Colors.grey,
      child: Column(
        children: [
          Container(
            child: tileHeader("Name Surname"),
          ),
          Container(
            child: contractsScroller(),
          )
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
                  contractTile(),
                  contractTile(),
                  contractTile(),
                  contractTile(),
                  contractTile(),
                  contractTile(),
                  contractTile(),
                  contractTile(),
                ],
              ),
            ),
          ),
        ),
        IconButton(icon: Icon(Icons.chevron_right), onPressed: () {})
      ],
    );
  }

  Widget contractTile() {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      width: 150,
      height: 75,
      color: Colors.white,
    );
  }
}