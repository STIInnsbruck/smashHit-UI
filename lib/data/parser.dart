import 'package:smashhit_ui/data/models.dart';

class ResponseParser {

  //USER PARSERS
  User parseUser(Map jsonUser) {
    return User(
      id: jsonUser['Contractor']['value'].toString().replaceAll('http://ontologies.atb-bremen.de/smashHitCore#', ''),
      name: jsonUser['name']['value'].toString().replaceAll('http://ontologies.atb-bremen.de/smashHitCore#', ''),
      streetAddress: jsonUser['address'] == null ? null : jsonUser['address']['value'].toString().replaceAll('http://ontologies.atb-bremen.de/smashHitCore#', ''),
      //state: jsonUser['state']['value'].toString().replaceAll('http://ontologies.atb-bremen.de/smashHitCore#', ''),
      city: jsonUser['territory']['value'].toString().replaceAll('http://ontologies.atb-bremen.de/smashHitCore#', ''),
      country: jsonUser['country']['value'].toString().replaceAll('http://ontologies.atb-bremen.de/smashHitCore#', ''),
      email: jsonUser['email'] == null ? null : jsonUser['email']['value'].toString().replaceAll('http://ontologies.atb-bremen.de/smashHitCore#', ''),
      telephoneNumber: jsonUser['phone'] == null ? null : jsonUser['phone']['value'].toString().replaceAll('http://ontologies.atb-bremen.de/smashHitCore#', ''),
    );
  }

  List<User> parseAllUsers(List jsonList) {
    return jsonList.map((jsonUser) => parseUser(jsonUser)).toList();
  }

  User parseUserById(Map jsonUser) {
    return User(
      id: jsonUser['ContractorID'],
      streetAddress: jsonUser['address'],
      country: jsonUser['country'],
      email: jsonUser['email'],
      name: jsonUser['name'],
      telephoneNumber: jsonUser['phone'],
      city: jsonUser['territory'],
    );
  }

  List<User> parseAllUsersById(List jsonList) {
    return jsonList.map((jsonUser) => parseUserById(jsonUser)).toList();
  }

  //CONTRACT PARSERS
  Contract parseContract(Map jsonContract) {
    return Contract(contractId: jsonContract['Contract']);
  }

  Contract parseContractId(Map jsonContract) {
    //initiate contract with its foundational data.
    Contract contract = new Contract(
        contractId: jsonContract['Contract'],
        contractStatus: jsonContract['ContractStatus'],
        contractType: jsonContract['ContractType'],
        effectiveDate: formatDate(jsonContract["EffectiveDate"]),
        executionDate: formatDate(jsonContract["ExecutionDate"]),
        endDate: formatDate(jsonContract["ExecutionDate"]),
        medium: jsonContract["Medium"],
        purpose: jsonContract['Purpose'],
        consentId: jsonContract['ConsentId'],
        consideration: jsonContract['consideration'],
        contractCategory: jsonContract['ContractCategory']
    );

    contract.contractors = jsonContract['identifiers']['contractors'];
    contract.obligations = jsonContract['identifiers']['obligations'];
    contract.terms = jsonContract['identifiers']['terms'];

    return contract;
  }

  List<Contract> parseAllContracts(List jsonList) {
    return jsonList.map((jsonContract) => parseContract(jsonContract)).toList();
  }

  //OBLIGATION PARSERS
  Obligation parseObligation(Map jsonObligation) {
    return Obligation(id: jsonObligation['Obligation']['value']);
  }

  Obligation parseObligationId(Map jsonObligation) {
    //initiate obligation with its foundational data.
    Obligation obligation = new Obligation(
      id: jsonObligation["obligationID"],
      description: jsonObligation["description"],
      executionDate: jsonObligation["execution_date"],
      endDate: jsonObligation["end_date"],
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

  //TERM PARSERS
  Term parseTerm(Map jsonTerm) {
    return Term(id: jsonTerm['Term']);
  }

  Term parseTermId(Map jsonTerm) {
    Term term = new Term(
      id: jsonTerm["TermId"],
      description: jsonTerm["description"],
      contractId: jsonTerm["ContractId"],
      termTypeId: jsonTerm["TermTypeId"]
    );

    return term;
  }

  List<Term> parseAllTerm(List jsonList) {
    return jsonList.map((jsonTerm) => parseTerm(jsonTerm)).toList();
  }

  //TERMTYPE PARSERS
  TermType parseTermType(Map jsonTermType) {
    return TermType(id: jsonTermType["TermTypeId"]);
  }

  TermType parseTermTypeId(Map jsonTermType) {
    TermType termType = new TermType(
      id: jsonTermType["TermTypeId"],
      description: jsonTermType["description"],
      name: jsonTermType["name"]
    );

    return termType;
  }

  List<TermType> parseAllTermTypes(List jsonList) {
    return jsonList.map((jsonTermType) => parseTermType(jsonTermType)).toList();
  }

  DateTime formatDate(String dateString) {
    return DateTime.parse(dateString);
  }
}
