class User {
  int _id;
  String _name;

  User(int id, String name) {
    this._id = id;
    this._name = name;
  }

  int get getId => _id;
  String get getName => _name;
  
  set setName(String value) { _name = value; }
}

/// Status for the current situation of the contract.
/// Offer = sent the contract to the other parties.
enum Status {
  Created,
  Offer,
  Agreement,
  Denied,
  Discussion
}

/// Contract model. There is always one party creating the contract (= contractor)
/// and there can be 1 or more parties that accept the contract (= contractee).
/// If the contract is supposed to only be an instant contract lasting for a day,
/// then make the startDate and endDate the same date.
class Contract {
  User contractor;
  List<User> contractee = [];
  ContractObject contractObject;
  String title;
  String description;
  DateTime startDate;
  DateTime endDate;
  Status status;
}


/// Object model to be used in a Contract. It describes the actual object
/// (fictive or physical) that is handled in the contract.
class ContractObject {
  String _description;

  ContractObject(String description) {
    this._description = description;
  }

  String get getDescription => _description;

  set setDescription(String description) { _description = description; }
}