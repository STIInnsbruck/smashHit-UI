import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';
import 'package:smashhit_ui/data/data_provider.dart';
import 'package:smashhit_ui/custom_widgets/contractor_tile.dart';
import 'package:smashhit_ui/misc/hard_code_requesters.dart';

class ContractorViewPage extends StatefulWidget {
  final Function(int, [String]) changeScreen;
  final User? user;
  final bool offlineMode;

  ContractorViewPage(this.changeScreen, this.user, this.offlineMode);

  @override
  _ContractorViewPage createState() => _ContractorViewPage();
}

class _ContractorViewPage extends State<ContractorViewPage> {

  DataProvider dataProvider = new DataProvider();

  late Future<List<User>> futureContractorList = [] as Future<List<User>>;
  List<User>? contractorList = hardCodeRequesters;

  @override
  void initState() {
    super.initState();
    contractorList = hardCodeRequesters;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            FutureBuilder<List<User>>(
                future: futureContractorList = dataProvider.fetchAllUsers(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //contractorList = snapshot.data;
                    contractorList = hardCodeRequesters;
                    addStats();
                    //filterOutDummyContractors(snapshot.data!);
                    //filterOutDummyContractors(contractorList!);
                    return Column(
                      children: [
                        listHeader(),
                        contractorListWidget()
                      ],
                    );
                  } else if (snapshot.hasError) {
                    contractorList = hardCodeRequesters;
                    addStats();
                    //filterOutDummyContractors(snapshot.data!);
                    //filterOutDummyContractors(contractorList!);
                    return Column(
                      children: [
                        listHeader(),
                        contractorListWidget()
                      ],
                    );
                    //return Text('${snapshot.error}');
                  }
                  return Center(child: CircularProgressIndicator());
                }
            )
          ],
        )
    );
  }

  ListTile listHeader() {
    return ListTile(
      title: Row(
        children: [
          Expanded(flex: 1, child: Text("Type", textAlign: TextAlign.left)),
          Expanded(flex: 1, child: Text("Name", textAlign: TextAlign.left)),
          Expanded(flex: 1, child: Text("Description", textAlign: TextAlign.left)),
          Expanded(flex: 1, child: Text("Rating", textAlign: TextAlign.left)),
          Spacer(flex: 1)
        ],
      ),
    );
  }

  Widget contractorListWidget() {
    return Expanded(
        child: ListView.builder(
            itemCount: contractorList!.length,
            itemBuilder: (BuildContext context, int index) {
              return ContractorTile(contractor: contractorList![index], changeScreen: widget.changeScreen);
            }
        )
    );
  }

  void filterOutDummyContractors(List<User> list) {
    //contractorList!.clear();
    const String dummyId1 = "c_12d91e9e-0d1a-11ed-a172-0242ac150002";
    const String dummyId2 = "c_d6c5b656-0d19-11ed-8ab1-0242ac150002";
    const String dummyId3 = "c_3ea24178-0d19-11ed-94d9-0242ac150002";
    const String dummyId4 = "c_951f0046-0d18-11ed-8bcd-0242ac150002";

    for(int i = 0; i < list.length; i++) {
      if (list[i].id == dummyId1 || list[i].id == dummyId2 || list[i].id == dummyId3 || list[i].id == dummyId4) {
        contractorList!.add(addDummyStatistics(list[i]));
      }
    }
  }

  addStats() {
    for(int i = 0; i < contractorList!.length; i++) {
      addDummyStatistics(contractorList![i]);
    }
  }

  User addDummyStatistics(User user) {
    if (user.id == "c_12d91e9e-0d1a-11ed-a172-0242ac150002") {
      return addDummyStats(user, 21, "€1000,00", "41 Days Ago", "Art. 13 (2) GDPR", "100%", 5);
    } else if (user.id == "c_d6c5b656-0d19-11ed-8ab1-0242ac150002") {
      return addDummyStats(user, 0, "€0,00", "None", "None", "20%", 1);
    } else if (user.id == "c_3ea24178-0d19-11ed-94d9-0242ac150002") {
      return addDummyStats(user, 1, "€16'000,00", "437 Days Ago", "Art. 5 (1) a) GDPR", "98%", 4);
    } else {
      return addDummyStats(user, 7, "€5'132,00", "3 Days Ago", "Art. 28 (2) GDPR, Art. 3", "80%", 4);
    }
  }

  User addDummyStats(User user, int numGdprFines, String avgFineAmount, String recentFine, String recentViolation, String oblCompletionRate, int rating) {
    user.numGdprFines = numGdprFines;
    user.avgFineAmount = avgFineAmount;
    user.recentFine = recentFine;
    user.recentViolation = recentViolation;
    user.oblCompetionRate = oblCompletionRate;
    user.rating = rating;

    return user;
  }
}