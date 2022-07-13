import 'package:smashhit_ui/data/models.dart';
///The response from the ACT Swagger API returns several different forms of
///responses. For this reason there are several different parsers for one
///class.
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

  User parseUserRegister(Map jsonUser) {
    return User(
      id: jsonUser["contractorId"],
      streetAddress: jsonUser["address"],
      companyId: jsonUser["companyId"],
      country: jsonUser["country"],
      createDate: formatDate(jsonUser["createDate"]),
      email: jsonUser["email"],
      name: jsonUser["name"],
      phone: jsonUser["phone"],
      role: jsonUser["role"],
      city: jsonUser["territory"],
      vat: jsonUser["vat"],
    );
  }

  List<User> parseAllUsers(List jsonList) {
    return jsonList.map((jsonUser) => parseUser(jsonUser)).toList();
  }

  User parseUserById(Map jsonUser) {
    return User(
      id: jsonUser['contractorId'],
      streetAddress: jsonUser['address'],
      companyId: jsonUser['companyId'],
      country: jsonUser['country'],
      createDate: formatDate(jsonUser["createDate"]),
      email: jsonUser['email'],
      name: jsonUser['name'],
      phone: jsonUser['phone'],
      city: jsonUser['territory'],
      role: jsonUser['role'],
      vat: jsonUser['vat']
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
      id: jsonObligation["obligationId"],
      description: jsonObligation["obligationDescription"],
      executionDate: formatDate(jsonObligation["executionDate"]),
      endDate: formatDate(jsonObligation["endDate"]),
      state: jsonObligation["state"],
      //the first json has contractorId
      contractorId: jsonObligation["identifier"][1],
      //the second json has obligationId
      contractId: jsonObligation["identifier"][2],
      //the third json has termiId
      termId: jsonObligation["identifier"][3],
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
        id: jsonTermType["termTypeId"],
        description: jsonTermType["description"],
        name: jsonTermType["name"]
    );
  }

  List<TermType> parseAllTermTypes(List jsonList) {
    return jsonList.map((jsonTermType) => parseTermType(jsonTermType)).toList();
  }

  //OTHER PARSERS
  String parseSuccessResponse(Map jsonSuccess) {
    return jsonSuccess["Success"];
  }

  ///The first ten digits in a response for a date format is YYYY-MM-DD.
  ///The rest of the information is superfluous.
  DateTime formatDate(String dateString) {
    return DateTime.parse(dateString.substring(0, 10));
  }
}
