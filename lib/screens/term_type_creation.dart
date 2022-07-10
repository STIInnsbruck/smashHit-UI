import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/data/data_provider.dart';

class TermTypeCreationPage extends StatefulWidget {
  final Function(int, [String]) changeScreen;
  final User? user;
  final bool offlineMode;

  TermTypeCreationPage(this.changeScreen, this.user, this.offlineMode);

  @override
  _TermTypeCreationPage createState() => _TermTypeCreationPage();
}

class _TermTypeCreationPage extends State<TermTypeCreationPage> {

  final formKey = GlobalKey<FormState>();

  //CONTROLLERS
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();

  bool _isLoading = false;
  bool _formComplete = false;

  DataProvider dataProvider = new DataProvider();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 10),
              Expanded(child: Center(child: createTermTypeForm(screenWidth * 0.7))),
              SizedBox(height: 10),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: createTermTypeButton(),
          ),
          _isLoading? Center(
              child: CircularProgressIndicator()
          ) : Container()
        ],
      )
    );
  }

  Widget createTermTypeForm(double width) {
    return Container(
      child: Column(
        children: [
          _formHeader(width),
          Expanded(child: _formBody(width))
        ],
      ),
    );
  }

  Widget _formHeader(double width) {
    return
      Container(
          width: width,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              color: _formComplete == true ? Colors.green : Colors.grey,
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
                      child: Text(
                          "Please enter you term type's name and description.",
                          style: TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          maxLines: 1)),
                  SizedBox(width: 10),
                  _formComplete
                      ? Icon(Icons.check, color: Colors.white, size: 30)
                      : Container()
                ]
            ),
            alignment: Alignment.centerLeft,
          )
      );
  }

  Widget _formBody(double width) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black45,
                  blurRadius: 25.0,
                  spreadRadius: 5.0,
                  offset: Offset(10.0, 10.0))
            ]),
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        width: width,
        child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("What is the name of you term type?", style: TextStyle(fontSize: 15)),
                SizedBox(height: 5),
                TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0),
                          borderSide: BorderSide(color: Colors.blue)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0),
                          borderSide: BorderSide(color: Colors.black, width: 1.0)),
                    ),
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a name for your term type.";
                      }
                      return null;
                    }
                ),
                SizedBox(height: 10),
                Text("Enter you term type's description.", style: TextStyle(fontSize: 15)),
                SizedBox(height: 5),
                Expanded(
                  child: TextFormField(
                      expands: true,
                      minLines: null,
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            borderSide: BorderSide(color: Colors.blue)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            borderSide: BorderSide(color: Colors.black, width: 1.0)),
                      ),
                      controller: descriptionController,
                      textAlign: TextAlign.justify,
                      textAlignVertical: TextAlignVertical.top,
                      style: TextStyle(height: 1.5),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a description for your term type.";
                        }
                        return null;
                      }
                  ),
                )
              ],
            )
        )
    );
  }

  _validateForm() {
    if (formKey.currentState!.validate()) {
      setState(() {
        _formComplete = true;
      });
    } else {
      setState(() {
        _formComplete = false;
      });
    }
  }

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  Widget createTermTypeButton() {
    return Container(
      child: MaterialButton(
        minWidth: 125,
        onPressed: () async {
          _toggleLoading();
          TermType termType = await dataProvider.createTermType(nameController.text, descriptionController.text);
          if (termType.id != null) {
            _toggleLoading();
            widget.changeScreen(10);
          }
        },
        color: Colors.green,
        hoverColor: Colors.lightGreen,
        child: Text("Create Term Type", style: TextStyle(color: Colors.white))
      ),
    );
  }

}