import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';

List<Signature> signatureToOne = [
  signatureOneToOne,
  signatureTwoToOne
];

List<Signature> signatureToTwo = [
  signatureTwoToOne
];

List<Signature> signatureToThree = [
  signatureOneToOne,
];

Signature signatureOneToOne = Signature(
  contractId: "contb2c_ecd23c94-3a91-11ed-b90a-0242ac150003",
  contractorId: "28d62043878d4506a552683bec832eab",
  signatureText: "signed",
  createDate: DateTime.parse("20220922"),
  id: "sig_ed4c0380-3a91-11ed-8387-0242ac150003"
);

Signature signatureTwoToOne = Signature(
    contractId: "contb2c_ecd23c94-3a91-11ed-b90a-0242ac150003",
    contractorId: "c_4b0aa050-38f6-11ed-b3b1-0242ac150002",
    signatureText: "signed",
    createDate: DateTime.parse("20220922"),
    id: "sig_15103aee-3a92-11ed-a5d4-0242ac150003"
);