import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/misc/contractor_roles.dart';

class LoginScreen extends StatefulWidget {
  final Function(int) changeScreen;
  final Function(String) setUserId;
  final Function(User) setUser;
  final Function(String) setToken;
  final Function() toggleOfflineMode;

  LoginScreen(this.changeScreen, this.setUserId, this.setUser, this.setToken, this.toggleOfflineMode);

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
  String? selectedRole;

  bool offlineMode = false;

  //TextField CONTROLLERS for Login
  TextEditingController _loginController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  //TextField CONTROLLERS for Registration
  TextEditingController city = new TextEditingController();
  TextEditingController state = new TextEditingController();
  TextEditingController country = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController surname = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  //TextField FOCUSNODES
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _surnameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
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
                      newRegistrationForm(smallSide) : loginForm(smallSide),
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
                                  //_registerUser();
                                  _performRegistration(name.text, email.text, password.text);
                                }
                              },
                              child: Text('Register', style: TextStyle(color: Colors.white, fontSize: smallSide * 0.05), overflow: TextOverflow.ellipsis),
                              elevation: 10,
                              color: Colors.grey,
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            ) :
                            MaterialButton(
                              onPressed: () {
                                if(offlineMode) {
                                  _loginOfflineMode();
                                } else {
                                  if(_loginFormKey.currentState!.validate()) {
                                    //_loginUser(_loginController.text);
                                    _performLogin(_loginController.text, _passwordController.text);
                                  }
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
                      SizedBox(height: 20),
                      offlineSwitch()
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
            //NAME FIELD
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
            //PASSWORD FIELD
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your password.';
                }
              },
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  ///@deprecated
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
                  _focusNextTextField(context, _emailFocus, _passwordFocus);
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
              controller: password,
              textAlign: TextAlign.left,
              textInputAction: TextInputAction.next,
                focusNode: _passwordFocus,
                onFieldSubmitted: (v) {
                  _focusNextTextField(context, _passwordFocus, _addressFocus);
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
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a role.';
                      }
                    },
                    isExpanded: true,
                    items: contractorRoles,
                    hint: Text("Select your role"),
                    value: selectedRole,
                    onChanged: (String? value) {
                      setState(() {
                        selectedRole = value!;
                      });
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget newRegistrationForm(double screenWidth) {
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
                  _focusNextTextField(context, _emailFocus, _passwordFocus);
                }
            ),
            TextFormField(
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your password.';
                  }
                },
                controller: password,
                textAlign: TextAlign.left,
                textInputAction: TextInputAction.next,
                focusNode: _passwordFocus,
                onFieldSubmitted: (v) {
                  _passwordFocus.unfocus();
                }
            ),
          ],
        ),
      ),
    );
  }

  Widget offlineSwitch() {
    return Row(
      children: [
        Spacer(),
        Text("Offline Mode: "),
        Switch(
            value: offlineMode,
            onChanged: (value) {
              setState(() {
                offlineMode = !offlineMode;
              });
              widget.toggleOfflineMode();
            }
        ),
        Spacer()
      ],
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

  ///@deprecated
  _registerUser() async {
    _toggleLoading();
    try {
      User tmpUser = await dataProvider.createAgent(setUser());
      _toggleLoading();
      widget.setUser(tmpUser);
      widget.changeScreen(0);
    } catch (e) {
      _toggleLoading();
      showRegisterErrorDialog();
    }
  }

  _performRegistration(String name, String email, String password) async {
    _toggleLoading();
    try {
      bool success = await dataProvider.register(name, email, password);
      _toggleLoading();
      if (success) {
        _performLogin(name, password);
      } else {
        showRegisterErrorDialog();
      }
    } catch (e) {
      _toggleLoading();
      showRegisterErrorDialog();
    }
  }

  User setUser() {
    return User(
      name: (name.text + " " + surname.text),
      email: email.text,
      country: country.text,
      city: city.text,
      phone: password.text,
      streetAddress: address.text,
      role: selectedRole,
      companyId: "cm_86ff4c94-fc62-11ec-93f2-b5bccd42b8bf",
      createDate: DateTime.now(),
      vat: "1111"
    );
  }

  User setOfflineUser() {
    return User(
      id: "c_0001",
      name: "Max Mustermann",
      email: "max.musertmann@email.com",
      country: "Austria",
      city: "Innsbruck",
      phone: "0035269815968",
      streetAddress: "12, Maria-Theresien-Strasse",
      role: "DataSubject"
    );
  }

  _loginOfflineMode() {
    _toggleLoading();
    widget.setUser(setOfflineUser());
    _toggleLoading();
    widget.changeScreen(0);
}

  ///@deprecated
  _loginUser(String userId) async {
    _toggleLoading();
    try {
      user = await dataProvider.fetchUserById(userId);
      _toggleLoading();
      widget.setUserId(userId);
      widget.setUser(user!);
      widget.changeScreen(0);
    } catch (e) {
      _toggleLoading();
      _showUserNotFoundDialog();
    }
  }

  _performLogin(String name, String password) async {
    _toggleLoading();
    try {
      user = await dataProvider.loginUser(name, password);
      _toggleLoading();
      widget.setUser(user!);
      widget.setToken(user!.token!);      //probably not needed
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
              Text('An error occurred while trying to register.', textAlign: TextAlign.center),
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
