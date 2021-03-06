import 'package:flutter/material.dart';
import 'package:smashhit_ui/custom_widgets/profileStatisticCard.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import 'package:smashhit_ui/data/models.dart';

class ProfileEditorPage extends StatefulWidget {
  final Function(int, [String]) changeScreen;
  final String userId;
  final bool offlineMode;

  ProfileEditorPage(this.changeScreen, this.userId, this.offlineMode);

  @override
  _ProfileEditorPage createState() => _ProfileEditorPage();
}

class _ProfileEditorPage extends State<ProfileEditorPage> {

  //CONTROLLERS
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController countryController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();

  //FOCUSNODES
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _countryFocus = FocusNode();
  final FocusNode _stateFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();

  //BOOLS
  bool nameEnabled = false;
  bool phoneEnabled = false;
  bool emailEnabled = false;
  bool countryEnabled = false;
  bool stateEnabled = false;
  bool cityEnabled = false;
  bool addressEnabled = false;
  bool fetchedObligations = false;
  bool _isLoading = false;
  bool _userDataLoaded = false;
  bool _allObligationsCompleted = false;

  DataProvider dataProvider = new DataProvider();
  late Future<User> futureUser = User() as Future<User>;
  User? user;

  late Future<List<Contract>> futureContracts;
  List<Contract> contracts = [];
  List<Obligation> obligations = [];

