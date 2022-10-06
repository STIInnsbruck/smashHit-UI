import 'package:flutter/material.dart';
import 'package:smashhit_ui/data/models.dart';

List<TermType> hardCodeTermTypes = [
  termTypeOne,
  termTypeTwo,
  termTypeThree
];

TermType termTypeOne = TermType(
  id: "term_type_ed9c6096-3a91-11ed-af72-0242ac150003",
  name: "Lease Agreement",
  description: """This Lease Agreement (this "Agreement") is made [ENTER DATE] by and between:\nLandlord: [ENTER NAME] ("Landlord") AND Tenant(s) [ENTER NAME] ("Tenant"). In the event there is more than one Tenant, each reference to "Tenant" shall apply to each of them, jointly and severally. Each Tenant is jointly and severally liable to Landlord for payment of rent and performance in accordance with all other terms of this Agreement. Each Landlord and Tenant may be referred to individually as "Party" and collectively as the "Parties".\n1. Premises. The premises leased is a/an [ENTER BUILDING TYPE (example: apartment or house)] with (a) [ENTER NUMBER] bedroom(s), (b) [ENTER NUMBER], (c) [ENTER NUMBER] parking space(s) with the premises located at [ENTER COMPLETE STREET ADDRESS] (the "Premises")."""
);

TermType termTypeTwo = TermType(
    id: "term_type_38254574-38df-11ed-8a01-0242ac150002",
    name: "Marketing",
    description: """[ENTER NAME] would like to send you information about products and services of ours that we think you might like, as well as those of our partner companies.\n- [LIST PARTNER COMPANIES THAT WILL RECEIVE DATA]\nIf you have agreed to receive marketing, you may always opt out at a later date.\nYou have the right at any time to stop [ENTER NAME] from contacting you for marketing purposes or giving your data to other members of the [ENTER NAME] Group.\nIf you no longer wish to be contacted for marketing purposes, please [ENTER ACTION FOR DATA SUBJECT TO PERFORM]."""
);

TermType termTypeThree = TermType(
    id: "term_type_28846574-98vm-34ui-8l45-0242ac150002",
    name: "Amendment",
    description: "This Agreement may be amended or modified only by a written agreement signed by the Parties."
);