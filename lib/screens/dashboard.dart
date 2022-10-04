import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import 'package:smashhit_ui/custom_widgets/contract_tile.dart';

class Dashboard extends StatefulWidget {
  final Function(int, [String]) changeScreen;
  final String? searchId;
  final User? user;
  final bool offlineMode;

  Dashboard(this.changeScreen, this.user, this.searchId, this.offlineMode);

  @override
  _DashboardState createState() => new _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DataProvider dataProvider = DataProvider();

  late Future<List<Contract>> futureContractList = [] as Future<List<Contract>>;
  List<Contract>? contractList = [];
  String? searchId;

  //Offline Variables
  List<User> offlineUsers = [];
  List<Obligation> offlineObligations = [];
  List<TermType> offlineTermTypes = [];
  List<Term> offlineTerms = [];
  List<Contract> offlineContracts = [];

  @override
  void initState() {
    super.initState();
    if (widget.offlineMode) {
      _generateOfflineData();
      contractList = offlineContracts;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    searchId = widget.searchId;
    return Container(
        child: !widget.offlineMode
            ? FutureBuilder<List<Contract>>(
                future: futureContractList =
                    dataProvider.fetchContractsByContractorId(widget.user!.id!, widget.user!.token!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    contractList = snapshot.data;
                    return Column(
                      children: [
                        _isSmallScreen(screenWidth)
                            ? Container()
                            : listHeader(),
                        contractList!.isEmpty
                            ? noContractsText()
                            : contractListWidget()
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return Center(child: CircularProgressIndicator());
                })
            : Column(
                children: [
                  _isSmallScreen(screenWidth) ? Container() : listHeader(),
                  contractListWidget()
                ],
              ));
  }

  ListTile listHeader() {
    return ListTile(
      title: Row(
        children: [
          Spacer(),
          Expanded(flex: 1, child: Text("Type", textAlign: TextAlign.left)),
          Expanded(flex: 8, child: Text("ID")),
          Expanded(flex: 6, child: Text("Purpose")),
          Expanded(flex: 4, child: Text("Signatures")),
          Expanded(flex: 2, child: Text("Status", textAlign: TextAlign.center)),
          Expanded(flex: 4, child: Text("Actions", textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget noContractsText() {
    return Expanded(
        child: Center(
            child: Text(
                "You have no contracts. Create a contract in the drawer menu to the left.")));
  }

  Widget contractListWidget() {
    return Expanded(
      child: ListView.builder(
          itemCount: contractList!.length,
          itemBuilder: (BuildContext context, int index) {
            if (searchId == null) {
              return ContractTile(widget.changeScreen, refreshContractList,
                  contractList![index], widget.user!.id, index+1);
            } else {
              if (contractList![index].id!.contains(searchId!)) {
                return ContractTile(widget.changeScreen, refreshContractList,
                    contractList![index], widget.user!.id, index+1);
              } else {
                return Container();
              }
            }
          }),
    );
  }

  bool _isSmallScreen(double width) {
    if (width <= 500.0) {
      return true;
    }
    return false;
  }

  void refreshContractList() {
    setState(() {
      futureContractList = dataProvider.fetchAllContracts();
    });
  }

  _generateOfflineData() {
    //Generate Contractors
    _generateOfflineContractor(
        "c_0002",
        "Klaus Erlenmann",
        "erlenmann.klaus@email.com",
        "45, Vorarlbergerstrasse",
        "Austria",
        "Innsbruck",
        "004365874951",
        "DataController");
    _generateOfflineContractor(
        "c_0003",
        "Science For Future GmbH",
        "customer.support@sciencefuture.com",
        "06, Technikerstrasse",
        "Austria",
        "Innsbruck",
        "0043658561451",
        "DataController");
    _generateOfflineContractor(
        "c_0004",
        "Visualitics",
        "vis_secretary@visualitics.de",
        "78, Talstrasse",
        "Germany",
        "Saarbrücken",
        "004861322951",
        "DataController");

    //Generate TermTypes
    _generateOfflineTermType(
        "tt_0001",
        "This Amendment is entered into the between [ENTER NAME] and [ENTER NAME] and amends any existing agreement ot our service Terms in accordance with the requirements of the European Union General Data Protection Regulation (Regulation (EU) 2016/679).",
        "Amendment");
    _generateOfflineTermType(
        "tt_0002",
        "[ENTER DATA CONTROLLER] shall ensure that any person who is authorised by [ENTER DATA CONTROLLER] to process Personal Data (including its staff, agents and subcontractors) shall be under an appropriate obligation of confidentiality (whether a contractual or statutory duty).",
        "Confidentiality Agreement");
    _generateOfflineTermType(
        "tt_0003",
        "1. All warranties, conditions, and other terms implied by statue or common law are, to the fullest extent permitted by law, excluded from this Agreement.\n2. Nothing in this Agreement limits or excludes the liability of [ENTER NAME A] for:\n(a) death or personal injury resulting from its negligence; or\n(b) fraud or fraudulent misrepresentation.\n3. Subject to clause 1 and clause 2:\n(a) [ENTER NAME A] shall not under any circumstances whatever be liable for:\ni. loss of profits; or\nii. any special, indirect or consequential loss, costs, damages, charges, or expenses; and\n(b) [ENTER NAME A]'s total liability in contract, tor (including negligence or breach of statutory duty), misrepresentation, restitution, or otherwise arising in connection with the perfomance or contemplated perfomance of this Agreement shall in all circumstances be limited to [AMOUNT].",
        "Limitation of Liability");

    //Generate Terms
    _generateOfflineTerm(
        "t_0001", "tt_0001", "con_0001", "Term Description", "Amendment");
    _generateOfflineTerm("t_0002", "tt_0002", "con_0001", "Term Description",
        "Confidentiality Agreement");
    _generateOfflineTerm("t_0003", "tt_0003", "con_0001", "Term Description",
        "Limitation of Liability");

    //Generate Obligations
    _generateOfflineObligation(
        "obl_0001",
        "con_0001",
        "c_0001",
        "t_0001",
        "Deliver Package by end date.",
        DateTime.parse("2022-08-10"),
        DateTime.parse("2022-07-10"),
        "hasPending");
    _generateOfflineObligation(
        "obl_0002",
        "con_0001",
        "c_0002",
        "t_0001",
        "Receive and notify receivable by end date.",
        DateTime.parse("2022-08-10"),
        DateTime.parse("2022-07-10"),
        "hasPending");
    _generateOfflineObligation(
        "obl_0003",
        "con_0001",
        "c_0001",
        "t_0002",
        "Not leak any information to other parties",
        DateTime.parse("2022-08-10"),
        DateTime.parse("2022-07-10"),
        "hasPending");

    List<String> contractors = [
      "c_0001",
      "c_0002",
    ];

    List<String> obligations = [
      "obl_0001",
      "obl_0002",
      "obl_0003",
    ];

    List<String> terms = [
      "t_0001",
      "t_0002",
    ];

    _generateOfflineContract(
        "con_0001",
        "categoryBusinessToConsumer",
        "statusUpdated",
        "written",
        DateTime.parse("2022-07-10"),
        DateTime.parse("2022-08-10"),
        DateTime.parse("2022-07-10"),
        "Online",
        "Sharing Personal Data",
        "Selling Personal Data",
        "300", //kept at parse incase type is changed back to string.
        contractors,
        obligations,
        terms);
  }

  _generateOfflineContractor(
      String id,
      String name,
      String email,
      String streetAddress,
      String country,
      String city,
      String phone,
      String role) {
    User user = new User(
        id: id,
        name: name,
        email: email,
        streetAddress: streetAddress,
        country: country,
        city: city,
        phone: phone,
        role: role);

    offlineUsers.add(user);
  }

  _generateOfflineObligation(
      String obligationId,
      String contractId,
      String contractorId,
      String termId,
      String description,
      DateTime endDate,
      DateTime executionDate,
      String state) {
    Obligation obligation = new Obligation(
        id: obligationId,
        contractId: contractId,
        contractorId: contractorId,
        termId: termId,
        description: description,
        endDate: endDate,
        executionDate: executionDate,
        state: state);

    offlineObligations.add(obligation);
  }

  _generateOfflineTermType(String termTypeId, String description, String name) {
    TermType termType =
        new TermType(id: termTypeId, description: description, name: name);

    offlineTermTypes.add(termType);
  }

  _generateOfflineTerm(String termId, String termTypeId, String contractId,
      String description, String name) {
    Term term = new Term(
        id: termId,
        termTypeId: termTypeId,
        contractId: contractId,
        description: description,
        name: name);

    offlineTerms.add(term);
  }

  _generateOfflineContract(
      String contractId,
      String category,
      String status,
      String type,
      DateTime effectiveDate,
      DateTime endDate,
      DateTime executionDate,
      String medium,
      String purpose,
      String considDescription,
      String considValue,
      List contractors,
      List obligations,
      List terms) {
    Contract contract = new Contract(
      id: contractId,
      category: category,
      status: status,
      type: type,
      effectiveDate: effectiveDate,
      endDate: endDate,
      executionDate: executionDate,
      medium: medium,
      purpose: purpose,
      consideration: considDescription,
      value: considValue,
    );

    contract.contractors = contractors;
    contract.obligations = obligations;
    contract.terms = terms;

    offlineContracts.add(contract);
  }
}
