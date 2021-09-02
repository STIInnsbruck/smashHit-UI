import 'package:flutter/material.dart';

class User {
  int? _id;
  String? _name;
  String? _email;
  String? _streetAddress;
  int? _telephoneNumber;
  String? _role;

  User(this._name);

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
  User? contractor;
  User? contractee;
  ContractObject? contractObject;
  String? title;
  String? description;
  DateTime? executionDate;
  DateTime? expireDate;
  String? contractStatus;
  IconData? iconData;

  Contract({
    required this.contractId,
    required this.contractType,
    required this.contractor,
    required this.contractee,
    required this.title,
    required this.description,
    required this.executionDate,
    required this.expireDate,
    this.contractStatus,
    this.contractObject,
    this.iconData
  });

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
    }
    return 0;
  }

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      contractId: json['Contract']['value'],
      contractType: json['ContractType']['value'],
      contractor: json['ContractRequester']['value'],
      contractee: json['ContractProvider']['value'],
      title: "Contract Title (Hardcoded, not in ontology.)",
      description: json['Purpose']['value'],
      executionDate: formatDate(json["ExecutionDate"]["value"]),
      expireDate: formatDate(json["EndingDate"]["value"]),
      contractStatus: "Created"
    );
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
