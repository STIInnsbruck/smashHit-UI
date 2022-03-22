import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import 'package:smashhit_ui/data/models.dart';

class LoginScreen extends StatefulWidget {
  final Function(int) changeScreen;
  final Function(String) setUserId;
  final Function(User) setUser;

  LoginScreen(this.changeScreen, this.setUserId, this.setUser);

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  DataProvider dataProvider = new DataProvider();
  bool _signUp = false;
  bool loading = false;
  double smallSide = 10;
  late Future<User> futureUser = User() as Future<User>;
  User? user;

  //TextField CONTROLLERS for Login
  TextEditingController _loginController = new TextEditingController();

  //TextField CONTROLLERS for Registration
  TextEditingController city = new TextEditingController();
  TextEditingController state = new TextEditingController();
  TextEditingController country = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController surname = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phone = new TextEditingController();

  //TextField FOCUSNODES
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _surnameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _registrationFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    getSmallerSide(screenHeight, screenWidth);

    return Center(
      child: Container(
          width: screenWidth * 0.7,
          height: screenHeight,
          child: Stack(
            children: [
              Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: screenHeight / (_signUp? 20 : 10)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("smash",style: TextStyle(fontSize: smallSide * 0.12, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                          Text("Hit", style: TextStyle(fontSize: smallSide * 0.12, fontWeight: FontWeight.bold, color: Colors.blue))
                        ],
                      ),
                      SizedBox(height: (_signUp? 10 : 20)),
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
                      SizedBox(height: (_signUp? 20 : 40)),
                      _signUp?
                      registrationForm(smallSide) : loginForm(smallSide),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 400,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _signUp?
                            MaterialButton(
                              onPressed: () {
                                if (_registrationFormKey.currentState!.validate()) {
                                  _registerUser(name.text, (name.text + surname.text), address.text, city.text, country.text, state.text, phone.text, "Person", email.text);
                                }
                              },
                              child: Text('Register', style: TextStyle(color: Colors.white, fontSize: smallSide * 0.05), overflow: TextOverflow.ellipsis),
                              elevation: 10,
                              color: Colors.grey,
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            ) :
                            MaterialButton(
                              onPressed: () {
                                if(_loginFormKey.currentState!.validate()) {
                                  _loginUser(_loginController.text);
                                }
                              },
                              child: Text('Login', style: TextStyle(color: Colors.white, fontSize: smallSide * 0.05), overflow: TextOverflow.ellipsis),
                              elevation: 10,
                              color: Colors.grey,
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            ),
                            Spacer(),
                            _signUp?
                            MaterialButton(
                              onPressed: () {
                                _toggleSignUp();
                              },
                              child: Text('Sign In', style: TextStyle(color: Colors.white, fontSize: smallSide * 0.05), overflow: TextOverflow.ellipsis),
                              elevation: 10,
                              color: Colors.grey,
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            ) :
                            MaterialButton(
                              onPressed: () {
                                _toggleSignUp();
                              },
                              child: Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: smallSide * 0.05), overflow: TextOverflow.ellipsis),
                              elevation: 10,
                              color: Colors.grey,
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              loading? Center(
                  child: CircularProgressIndicator()
              ) : Container()
            ],
          )
      ),
    );
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
    return Form(
      key: _loginFormKey,
      child: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _loginController,
              decoration: InputDecoration(
                  hintText: 'Name',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name.';
                }
              },
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  Widget registrationForm(double screenWidth) {
    return Form(
      key: _registrationFormKey,
      child: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Name',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name.';
                }
              },
              controller: name,
              textAlign: TextAlign.left,
              textInputAction: TextInputAction.next,
              focusNode: _nameFocus,
              onFieldSubmitted: (v) {
                _focusNextTextField(context, _nameFocus, _surnameFocus);
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Surname',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your surname.';
                }
              },
              controller: surname,
              textAlign: TextAlign.left,
              textInputAction: TextInputAction.next,
                focusNode: _surnameFocus,
                onFieldSubmitted: (v) {
                  _focusNextTextField(context, _surnameFocus, _emailFocus);
                }
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Email',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email.';
                }
              },
              controller: email,
              textAlign: TextAlign.left,
              textInputAction: TextInputAction.next,
                focusNode: _emailFocus,
                onFieldSubmitted: (v) {
                  _focusNextTextField(context, _emailFocus, _phoneFocus);
                }
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Phone Number',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your phone number.';
                }
              },
              controller: phone,
              textAlign: TextAlign.left,
              textInputAction: TextInputAction.next,
                focusNode: _phoneFocus,
                onFieldSubmitted: (v) {
                  _focusNextTextField(context, _phoneFocus, _addressFocus);
                }
            ),
            cscDropdownPicker(screenWidth * 0.30),
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'Street Address'
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your street address.';
                }
              },
              controller: address,
              textAlign: TextAlign.left,
              textInputAction: TextInputAction.done,
                focusNode: _addressFocus,
                onFieldSubmitted: (v) {
                  _addressFocus.unfocus();
                }
            ),
          ],
        ),
      ),
    );
  }

  Widget cscDropdownPicker(double width) {
    return SizedBox(
      width: 400,
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

  _registerUser(String name, String agentId, String address, String city,
      String country, String state, String phone, String agentType, String email) async {
    _toggleLoading();
    var result = await dataProvider.createAgent(name, agentId, address, city, country, state, phone, agentType, email);
    if (result == 1) {
      _toggleLoading();
      _loginUser(agentId);
      //widget.changeScreen(0);
    } else if (result == -1){
      _toggleLoading();
      showUserAlreadyExistsDialog();
    } else {
    _toggleLoading();
    showRegisterErrorDialog();
    }
  }

  _loginUser(String agentId) async {
    _toggleLoading();
    try {
      user = await dataProvider.fetchUserById(agentId);
      _toggleLoading();
      widget.setUserId(agentId);
      widget.setUser(user!);
      widget.changeScreen(0);
    } catch (e) {
      _toggleLoading();
      _showUserNotFoundDialog();
    }
  }

  showUserAlreadyExistsDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Already have an account?', textAlign: TextAlign.center),
            contentPadding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
            children: [
              Text('An account with that name already exists!', textAlign: TextAlign.center),
              MaterialButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  showRegisterErrorDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Oops!', textAlign: TextAlign.center),
            contentPadding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
            children: [
              Icon(Icons.error, color: Colors.orange, size: 100),
              Text('An error occured while trying to register.', textAlign: TextAlign.center),
              MaterialButton(
                child: Text('Okay, try again!'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  _focusNextTextField(BuildContext context, FocusNode currentNode, FocusNode nextNode) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);
  }

  _showUserNotFoundDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Error', textAlign: TextAlign.center),
            contentPadding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
            children: [
              Text('User was not found.', textAlign: TextAlign.center),
              MaterialButton(
                child: Text('Try again'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],

          );
        }
    );
  }

}
