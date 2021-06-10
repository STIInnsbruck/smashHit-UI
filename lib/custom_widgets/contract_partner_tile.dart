import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';

class ContractPartnerTile extends StatelessWidget {

  User partner;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
      color: Colors.grey,
      child: Column(
        children: [
          Container(
            child: tileHeader("Name Surname"),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 150,
              height: 75,
              color: Colors.white,
            ),
            Container(
              width: 150,
              height: 75,
              color: Colors.white,
            ),
            Container(
              width: 150,
              height: 75,
              color: Colors.white,
            ),
            Container(
              width: 150,
              height: 75,
              color: Colors.white,
            ),
            Container(
              width: 150,
              height: 75,
              color: Colors.white,
            ),
          ],
        ),
        IconButton(icon: Icon(Icons.chevron_right), onPressed: () {})
      ],
    );
  }
}