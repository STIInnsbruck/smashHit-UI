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
  double smallSide = 10;

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
    getSmallerSide(screenHeight, screenWidth);

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
                Text("smash",style: TextStyle(fontSize: smallSide * 0.12, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                Text("Hit", style: TextStyle(fontSize: smallSide * 0.12, fontWeight: FontWeight.bold, color: Colors.blue))
              ],
            ),
            Spacer(),
        CircleAvatar(
          radius: smallSide * 0.10,
          backgroundColor: Colors.grey,
          child: CircleAvatar(
              radius: smallSide * 0.098,
              backgroundColor: Colors.white,
              child: Container(
                width: smallSide * 0.192,
                height: smallSide * 0.192,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.bottomCenter,
                child: ClipOval(
                  child: Icon(Icons.person, size: smallSide * 0.192, color: Colors.white),
                ),
              )
          ),
        ),
            _signUp?
            registrationForm(smallSide) : loginForm(smallSide),
            Spacer(flex: 2),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _signUp?
                  Flexible(
                    flex: 2,
                    child: MaterialButton(
                      onPressed: () async {
                        _register();
                        //_registerUser(name.text, (name.text + surname.text), address.text, city.text, country.text, state.text, phone.text, "Person", email.text);
                      },
                      child: Text('Register', style: TextStyle(color: Colors.white, fontSize: smallSide * 0.05), overflow: TextOverflow.ellipsis),
                      elevation: 10,
                      color: Colors.grey,
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    ),
                  ) :
                  Flexible(
                    flex: 2,
                    child: MaterialButton(
                      onPressed: () {
                        widget.changeScreen(0);
                      },
                      child: Text('Login', style: TextStyle(color: Colors.white, fontSize: smallSide * 0.05), overflow: TextOverflow.ellipsis),
                      elevation: 10,
                      color: Colors.grey,
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    ),
                  ),
                  Spacer(),
                  _signUp?
                  Flexible(
                    flex: 2,
                    child: MaterialButton(
                      onPressed: () {
                        _toggleSignUp();
                      },
                      child: Text('Sign In', style: TextStyle(color: Colors.white, fontSize: smallSide * 0.05), overflow: TextOverflow.ellipsis),
                      elevation: 10,
                      color: Colors.grey,
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    ),
                  ) :
                  Flexible(
                    flex: 2,
                    child: MaterialButton(
                      onPressed: () {
                        _toggleSignUp();
                      },
                      child: Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: smallSide * 0.05), overflow: TextOverflow.ellipsis),
                      elevation: 10,
                      color: Colors.grey,
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(flex: 4)
      ],
    ),
          ),
        ));
  }

  void getSmallerSide(double height, double width) {
    setState(() {
      if (height >= width) {
        smallSide = width;
      } else {
        smallSide = height;
      }
    });
  }

  Widget loginForm(double screenWidth) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: screenWidth * 0.30,
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
            width: screenWidth * 0.30,
            height: screenWidth * 0.05,
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'Name',
                  hintStyle: TextStyle(fontSize: screenWidth / 45)
              ),
              controller: name,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: screenWidth / 45),
            )
        ),
        Container(
            width: screenWidth * 0.30,
            height: screenWidth * 0.05,
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'Surname',
                  hintStyle: TextStyle(fontSize: screenWidth / 45)
              ),
              controller: surname,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: screenWidth / 45),
            )
        ),
        Container(
            width: screenWidth * 0.30,
            height: screenWidth * 0.05,
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(fontSize: screenWidth / 45)
              ),
              controller: email,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: screenWidth / 45),
            )
        ),
        Container(
            width: screenWidth * 0.30,
            height: screenWidth * 0.05,
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'Phone Number',
                  hintStyle: TextStyle(fontSize: screenWidth / 45)
              ),
              controller: phone,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: screenWidth / 45),
            )
        ),
        CSCDropdownPicker(screenWidth * 0.30),
        Container(
            width: screenWidth * 0.30,
            height: screenWidth * 0.05,
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'Street Address',
                  hintStyle: TextStyle(fontSize: screenWidth / 45)
              ),
              controller: address,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: screenWidth / 45),
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
