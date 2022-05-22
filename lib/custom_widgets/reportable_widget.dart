import 'package:flutter/material.dart';

class ReportableWidget extends StatefulWidget {

  Widget child;
  String? comment;

  ReportableWidget({required this.child});

  @override
  _ReportableWidgetState createState() => _ReportableWidgetState();
}

class _ReportableWidgetState extends State<ReportableWidget> {

  bool _isAViolation = false;
  bool _displayComment = false;
  Color _backgroundColor = Colors.white;
  TextEditingController reportViolationController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _displayComment && _isAViolation ? Colors.black87 : _backgroundColor,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 5, 40, 5),
            child: Stack(
              children: [
                widget.child,
              ],
            )
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              child:
              _isAViolation ?
              IconButton(
                  iconSize: 30,
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.warning, color: Colors.red),
                  onPressed: () {
                    _reviewReportViolationDialog();
                  }) :
              IconButton(
                iconSize: 30,
                padding: EdgeInsets.zero,
                icon: Icon(Icons.add, color: Colors.blue),
                onPressed: () {
                  _showReportViolationDialog();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void _toggleViolation() {
    setState(() {
      _isAViolation = !_isAViolation;
      if (_isAViolation) {
        _backgroundColor = Colors.orange;
      } else {
        _backgroundColor = Colors.white;
      }
    });
  }

  void _setComment(String value) {
    setState(() {
      widget.comment = value;
    });
  }

  void _showReportViolationDialog() {
    reportViolationController = new TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('What is the violation here?'),
            content: TextField(
              controller: reportViolationController,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(hintText: "Please enter and explain the violation."),
            ),
            actions: [
              MaterialButton(
                  onPressed: () {
                    _dismissDialog();
                  },
                  color: Colors.white,
                  child: Text('Cancel, no violation')
              ),
              MaterialButton(
                  onPressed: () {
                    _setComment(reportViolationController.text);
                    _toggleViolation();
                    _dismissDialog();
                  },
                  color: Colors.blue,
                  child: Text('Add violation', style: TextStyle(color: Colors.white))
              )
            ],
          );
        }
    );
  }

  void _reviewReportViolationDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Would you like to remove the entered violation below?'),
            content: Text(widget.comment!),
            actions: [
              MaterialButton(
                  onPressed: () {
                    _dismissDialog();
                  },
                  color: Colors.white,
                  child: Text('No, leave it')
              ),
              MaterialButton(
                  onPressed: () {
                    _setComment("");
                    _toggleViolation();
                    _dismissDialog();
                  },
                  color: Colors.red,
                  child: Text('Yes, delete', style: TextStyle(color: Colors.white))
              )
            ],
          );
        }
    );
  }

  _dismissDialog() {
    Navigator.pop(context);
  }

}