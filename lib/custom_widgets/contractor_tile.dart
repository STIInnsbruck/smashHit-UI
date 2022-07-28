import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/data/data_provider.dart';

class ContractorTile extends StatefulWidget {
  final Function(int, [String]) changeScreen;
  final User contractor;

  ContractorTile({required this.contractor, required this.changeScreen});

  @override
  _ContractorTileState createState() => _ContractorTileState();
}

class _ContractorTileState extends State<ContractorTile> {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          widget.changeScreen(8, '${widget.contractor.id}');
        },
        child: Container(
            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
            width: 125,
            height: 75,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black45,
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
                  offset: Offset(2.0, 2.0))
            ]),
            child: Center(
              child:
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(child: Row(
                    children: [
                      Icon(Icons.business, size: 25),
                      Text("Business", textAlign: TextAlign.center)
                    ],
                  )),
                  Expanded(child: Text(widget.contractor.name!, textAlign: TextAlign.left)),
                  Expanded(child: Text(widget.contractor.email!, textAlign: TextAlign.left)),
                  Expanded(child: starRating(widget.contractor.rating!)),
                  Spacer(flex: 1)
                ],
              ),
            )
        ),
      ),
    );
  }

  Widget starRating(int rating) {
    List<Icon> stars = [];
    //max amount of starts is 5
    int numEmptyStars = 5 - rating;
    for(int i = 0; i < rating; i++) {
      stars.add(Icon(Icons.star, color: Colors.yellow, size: 25));
    }
    for(int i = 0; i < numEmptyStars; i++) {
      stars.add(Icon(Icons.star_border, color: Colors.grey, size: 25));
    }
    return Row(
      children: [
        stars[0],
        stars[1],
        stars[2],
        stars[3],
        stars[4],
      ],
    );
  }
}

