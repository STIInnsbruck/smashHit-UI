import 'package:smashhit_ui/data/models.dart';

List<User> hardCodeRequesters = [
  requesterOne,
  requesterTwo,
  requesterThree,
  requesterFour
];

User requesterOne = User(
  id: "c_12d91e9e-0d1a-11ed-a172-0242ac150002",
  createDate: DateTime.parse("20220919"),
  vat: "1111111",
  name: "Minjob GmbH",
  email: "contact@minjob.de"
);

User requesterTwo = User(
  id: "c_d6c5b656-0d19-11ed-8ab1-0242ac150002",
  createDate: DateTime.parse("20220919"),
  vat: "1111111",
  name: "Datalyzer KG",
  email: "support@datalyzer.com"
);

User requesterThree = User(
  id: "c_3ea24178-0d19-11ed-94d9-0242ac150002",
  createDate: DateTime.parse("20220919"),
  vat: "1111111",
  name: "YourDataForMoney SARL",
  email: "contact@yourdataformoney.com"
);

User requesterFour = User(
  id: "21d62043878d4506a552683bec832eab",
  createDate: DateTime.parse("20220919"),
  vat: "1111111",
  name: "Datalytics",
  email: "datalytics@email.com"
);