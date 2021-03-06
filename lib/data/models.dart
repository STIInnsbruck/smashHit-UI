import 'package:flutter/material.dart';

class User {
  String? id;
  String? name;
  String? email;
  String? streetAddress;
  String? country;
  String? city;
  String? phone;
  String? role;
  String? companyId;
  String? vat;
  DateTime? createDate;

  User({this.id, this.name, this.email, this.streetAddress, this.country, this.city, this.phone, this.role, this.companyId, this.vat, this.createDate});

  String? get getId => id;
  String? get getName => name;

  @override
  String toString() {
    return '$name, $email';
  }

  ///Display user's creation date in format YYYY.MM.DD
  String displayCreationDate() {
    String dateString = "";
    dateString += createDate!.toIso8601String().substring(0, 4);
    dateString += ".";
    dateString += createDate!.toIso8601String().substring(5, 7);
    dateString += ".";
    dateString += createDate!.toIso8601String().substring(8, 10);
    return dateString;
  }

}

/// Contract model. There is always one party creating the contract (= contractor)
/// and there can be 1 or more parties that accept the contract (= contractee).
/// If the contract is supposed to only be an instant contract lasting for a day,
/// then make the startDate and endDate the same date.
class Contract {
  String? consentId;
  String? contractId;
  String? contractCategory;
  String? contractStatus;
  String? contractType;
  DateTime? effectiveDate;
  DateTime? endDate;
  DateTime? executionDate;
  String? medium;
  String? purpose;
  String? considerationDescription;
  String? considerationValue;
  List contractors = [];
  List obligations = [];
  List terms = [];
  List signatures = [];


  Contract({
    this.contractId,
    this.consentId,
    this.contractCategory,
    this.contractStatus,
    this.contractType,
    this.executionDate,
    this.endDate,
    this.effectiveDate,
    this.medium,
    this.purpose,
    this.considerationDescription,
    this.considerationValue
  });

  /// Returns an int given the contract's status. The int is needed for the
  /// contract_status_bar as it takes in an int to track the process.
  int getContractStatusAsInt() {
    switch (contractStatus) {
      case "http://ontologies.atb-bremen.de/smashHitCore#Created":
        return 0;
      case "http://ontologies.atb-bremen.de/smashHitCore#Offer":
        return 1;
      case "http://ontologies.atb-bremen.de/smashHitCore#Agreement":
        return 2;
      case "http://ontologies.atb-bremen.de/smashHitCore#Done":
        return 3;
      case "http://ontologies.atb-bremen.de/smashHitCore#Valid":
        return 4;
      case "http://ontologies.atb-bremen.de/smashHitCore#Violation":
        return 5;
    }
    return -1;
  }

  String getContractType() {
    return this.contractType!.replaceAll('http://ontologies.atb-bremen.de/smashHitCore#', '');
  }

  String getFormattedEffectiveDate() {
    String dateString = "${this.effectiveDate!.day}.${this.effectiveDate!.month}.${this.effectiveDate!.year}";
    return dateString;
  }

  String getFormattedStartDate() {
    String dateString = "${this.executionDate!.day}.${this.executionDate!.month}.${this.executionDate!.year}";
    return dateString;
  }

  String getFormattedExecutionDate() {
    String dateString = "${this.executionDate!.day}.${this.executionDate!.month}.${this.executionDate!.year}";
    return dateString;
  }

  String getFormattedEndDate() {
    String dateString = "${this.endDate!.day}.${this.endDate!.month}.${this.endDate!.year}";
    return dateString;
  }

  String getContractorName() {
    return this.contractors[0].replaceAll('http://ontologies.atb-bremen.de/smashHitCore#', '');
  }

  String getContracteeName() {
    return this.contractors[0].replaceAll('http://ontologies.atb-bremen.de/smashHitCore#', '');
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

  String displayDate(DateTime date) {
    String year = date.year.toString();
    String month = date.month.toString();
    String day = date.day.toString();

    return "$day.$month.$year";
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

///Obligation model used in a Contract. Every party involved in a contract also
///has an obligation which they must fulfill in order to maintain a valid
///contract.
///[description] is the actual task description of the obligation that is to be
///fulfilled.
///[type] is the obligation type. Example: Payment or Delivery as an obligation.
///[userId] the ID of the user to whom this obligation applies.
///[contractId] the ID of the contract to which this obligation applies.
///[startDate] the start date of this obligation. Must be equal or later than
///the start date AND equal or less than the end date of the contract.
///[endDate] the end date of this obligation. Must be equal or greater than it's
///own start date AND equal or less than the end date of the contract.
///[status] the status of the obligation, stating it it has been fulfilled or
///not.
class Obligation {
  String? id;
  String? contractId;
  String? contractorId;
  String? termId;
  String? description;
  DateTime? endDate;
  DateTime? executionDate;
  String? state;

  Obligation({
    this.id,
    this.contractId,
    this.contractorId,
    this.termId,
    this.description,
    this.endDate,
    this.executionDate,
    this.state
  });

  String getExecutionDateAsString() {
    String dateString = "${executionDate!.day}.${executionDate!.month}.${executionDate!.year}";
    return dateString;
  }

  String getEndDateAsString() {
    String dateString = "${endDate!.day}.${endDate!.month}.${endDate!.year}";
    return dateString;
  }
}

class Term {
  String? id;
  String? termTypeId;
  String? contractId;
  String? description;
  String? name;

  Term({this.id, this.termTypeId, this.contractId, this.description, this.name});

  factory Term.fromTemplateJson(Map<String, dynamic> json) {
    return Term(
      id: json['id'],
      description: json['description'],
      termTypeId: json['termTypeId'],
      name: json['name']
    );
  }
}

class TermType {
  String? id;
  String? description;
  String? name;

  TermType({this.id, this.description, this.name});

  factory TermType.fromJson(Map<String, dynamic> json) {
    return TermType(
      id: json['id'],
      description: json['description'],
      name: json['name']
    );
  }
}

class Signature {
  String? id;
  String? contractId;
  String? contractorId;
  DateTime? createDate;
  String? signatureText;

  Signature({this.id, this.contractId, this.contractorId, this.createDate, this.signatureText});
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
