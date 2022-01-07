import 'package:flutter/material.dart';

class ProfileManagerPage extends StatefulWidget {
  @override
  _ProfileManagerPage createState() => _ProfileManagerPage();
}

class _ProfileManagerPage extends State<ProfileManagerPage> {
  TextEditingController nameController = new TextEditingController();
  bool nameEnabled = false;
  TextEditingController surnameController = new TextEditingController();
  bool surnameEnabled = false;
  TextEditingController emailController = new TextEditingController();
  bool emailEnabled = false;
  TextEditingController birthdateController = new TextEditingController();
  bool birthdateEnabled = false;
  TextEditingController passwordController = new TextEditingController();
  bool passwordEnabled = false;
  TextEditingController countryController = new TextEditingController();
  bool countryEnabled = false;
  TextEditingController stateController = new TextEditingController();
  bool stateEnabled = false;
  TextEditingController cityController = new TextEditingController();
  bool cityEnabled = false;
  TextEditingController streetAddressController = new TextEditingController();
  bool streetAddressEnabled = false;


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      child: _isWideScreen(screenWidth, screenHeight)
          ? _wideScreenLayout()
          : _slimScreenLayout()
    );
  }

  Widget _wideScreenLayout() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(flex: 3),
            Expanded(flex: 3, child: profilePicture()),
            Spacer(),
            Expanded(flex: 10,child: profileDetails()),
            Spacer(flex: 3)
          ],
        ),
        confirmButton()
      ],
    );
  }

  Widget _slimScreenLayout() {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          children: [
            profilePicture(),
            SizedBox(height: 10),
            profileDetails(),
          ],
        ),
      ),
    );
  }

  Widget profileDetails() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Profile Details"),
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Name",
                    border: InputBorder.none,
                  ),
                  enabled: nameEnabled,
                  onFieldSubmitted: (val) => { nameEnabled = false },
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () { setState(() {
                  nameEnabled = !nameEnabled;
                }); },
              )
            ],
          ),
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  controller: surnameController,
                  decoration: InputDecoration(
                    hintText: "Surname",
                    border: InputBorder.none,
                  ),
                  enabled: surnameEnabled,
                  onFieldSubmitted: (val) => { surnameEnabled = false },
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () { setState(() {
                  surnameEnabled = !surnameEnabled;
                }); },
              )
            ],
          ),
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: InputBorder.none,
                  ),
                  enabled: emailEnabled,
                  onFieldSubmitted: (val) => { emailEnabled = false },
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () { setState(() {
                  emailEnabled = !emailEnabled;
                }); },
              )
            ],
          ),
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  controller: birthdateController,
                  decoration: InputDecoration(
                    hintText: "Birthdate",
                    border: InputBorder.none,
                  ),
                  enabled: birthdateEnabled,
                  onFieldSubmitted: (val) => { birthdateEnabled = false },
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () { setState(() {
                  birthdateEnabled = !birthdateEnabled;
                }); },
              )
            ],
          ),
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: InputBorder.none,
                  ),
                  enabled: passwordEnabled,
                  obscureText: true,
                  onFieldSubmitted: (val) => { passwordEnabled = false },
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () { setState(() {
                  passwordEnabled = !passwordEnabled;
                }); },
              )
            ],
          ),
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  controller: countryController,
                  decoration: InputDecoration(
                    hintText: "Country",
                    border: InputBorder.none,
                  ),
                  enabled: countryEnabled,
                  onFieldSubmitted: (val) => { countryEnabled = false },
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () { setState(() {
                  countryEnabled = !countryEnabled;
                }); },
              )
            ],
          ),
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  controller: stateController,
                  decoration: InputDecoration(
                    hintText: "State",
                    border: InputBorder.none,
                  ),
                  enabled: stateEnabled,
                  onFieldSubmitted: (val) => { stateEnabled = false },
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () { setState(() {
                  stateEnabled = !stateEnabled;
                }); },
              )
            ],
          ),
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  controller: cityController,
                  decoration: InputDecoration(
                    hintText: "City",
                    border: InputBorder.none,
                  ),
                  enabled: cityEnabled,
                  onFieldSubmitted: (val) => { cityEnabled = false },
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () { setState(() {
                  cityEnabled = !cityEnabled;
                }); },
              )
            ],
          ),
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  controller: streetAddressController,
                  decoration: InputDecoration(
                    hintText: "House Number and Street Name",
                    border: InputBorder.none,
                  ),
                  enabled: streetAddressEnabled,
                  onFieldSubmitted: (val) => { streetAddressEnabled = false },
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () { setState(() {
                  streetAddressEnabled = !streetAddressEnabled;
                }); },
              )
            ],
          ),
        ]
    );
  }

  Widget confirmButton() {
    return MaterialButton(
      color: Colors.blue,
      child: Text("Confirm Changes", style: TextStyle(color: Colors.white)),
      onPressed: () {
        print("confirm changes pressed.");
      },
    );
  }

  Widget profilePicture() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Profile Picture"),
        CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.person),
          radius: 100,
        )
      ],
    );
  }

  bool _isWideScreen(double width, double height) {
    if (width >= height) {
      return true;
    } else {
      return false;
    }
  }

}