import 'package:flutter/material.dart';

class ProfileStatisticCard extends StatefulWidget {
  final String title;
  final String tooltipMessage;
  final String value;

  ProfileStatisticCard({required this.title, required this.tooltipMessage, required this.value});

  @override
  _ProfileStatisticCardState createState() => _ProfileStatisticCardState();
}

class _ProfileStatisticCardState extends State<ProfileStatisticCard> {

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 0, 5),
                    child: Text(widget.title),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Tooltip(
                      message: widget.tooltipMessage,
                      child: Icon(Icons.info, color: Colors.grey),
                    )
                )
              ],
            ),
            Container(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 5, 10),
                  child: Text(widget.value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ),
            ),
          ],
        )
    );
  }

}