import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProfileManagerPage extends StatefulWidget {
  @override
  _ProfileManagerPage createState() => _ProfileManagerPage();
}

class _ProfileManagerPage extends State<ProfileManagerPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      child: Row(
        children: [

          _rightSideBar(screenWidth * 0.25, screenHeight)
        ],
      ),
    );
  }


  Widget _rightSideBar(double width, double height) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 300
      ),
      child: Container(
        width: width,
        height: height,
        color: Colors.blue,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          //mainAxisSize: MainAxisSize.min,
          children: [
            Spacer(flex: 1),
            _sharingAmountWidget(width, height, 73.0),
            Spacer(flex: 1),
            _acceptanceChanceWidget(width, height, 37.0),
            Spacer(flex: 19)
          ],
        ),
      ),
    );
  }

  Widget _sharingAmountWidget(double width, double height, double percentage) {
    return Container(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircularPercentIndicator(
            radius: (width - 20) / 2,
            percent: percentage / 100,
            progressColor: Colors.green,
            center: Text("$percentage%", style: TextStyle(color: Colors.white, fontSize: 40)),
            lineWidth: 10,
          ),
          Text("Total Possible Sharing Achieved", style: TextStyle(color: Colors.white))
        ],
      )
    );
  }

  Widget _acceptanceChanceWidget(double width, double height, double percentage) {
    return Container(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircularPercentIndicator(
              radius: (width - 20) / 2,
              percent: percentage / 100,
              progressColor: Colors.red,
              center: Text("$percentage%", style: TextStyle(color: Colors.white, fontSize: 40)),
              lineWidth: 10,
            ),
            Text("Total Possible Sharing Achieved", style: TextStyle(color: Colors.white))
          ],
        )
    );
  }

  Widget _personalDataValueBar(double width, double height, double min, double max) {
    return Container();
  }
}