import 'package:flutter/material.dart';

/// A contractStepHeader is a clickable widget that is used to collapse a
/// contract step. If the current step of a contract is completed, then the
/// header will turn green, otherwise it stays grey.
/// Double [width] is given to determine the width of the header.
/// Bool [stepComplete] is the boolean state for a current step. If this is set
/// to true, then the header will change to green, otherwise grey.
/// Function [onPressed] is the callback function needed to change update
/// [stepComplete] and collapse/expand the current contract step.

Widget contractStepHeader(double width, bool stepComplete, Function onPressed) {
  return MaterialButton(
      child: Container(
        width: width,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
            color: stepComplete == true ? Colors.green : Colors.grey,
            boxShadow: [
              BoxShadow(
                  color: Colors.black45,
                  blurRadius: 25.0,
                  spreadRadius: 5.0,
                  offset: Offset(10.0, 10.0))
            ]),
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Align(
            child: Row(
              children: [
                Expanded(
                    child: Text("Step 1. Contract Base Information",
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1)),
                SizedBox(width: 10),
                stepComplete == false
                    ? Container()
                    : Icon(Icons.check, color: Colors.white, size: 30)
              ],
            ),
            alignment: Alignment.centerLeft),
      ),
      onPressed: () => onPressed());
}