  @override
  void initState() {

    futureContracts = fetchContractAndObligationsStatistics();
    super.initState();
    _userDataLoaded = false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            child: FutureBuilder<User>(
                future: futureUser = dataProvider.fetchUserById(widget.userId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    user = snapshot.data;
                    if (!_userDataLoaded) {
                      displayUserData();
                      _userDataLoaded = true;
                    }
                    return Container(
                      child: FutureBuilder<List<Contract>>(
                          future: futureContracts,
                          builder: (context, contractsSnapshot) {
                            if (contractsSnapshot.hasData) {
                              contracts = contractsSnapshot.data!;
                              return _wideScreenLayout();
                              //return _wideScreenLayout();
                            } else if (contractsSnapshot.hasError) {
                              return Text('${contractsSnapshot.error}');
                            }
                            return Center(child: CircularProgressIndicator());
                          }
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('${snapshot.error}'));
                  }
                  return Center(child: CircularProgressIndicator());
                }
            )
        ),
        _isLoading? Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.grey[200],
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ) : Container()
      ],
    );
  }

  Widget _wideScreenLayout() {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(flex: 4),
                Expanded(flex: 3, child: profilePicture()),
                Expanded(flex: 10,child: profileDetails()),
                Spacer(flex: 3)
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Spacer(flex: 1),
                Expanded(child: ProfileStatisticCard(title: "Obligations Completed", tooltipMessage: "The amount of obligations you have completed against the amount you have in total.", value: "${numCompletedObligation()}/${obligations.length}", color: _allObligationsCompleted? Colors.green : Colors.black)),
                Expanded(child: ProfileStatisticCard(title: "Total Contracts", tooltipMessage: "The amount of contracts you have.", value: "${contracts.length}")),
                Expanded(child: ProfileStatisticCard(title: "Completed Contracts", tooltipMessage: "The amount of contracts you have.", value: "${numCompletedContracts()}")),
                Expanded(child: ProfileStatisticCard(title: "Running Contracts", tooltipMessage: "The amount of contracts you have.", value: "${numRunningContract()}")),
                Spacer(flex: 1)
              ],
            ),
            Row(
              children: [
                Spacer(flex: 2),
                Expanded(flex: 1, child: deleteButton()),
                Spacer(flex: 2),
                Expanded(flex: 1, child: confirmButton()),
                Spacer(flex: 2)
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<List<Contract>> fetchContractAndObligationsStatistics() async {
    List<Contract> tmpContracts = await dataProvider.fetchContractsByContractorId(widget.userId);
    await _getAllObligationsOfEachContract(tmpContracts);

    return tmpContracts;
  }

  int numCompletedContracts() {
    int numCompleted = 0;
    contracts.forEach((element) {
      if (element.contractStatus!.compareTo("hasFulfilled") == 0) {
        numCompleted++;
      }
    });
    return numCompleted;
  }

  int numRunningContract() {
    int numRunning = 0;
    contracts.forEach((element) {
      if (element.contractStatus!.compareTo("hasFulfilled") != 0) {
        numRunning++;
      }
    });
    return numRunning;
  }

  int numCompletedObligation() {
    int numCompleted = 0;

    obligations.forEach((element) {
      if (element.state!.compareTo("hasFulfilled") == 0) {
        numCompleted++;
      }
    });

    if(numCompleted == obligations.length) {
      setState(() {
        _allObligationsCompleted = true;
      });
    }
    return numCompleted;
  }
  
  Future<void> _getAllObligationsOfEachContract(List<Contract> pContracts) async {
    List<Obligation> oblList =  [];
    for (Contract pContract in pContracts) {
      for (String oblId in pContract.obligations) {
        Obligation tmpObligation = await dataProvider.fetchObligationById(oblId);
        if (tmpObligation.contractorId == widget.userId) {
          oblList.add(tmpObligation);
        }
      }
    }
    setState(() {
      obligations = oblList;
    });
  }

  setUser() {
    user!.name = nameController.text;
    user!.phone = phoneController.text;
    user!.email = emailController.text;
    user!.country = countryController.text;
    user!.city = cityController.text;
    user!.streetAddress = addressController.text;
  }

  Widget _slimScreenLayout() {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          children: [
            profilePicture(),
            SizedBox(height: 10),
            Container(
                child: profileDetails(),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0)
            ),
            Row(
              children: [
                Spacer(),
                Expanded(flex: 4, child: deleteButton()),
                Spacer(),
                Expanded(flex: 4, child: confirmButton()),
                Spacer()
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget profileDetails() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text("Profile Details")),
          Row(
            children: [
              Spacer(),
              Flexible(
                flex: 3,
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Name",
                    focusColor: Colors.blue,
                    border: nameEnabled? null : InputBorder.none,
                  ),
                  enabled: nameEnabled,
                  focusNode: _nameFocus,
                  onFieldSubmitted: (val)  {
                    nameEnabled = false;
                    _focusNextTextField(context, _nameFocus, _phoneFocus);
                    },
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () { setState(() {
                  nameEnabled = !nameEnabled;
                }); },
              ),
              Spacer(),
            ],
          ),
          Row(
            children: [
              Spacer(),
              Flexible(
                flex: 3,
                child: TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: "Phone",
                    border: phoneEnabled? null : InputBorder.none,
                  ),
                  enabled: phoneEnabled,
                  focusNode: _phoneFocus,
                  onFieldSubmitted: (val) {
                    phoneEnabled = false;
                    _focusNextTextField(context, _phoneFocus, _emailFocus);
                    },
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () { setState(() {
                  phoneEnabled = !phoneEnabled;
                }); },
              ),
              Spacer(),
            ],
          ),
          Row(
            children: [
              Spacer(),
              Flexible(
                flex: 3,
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: emailEnabled? null : InputBorder.none,
                  ),
                  enabled: emailEnabled,
                  focusNode: _emailFocus,
                  onFieldSubmitted: (val) {
                    emailEnabled = false;
                    _focusNextTextField(context, _emailFocus, _countryFocus);
                    },
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () { setState(() {
                  emailEnabled = !emailEnabled;
                }); },
              ),
              Spacer(),
            ],
          ),
          Row(
            children: [
              Spacer(),
              Flexible(
                flex: 3,
                child: TextFormField(
                  controller: countryController,
                  decoration: InputDecoration(
                    hintText: "Country",
                    border: countryEnabled? null : InputBorder.none,
                  ),
                  enabled: countryEnabled,
                  focusNode: _countryFocus,
                  onFieldSubmitted: (val) {
                    countryEnabled = false;
                    _focusNextTextField(context, _countryFocus, _stateFocus);
                    },
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () { setState(() {
                  countryEnabled = !countryEnabled;
                }); },
              ),
              Spacer(),
            ],
          ),
          Row(
            children: [
              Spacer(),
              Flexible(
                flex: 3,
                child: TextFormField(
                  controller: cityController,
                  decoration: InputDecoration(
                    hintText: "City",
                    border: cityEnabled? null : InputBorder.none,
                  ),
                  enabled: cityEnabled,
                  focusNode: _cityFocus,
                  onFieldSubmitted: (val) {
                    cityEnabled = false;
                    _focusNextTextField(context, _cityFocus, _addressFocus);
                    },
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () { setState(() {
                  cityEnabled = !cityEnabled;
                }); },
              ),
              Spacer(),
            ],
          ),
          Row(
            children: [
              Spacer(),
              Flexible(
                flex: 3,
                child: TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(
                    hintText: "House Number and Street Name",
                    border: addressEnabled? null : InputBorder.none,
                  ),
                  enabled: addressEnabled,
                  focusNode: _addressFocus,
                  onFieldSubmitted: (val) {
                    addressEnabled = false;
                    _addressFocus.unfocus();
                    },
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () { setState(() {
                  addressEnabled = !addressEnabled;
                }); },
              ),
              Spacer(),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Spacer(),
              Expanded(flex: 3, child: Text("Account Creation Date:")),
              Expanded(child: Text("${user!.displayCreationDate()}", textAlign: TextAlign.right)),
              Spacer()
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Spacer(),
              Expanded(flex: 3, child: Text("VAT Number:")),
              Expanded(child: Text("${user!.vat}", textAlign: TextAlign.right)),
              Spacer()
            ],
          )
        ]
    );
  }

  Widget confirmButton() {
    return MaterialButton(
      color: Colors.blue,
      child: Text("Confirm Changes", style: TextStyle(color: Colors.white)),
      onPressed: () async {
        setUser();
        _toggleLoading();
        await dataProvider.updateUser(user!);
        _toggleLoading();
      },
    );
  }

  _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  Widget deleteButton() {
    return MaterialButton(
      color: Colors.red,
      child: Text("Delete Account", style: TextStyle(color: Colors.white)),
      onPressed: () {
        showConfirmDeletionDialog();
      },
    );
  }

  Widget profilePicture() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Text("Profile Picture")),
        Center(
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            backgroundImage: Image.asset('assets/images/placeholders/example_profile_pic.png').image,
            radius: 75,
          ),
        )
      ],
    );
  }

  void displayUserData() {
    nameController.text = user!.name!;
    phoneController.text = user!.phone!;
    emailController.text = user!.email!;
    countryController.text = user!.country!;
    cityController.text = user!.city!;
    addressController.text = user!.streetAddress!;
  }

  showConfirmDeletionDialog() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning, size: 40, color: Colors.red),
                Container(height: 20),
                Text("Are you sure you want to delete your account?"),
              ],
            ),
            actions: [
              MaterialButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              MaterialButton(
                  child: Text('Delete', style: TextStyle(color: Colors.white)),
                  color: Colors.red,
                  onPressed: () async {
                    if (await dataProvider.deleteUserById(widget.userId)) {
                      Navigator.of(context).pop();
                      showSuccessfulDeletionDialog(widget.userId);
                    } else {
                      Navigator.of(context).pop();
                      showFailedDeletionDialog(widget.userId);
                    }
                  }
              ),
            ],
          );
        });
  }

  showSuccessfulDeletionDialog(String userId) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Success!', textAlign: TextAlign.center),
            contentPadding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 100),
              Text('The account $userId was successfully deleted!\nNavigating you back to the login page.', textAlign: TextAlign.center),
              MaterialButton(
                child: Text('Okay'),
                onPressed: () {
                  widget.changeScreen(5);
                  Navigator.of(context).pop();
                },
              ),
            ],

          );
        }
    );
  }

  showFailedDeletionDialog(String userId) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Error!'),
            children: [
              Icon(Icons.error, color: Colors.red, size: 60),
              Text('The account $userId could not be deleted!'),
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

  bool _isWideScreen(double width, double height) {
    if (width >= height) {
      return true;
    } else {
      return false;
    }
  }

  _focusNextTextField(BuildContext context, FocusNode currentNode, FocusNode nextNode) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);
  }

}