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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: 1,
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
                      icon: Icon(Icons.warning, color: Colors.yellow),
                      onPressed: () {
                        print("removing report.");
                        _toggleViolation();
                      }) :
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.yellow),
                    onPressed: () {
                      print("tapped report element.");
                      _toggleViolation();
                      _setComment("Some comment");
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

}