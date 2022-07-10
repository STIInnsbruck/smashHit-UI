import 'package:smashhit_ui/data/models.dart';

class ResponseParser {

  //USER PARSERS
  User parseUser(Map jsonUser) {
    return User(
      id: jsonUser['contractorId'],
      name: jsonUser['name'],
      streetAddress: jsonUser['address'],
      city: jsonUser['territory'],
      country: jsonUser['country'],
      email: jsonUser['email'],
      phone: jsonUser['phone'],
    );
  }

  List<User> parseAllUsers(List jsonList) {
    return jsonList.map((jsonUser) => parseUser(jsonUser)).toList();
  }

  User parseUserById(Map jsonUser) {
    return User(
      id: jsonUser['contractorId'],
      streetAddress: jsonUser['address'],
      country: jsonUser['country'],
      email: jsonUser['email'],
      name: jsonUser['name'],
      phone: jsonUser['phone'],
      city: jsonUser['territory'],
    );
  }

  List<User> parseAllUsersById(List jsonList) {
    return jsonList.map((jsonUser) => parseUserById(jsonUser)).toList();
  }

  //CONTRACT PARSERS
  Contract parseContract(Map jsonContract) {
    return Contract(
        contractId: jsonContract['Contract'],
        purpose: jsonContract['Purpose'],
        contractStatus: jsonContract['ContractStatus']
    );
  }

  Contract parseContractId(Map jsonContract) {
    //initiate contract with its foundational data.
    Contract contract = new Contract(
        contractId: jsonContract['contractId'],
        contractStatus: jsonContract['contractStatus'],
        contractType: jsonContract['contractType'],
        effectiveDate: formatDate(jsonContract["effectiveDate"]),
        executionDate: formatDate(jsonContract["executionDate"]),
        endDate: formatDate(jsonContract["endDate"]),
        medium: jsonContract["medium"],
        purpose: jsonContract['purpose'],
        consentId: jsonContract['consentId'],
        considerationDescription: jsonContract['consideration'],
        considerationValue: jsonContract['value'],
        contractCategory: jsonContract['contractCategory']
    );

    contract.contractors = jsonContract['identifiers']['contractors'];
    contract.obligations = jsonContract['identifiers']['obligations'];
    contract.terms = jsonContract['identifiers']['terms'];

    return contract;
  }

  List<Contract> parseAllContracts(List jsonList) {
    return jsonList.map((jsonContract) => parseContractId(jsonContract)).toList();
  }

  //OBLIGATION PARSERS
  Obligation parseObligation(Map jsonObligation) {
    return Obligation(id: jsonObligation['Obligation']['value']);
  }

  Obligation parseObligationId(Map jsonObligation) {
    //initiate obligation with its foundational data.
    Obligation obligation = new Obligation(
      id: jsonObligation["obligationID"],
      description: jsonObligation["obligationDescription"],
      executionDate: formatDate(jsonObligation["executionDate"]),
      endDate: formatDate(jsonObligation["endDate"]),
      state: jsonObligation["state"],
      //the first json has contractorId
      contractorId: jsonObligation["identifier"][0],
      //the second json has obligationId
      contractId: jsonObligation["identifier"][1],
      //the third json has termiId
      termId: jsonObligation["identifier"][2],
    );

    return obligation;
  }

  List<Obligation> parseAllObligations(List jsonList) {
    return jsonList.map((jsonObligation) => parseObligation(jsonObligation)).toList();
  }

  List<Obligation> parseAllObligationsId(List jsonList) {
    return jsonList.map((jsonObligation) => parseObligationId(jsonObligation)).toList();
  }

  //TERM PARSERS
  Term parseTerm(Map jsonTerm) {
    return Term(id: jsonTerm['Term']);
  }

  Term parseTermId(Map jsonTerm) {
    Term term = new Term(
      id: jsonTerm["termId"],
      description: jsonTerm["description"]
    );

    return term;
  }

  List<Term> parseAllTerm(List jsonList) {
    return jsonList.map((jsonTerm) => parseTerm(jsonTerm)).toList();
  }

  //TERMTYPE PARSERS
  TermType parseTermType(Map jsonTermType) {
    return TermType(
        id: jsonTermType["TermTypeId"],
        description: jsonTermType["description"],
        name: jsonTermType["name"]
    );
  }

  List<TermType> parseAllTermTypes(List jsonList) {
    return jsonList.map((jsonTermType) => parseTermType(jsonTermType)).toList();
  }

  DateTime formatDate(String dateString) {
    return DateTime.parse(dateString.substring(0, 10));
  }
}
