import 'package:smashhit_ui/data/models.dart';

List<Obligation> hardCodeObligations = [
  obligationOne,
  obligationTwo,
  obligationThree
];

Obligation obligationOne = Obligation(
  id: "ob_eef5a24a-3a91-11ed-8350-0242ac150003",
  endDate: DateTime.parse("20220923"),
  executionDate: DateTime.parse("20220922"),
  description: "Max Mustermann has to pay a deposit of 1920 EURO to Skacel Carsten.",
  state: "statePending",
  contractorId: "28d62043878d4506a552683bec832eab",
  contractId: "contb2c_ecd23c94-3a91-11ed-b90a-0242ac150003",
  termId: "term_ed9c6096-3a91-11ed-af72-0242ac150003"
);
Obligation obligationTwo = Obligation(
    id: "ob_asdg24a-3dfg1-123f-8tfg50-0242ac150003",
    endDate: DateTime.parse("20220927"),
    executionDate: DateTime.parse("20220922"),
    description: "Deliver sold vehicle to Buyer after the payment is completed.",
    state: "statePending",
    contractorId: "28d62043878d4506a552683bec832eab",
    contractId: "contb2c_ecd23c94-3a91-11ed-b90a-0242ac150003",
    termId: "term_ed9c6096-3a91-11ed-af72-0242ac150003"
);

Obligation obligationThree = Obligation(
    id: "ob_as6g4a-3eg1-7j3f-6utg50-0242ac150003",
    endDate: DateTime.parse("20221024"),
    executionDate: DateTime.parse("20220922"),
    description: "Pay rent of 620 EURO to Skacel Carsten.",
    state: "stateValid",
    contractorId: "28d62043878d4506a552683bec832eab",
    contractId: "contb2c_ecd23c94-3a91-11ed-b90a-0242ac150003",
    termId: "term_ed9c6096-3a91-11ed-af72-0242ac150003"
);