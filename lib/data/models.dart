import 'package:flutter/material.dart';

class User {
  int? _id;
  String? _name;
  String? _email;
  String? _streetAddress;
  int? _telephoneNumber;
  String? _role;

  User(this._role);

  int? get getId => _id;
  String? get getName => _name;
  String? get role => _role;

  set setName(String value) {
    _name = value;
  }
}

/// Contract model. There is always one party creating the contract (= contractor)
/// and there can be 1 or more parties that accept the contract (= contractee).
/// If the contract is supposed to only be an instant contract lasting for a day,
/// then make the startDate and endDate the same date.
class Contract {
  String? contractId;
  String? contractType;
  String? contractor;
  String? contractee;
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
    this.contractor,
    this.contractee,
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
    return this.contractType!.substring(45, this.contractType!.length);
  }

  String formatContractor() {
    return this.contractor!.substring(45, this.contractor!.length);
  }

  String formatContractee() {
    return this.contractee!.substring(45, this.contractee!.length);
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
