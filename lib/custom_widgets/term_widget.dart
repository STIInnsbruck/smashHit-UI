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
  bool edit = false;

  @override
  void initState() {
    super.initState();

    addExampleText();
  }

  ///Function to add a sample text from the json file in the assets. If not
  ///called, the text box of a term will be empty, but still editable.
  addExampleText() {
    if(widget.textController.text == "") {
      widget.textController.text = widget.term.description!;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
          children: [
            Container(
              color: Colors.grey[300],
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
                      setState(() {
                        edit =  !edit;
                      })
                    },
                    icon: Icon(Icons.edit, color: edit? Colors.blue : Colors.grey),
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
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Colors.grey[300]!,
                            width: 4
                        ),
                        bottom: BorderSide(
                            color: Colors.grey[300]!,
                            width: 4
                        ),
                        right: BorderSide(
                            color: Colors.grey[300]!,
                            width: 4
                        ),
                      )
                    ),
                    child: TextField(
                      expands: true,
                      enabled: edit,
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

  void addObligation() {

  }

}