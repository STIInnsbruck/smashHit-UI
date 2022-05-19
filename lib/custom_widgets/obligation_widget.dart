import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';

class ObligationWidget extends StatefulWidget {
  Obligation obligation = new Obligation();
  Term term;
  String contractorName;
  User? selectedContractor;
  List<User> contractors;
  String id;
  Function(String) onDeletePressed;
  TextEditingController textController = new TextEditingController();
  DateTime? contractStartDate;
  DateTime? contractEndDate;

  ObligationWidget(
      this.term, this.contractorName, this.contractors, this.onDeletePressed, this.id, this.contractStartDate, this.contractEndDate);

  @override
  _ObligationWidgetState createState() => new _ObligationWidgetState();
}

class _ObligationWidgetState extends State<ObligationWidget> {
  bool expand = true;
  bool edit = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(children: [
        Container(
          color: Colors.grey[300],
          child: Row(
            children: [
              MaterialButton(
                onPressed: () => {
                  setState(() {
                    expand = !expand;
                  })
                },
                child: Row(children: [
                  expand
                      ? Icon(Icons.unfold_less, color: Colors.black)
                      : Icon(Icons.unfold_more, color: Colors.black),
                  Text(
                      "Obligation to the term ${widget.term.name} for the contractor ",
                      style: TextStyle(color: Colors.black)),
                ]),
              ),
              DropdownButton(
                items: listContractors(),
                hint: Text("Select a contractor"),
                value: widget.selectedContractor,
                onChanged: (User? selected) {
                  setState(() {
                    widget.selectedContractor = selected;
                  });
                },
              ),
              Spacer(),
              IconButton(
                onPressed: () => {
                  setState(() {
                    edit = !edit;
                  })
                },
                icon: Icon(Icons.edit, color: edit ? Colors.blue : Colors.grey),
              ),
              IconButton(
                onPressed: () => {widget.onDeletePressed(widget.id)},
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
                  left: BorderSide(color: Colors.grey[300]!, width: 4),
                  bottom: BorderSide(color: Colors.grey[300]!, width: 0),
                  right: BorderSide(color: Colors.grey[300]!, width: 4),
                )),
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
            : Container(),
        expand
            ? Container(
                color: Colors.grey[300],
                child: Row(
                  children: [
                    Spacer(),
                    Expanded(
                        flex: 2,
                        child: MaterialButton(
                          color: Colors.grey[400],
                          child: widget.obligation.executionDate == null
                              ? Text("Pick an Execution Date",
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.center)
                              : Text(
                                  "Effective Date: ${widget.obligation.getExecutionDateAsString()}"),
                          onPressed: () => chooseExecutionDate(),
                        )),
                    Spacer(),
                    Expanded(
                        flex: 2,
                        child: MaterialButton(
                          color: Colors.grey[400],
                          child: widget.obligation.endDate == null
                              ? Text("Pick an End Date",
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.center)
                              : Text(
                                  "End Date: ${widget.obligation.getEndDateAsString()}"),
                          onPressed: () => chooseEndDate(),
                        )),
                    Spacer()
                  ],
                ),
              )
            : Container()
      ]),
    );
  }

  List<DropdownMenuItem<User>> listContractors() {
    List<DropdownMenuItem<User>> items = [];
    for(int i = 0; i < widget.contractors.length; i++) {
      items.add(DropdownMenuItem(
          child: Text("${widget.contractors[i].name}"),
          value: widget.contractors[i],
      ));
    }
    return items;
  }

  Future<void> chooseExecutionDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.contractStartDate!,
      firstDate: widget.contractStartDate!,
      lastDate: widget.contractEndDate!,
    );
    if (pickedDate != null && widget.obligation.endDate == null) {
      setState(() {
        widget.obligation.executionDate = pickedDate;
      });
    } else if (pickedDate != null &&
        widget.obligation.endDate != null &&
        pickedDate.isBefore(widget.obligation.endDate!)) {
      setState(() {
        widget.obligation.executionDate = pickedDate;
      });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text(
                  "Please select an execution date that is before the selected end date."),
              children: <Widget>[
                TextButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  Future<void> chooseEndDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.contractStartDate!,
      firstDate: widget.contractStartDate!,
      lastDate: widget.contractEndDate!,
    );
    if (pickedDate != null &&
        widget.obligation.executionDate != null &&
        pickedDate.isAfter(widget.obligation.executionDate!)) {
      setState(() {
        widget.obligation.endDate = pickedDate;
      });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text(
                  "Please select a start date first and be sure that the end date is after the effective date."),
              children: <Widget>[
                TextButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }
}
