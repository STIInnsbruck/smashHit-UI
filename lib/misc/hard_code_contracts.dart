import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';

List<Contract> hardCodeContracts = [
  contractOne,
  contractTwo,
  contractThree
];

Contract contractOne = Contract(
    id: "contb2c_ecd23c94-3a91-11ed-b90a-0242ac150003",
    purpose: "Vehicle Sales Agreement",
    medium: "App Based",
    consideration: "Selling Max Mustermanns Vehicle to Carsten Skacel",
    value: "12000",
    endDate: DateTime.parse("20220923"),
    effectiveDate: DateTime.parse("20220922"),
    executionDate: DateTime.parse("20220922"),
    status: "hasSigned",
    category: "Business to Consumer",
    consentId: null,
    type: "Written"
);

Contract contractTwo = Contract(
    id: "contb2c_fcd23asd4-3sd91-1sdfd-b90a-0242ac150003",
    purpose: "Purchase Agreement",
    medium: "App Based",
    consideration: "Selling Max Mustermanns Vehicle to Carsten Skacel",
    value: "12000",
    endDate: DateTime.parse("20220923"),
    effectiveDate: DateTime.parse("20220922"),
    executionDate: DateTime.parse("20220922"),
    status: "hasCreated",
    category: "Business to Consumer",
    consentId: null,
    type: "Written"
);

Contract contractThree = Contract(
    id: "contb2c_f1785jasd4-39k91-1sm2d-aa5f-0242ac150003",
    purpose: "Data Sharing Agreement",
    medium: "App Based",
    consideration: "Selling Max Mustermanns Vehicle to Carsten Skacel",
    value: "12000",
    endDate: DateTime.parse("20220923"),
    effectiveDate: DateTime.parse("20220922"),
    executionDate: DateTime.parse("20220922"),
    status: "hasViolated",
    category: "Business to Consumer",
    consentId: null,
    type: "Written"
);
