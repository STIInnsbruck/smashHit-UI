import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';

class TermWidget extends StatefulWidget {
  Term term;
  Function(String) onDeletePressed;
  String id;
  TextEditingController textController = new TextEditingController();

  TermWidget(this.term, this.onDeletePressed, this.id);

  @override
  _TermWidgetState createState() => new _TermWidgetState();
}

class _TermWidgetState extends State<TermWidget> {
  bool expand = true;

  @override
  void initState() {
    super.initState();
    widget.textController.text = widget.term.description!;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      color: Colors.grey[300],
      child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: () => {
                        setState(() {
                          expand =  !expand;
                        })
                      },
                      child: Row(
                          children: [
                            expand
                                ? Icon(Icons.unfold_less, color: Colors.black)
                                : Icon(Icons.unfold_more, color: Colors.black),
                            Text("${widget.term.name}", style: TextStyle(color: Colors.black)),
                          ]
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => {
                      widget.onDeletePressed(widget.id)
                    },
                    icon: Icon(Icons.delete_forever, color: Colors.red),
                  )
                ],
              ),
            ),
            expand
                ? Container(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    height: 200,
                    child: TextField(
                      expands: true,
                      minLines: null,
                      maxLines: null,
                      controller: widget.textController,
                      textAlign: TextAlign.justify,
                      style: TextStyle(height: 1.5),
                    ),
                  )
                : Container()
          ]
      ),
    );
  }

}