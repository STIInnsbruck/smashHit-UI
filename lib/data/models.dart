import 'package:flutter/material.dart';

class User {
  String? id;
  String? name;
  String? email;
  String? streetAddress;
  String? state;
  String? country;
  String? city;
  String? telephoneNumber;
  String? role;

  User({this.id, this.name, this.email, this.streetAddress, this.state, this.country, this.city, this.telephoneNumber, this.role});

  String? get getId => id;
  String? get getName => name;

  @override
  String toString() {
    return '$name, $email';
  }

}

/// Contract model. There is always one party creating the contract (= contractor)
/// and there can be 1 or more parties that accept the contract (= contractee).
/// If the contract is supposed to only be an instant contract lasting for a day,
/// then make the startDate and endDate the same date.
class Contract {
  String? contractId;
  String? contractType;
  String? contractorId;
  String? contracteeId;
  ContractObject? contractObject;
  String? title;
  String? description;
  DateTime? executionDate;
  DateTime? expireDate;
  String? contractStatus;
  IconData? iconData;

  Contract({
    required this.contractId,
    this.contractType,
    this.contractorId,
    this.contracteeId,
    this.title,
    this.description,
    this.executionDate,
    this.expireDate,
    this.contractStatus,
    this.contractObject,
    this.iconData
  }) {
    this.title = title;
  }

  /// Returns an int given the contract's status. The int is needed for the
  /// contract_status_bar as it takes in an int to track the process.
  int getContractStatusAsInt() {
    switch (contractStatus) {
      case "Created":
        return 0;
      case "Offer":
        return 1;
      case "Agreement":
        return 2;
      case "Done":
        return 3;
      case "http://ontologies.atb-bremen.de/smashHitCore#Valid":
        return 4;
      case "Violation":
        return 5;
    }
    return -1;
  }

  String formatContractType() {
    return this.contractType!.replaceAll('http://ontologies.atb-bremen.de/smashHitCore#', '');
  }

  String formatContractor() {
    return this.contractorId!.replaceAll('http://ontologies.atb-bremen.de/smashHitCore#', '');
  }

  String formatContractee() {
    return this.contracteeId!.replaceAll('http://ontologies.atb-bremen.de/smashHitCore#', '');
  }

  String formatContractId() {
    return this.contractId!.replaceAll('http://ontologies.atb-bremen.de/smashHitCore#', '');
  }

  static DateTime formatDate(String dateString) {
    var length = dateString.length;
    int year = int.parse(dateString.substring(length - 4, length));
    int month = int.parse(dateString.substring(length - 7, length - 5));
    int day = int.parse(dateString.substring(length - 10, length - 8));
    DateTime date = new DateTime(year, month, day);

    return date;
  }

  /// Return an IconData depending on the contract type. This is used for the
  /// dashboard page to display contract tiles and show the contract type with
  /// an icon. In the event of having a contract type that is not listed, the
  /// default icon Icon.description is given.
  IconData getIconDataFromContractType() {
    switch (contractType) {
    }
    //Default icon incase another type of Contract was given but is not listed here.
    return Icons.description;
  }
}

/// Object model to be used in a Contract. It describes the actual object
/// (fictive or physical) that is handled in the contract.
class ContractObject {
  String? _description;

  ContractObject(String description) {
    this._description = description;
  }

  String? get getDescription => _description;

  set setDescription(String description) {
    _description = description;
  }
}
