import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContractForm extends StatefulWidget {

  DateTime? startDate;
  DateTime? endDate;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  _ContractFormState createState() => new _ContractFormState();
}

class _ContractFormState extends State<ContractForm> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black45,
                blurRadius: 25.0,
                spreadRadius: 5.0,
                offset: Offset(10.0, 10.0))
          ]),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      width: screenWidth * 0.50,
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              titleField(),
              Container(
                height: 20,
              ),
              descriptionField(),
              timeFrameField()
            ],
          ),
        ),
      ),
    );
  }

  Widget titleField() {
    return Row(
      children: [
        Text("Title: ", style: TextStyle(fontSize: 25)),
        Expanded(
          child: TextFormField(
              style: TextStyle(fontSize: 20),
              controller: widget.titleController,
          ),
        )
      ],
    );
  }

  Widget descriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Contract Terms: ", style: TextStyle(fontSize: 25)),
        Container(
          height: 400,
          color: Colors.white70,
          child: TextField(
            controller: widget.descriptionController,
            maxLines: null,
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
              hintText: "Enter contract details here...",
            ),
          ),
        ),
      ],
    );
  }

  Widget timeFrameField() {
    return Column(
      children: [
        Row(
          children: [
            Text("Start date: ", style: TextStyle(fontSize: 15)),
            startDate == null
                ? IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => chooseStartDate())
                : Expanded(
                    child: Row(
                    children: [
                      Text(_formatDate(startDate)),
                      IconButton(
                          icon: Icon(Icons.edit),
                          iconSize: 20,
                          onPressed: () => chooseStartDate())
                    ],
                  )),
            Spacer(),
            Text("End date: ", style: TextStyle(fontSize: 15)),
            endDate == null
                ? IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => chooseEndDate())
                : Expanded(
                    child: Row(
                    children: [
                      Text(_formatDate(endDate)),
                      IconButton(
                          icon: Icon(Icons.edit),
                          iconSize: 20,
                          onPressed: () => chooseEndDate())
                    ],
                  )),
          ],
        )
      ],
    );
  }

  Future<void> chooseStartDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050, 1, 1),
    );
    if (pickedDate != null && endDate == null) {
      setState(() {
        startDate = pickedDate;
        setWidgetStartDate();
      });
    } else if (pickedDate != null &&
        endDate != null &&
        pickedDate.isBefore(endDate!)) {
      setState(() {
        startDate = pickedDate;
        setWidgetStartDate();
      });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text(
                  "Please select a start date that is before the selected end date."),
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
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050, 1, 1),
    );
    if (pickedDate != null &&
        startDate != null &&
        pickedDate.isAfter(startDate!)) {
      setState(() {
        endDate = pickedDate;
        setWidgetEndDate();
      });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text(
                  "Please select a start date first and be sure that the end date is after the start date."),
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

  ///Function to nicely display the date in the contract form.
  String _formatDate(DateTime? date) {
    String dateString = "${date!.day}.${date.month}.${date.year}";
    return dateString;
  }

  void setWidgetStartDate() {
    widget.startDate = startDate;
  }

  void setWidgetEndDate() {
    widget.endDate = endDate;
  }


}
