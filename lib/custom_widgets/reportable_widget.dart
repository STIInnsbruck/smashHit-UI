import 'package:flutter/material.dart';

class ReportableWidget extends StatefulWidget {

  Widget widget;
  String? comment;

  ReportableWidget({required this.widget});

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
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: 0.99,
            child: Container(
              color: _backgroundColor,
              margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
              child: InkWell(
                  onTap: () => null,
                  onHover: (val) {
                    setState(() {
                      print("Setting displayComment to $val");
                      _displayComment = !_displayComment;
                    });
                  },
                  child: Stack(
                    children: [
                      Container(
                        color: _displayComment && _isAViolation ?
                            Colors.black87 :
                            Colors.white12,
                        child: widget.widget,
                      ),
                      _displayComment && _isAViolation ?
                          Text(widget.comment!, style: TextStyle(color: Colors.white)) :
                          Container()
                    ],
                  )
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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
                ],
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
              TextButton(
                  onPressed: () {
                    _dismissDialog();
                  },
                  child: Text('Cancel, no violation')
              ),
              TextButton(
                  onPressed: () {
                    _setComment(reportViolationController.text);
                    _toggleViolation();
                    _dismissDialog();
                  },
                  child: Text('Add violation')
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
              TextButton(
                  onPressed: () {
                    _dismissDialog();
                  },
                  child: Text('No, leave it')
              ),
              TextButton(
                  onPressed: () {
                    _setComment("");
                    _toggleViolation();
                    _dismissDialog();
                  },
                  child: Text('Yes, delete')
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