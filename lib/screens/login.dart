import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:smashhit_ui/data/data_provider.dart';

class LoginScreen extends StatefulWidget {
  final Function(int) changeScreen;

  LoginScreen(this.changeScreen);

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  DataProvider dataProvider = new DataProvider();
  bool _signUp = false;
  bool loading = false;

  TextEditingController city = new TextEditingController();
  TextEditingController state = new TextEditingController();
  TextEditingController country = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController surname = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phone = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Material(
        child: Center(
          child: Container(
            width: screenWidth * 0.7,
            height: screenHeight,
            child: Column(
      children: [
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("smash",style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                Text("Hit", style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.blue))
              ],
            ),
            Spacer(),
        CircleAvatar(
          radius: screenWidth * 0.10,
          backgroundColor: Colors.grey,
          child: CircleAvatar(
              radius: screenWidth * 0.098,
              backgroundColor: Colors.white,
              child: Container(
                width: screenWidth * 0.192,
                height: screenWidth * 0.192,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.bottomCenter,
                child: ClipOval(
                  child: Icon(Icons.person, size: screenWidth * 0.192, color: Colors.white),
                ),
              )
          ),
        ),
            _signUp? registrationForm(screenWidth) : loginForm(screenWidth),
            Spacer(flex: 2),
            Row(
              children: [
                Spacer(flex: 2),
                _signUp?
                MaterialButton(
                  onPressed: () async {
                    _register();
                    //_registerUser(name.text, (name.text + surname.text), address.text, city.text, country.text, state.text, phone.text, "Person", email.text);
                  },
                  child: Text('Register', style: TextStyle(color: Colors.white, fontSize: 50)),
                  elevation: 10,
                  color: Colors.grey,
                  minWidth: screenWidth * 0.12,
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                ) :
                MaterialButton(
                  onPressed: () {
                    widget.changeScreen(0);
                  },
                  child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 50)),
                  elevation: 10,
                  color: Colors.grey,
                  minWidth: screenWidth * 0.12,
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                ),
                Spacer(),
                _signUp?
                MaterialButton(
                  onPressed: () {
                    _toggleSignUp();
                  },
                  child: Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 50)),
                  elevation: 10,
                  color: Colors.grey,
                  minWidth: screenWidth * 0.12,
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                ) :
                MaterialButton(
                  onPressed: () {
                    _toggleSignUp();
                  },
                  child: Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 50)),
                  elevation: 10,
                  color: Colors.grey,
                  minWidth: screenWidth * 0.12,
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                ),
                Spacer(flex: 2),
              ],
            ),
            Spacer(flex: 4)
      ],
    ),
          ),
        ));
  }

  Widget loginForm(double screenWidth) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: screenWidth * 0.20,
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'Name',
                  hintStyle: TextStyle(fontSize: 20)
              ),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            )
        ),
      ],
    );
  }

  Widget registrationForm(double screenWidth) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: screenWidth * 0.20,
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'Name',
                  hintStyle: TextStyle(fontSize: 16)
              ),
              controller: name,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16),
            )
        ),
        Container(
            width: screenWidth * 0.20,
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'Surname',
                  hintStyle: TextStyle(fontSize: 16)
              ),
              controller: surname,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16),
            )
        ),
        Container(
            width: screenWidth * 0.20,
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(fontSize: 16)
              ),
              controller: email,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16),
            )
        ),
        Container(
            width: screenWidth * 0.20,
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'Phone Number',
                  hintStyle: TextStyle(fontSize: 16)
              ),
              controller: phone,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16),
            )
        ),
        Container(height: 10),
        CSCDropdownPicker(screenWidth * 0.20),
        Container(
            width: screenWidth * 0.20,
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'Street Address',
                  hintStyle: TextStyle(fontSize: 16)
              ),
              controller: address,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16),
            )
        ),
      ],
    );
  }

  Widget CSCDropdownPicker(double width) {
    return Container(
      width: width,
      child: CountryStateCityPicker(
        city: city,
        country: country,
        state: state,
        textFieldInputBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2.0),
            borderSide: BorderSide(color: Colors.black, width: 2.0)),
      ),
    );
  }

  void _toggleSignUp() {
    setState(() {
      _signUp = !_signUp;
    });
  }

  void _toggleLoading() {
    setState(() {
      loading = !loading;
    });
  }

  void _register() {
    dataProvider.createAgent("null", "null", "null", "null", "null", "null", "null", "null", "null");
  }

  Future<bool> _registerUser(String name, String agentId, String address, String city,
      String country, String state, String phone, String agentType, String email) async {
    _toggleLoading();
    var result = await dataProvider.createAgent(name, agentId, address, city, country, state, phone, agentType, email);
    if (result) {
      _toggleLoading();
      return true;
    } else {
      _toggleLoading();
      return false;
    }
  }
}
