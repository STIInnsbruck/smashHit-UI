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
    contract.signatures = jsonContract['identifiers']['signatures'];

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
      contractorId: parseCorrectIdentifier("c_", jsonObligation),
      //the second json has obligationId
      contractId: parseCorrectIdentifier("con", jsonObligation),
      //the third json has termId
      termId: parseCorrectIdentifier("term_", jsonObligation),
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
      description: jsonTerm["description"],
      termTypeId: jsonTerm["termTypeId"],
      contractId: jsonTerm["contractId"]
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

  //SIGNATURE PARSERS
  Signature parseSignatureId(Map jsonSignature) {
    Signature signature = new Signature(
      id: jsonSignature["signatureId"],
      contractId: parseCorrectIdentifier("con", jsonSignature),
      contractorId: parseCorrectIdentifier("c_", jsonSignature),
      signatureText: jsonSignature["signatureText"],
      createDate: formatDate(jsonSignature["createDate"])
    );

    return signature;
  }

  //OTHER PARSERS
  String parseSuccessResponse(Map jsonSuccess) {
    return jsonSuccess["Success"];
  }

  ///Many responses have a list of identifiers in their json format,
  ///within which the IDs of objects sometimes have a different positions in the
  ///list. With [idPrefix] this function searches for the prefix of an
  ///ID to parse the correct position within the given list.
  ///Example:
  ///identifiers: [
  /// c_001 -> represents a contractor, so we have a [idPrefix] of "c_".
  /// con_xx -> represents a contract, so we have a [idPrefix] of "con".
  ///]
  String? parseCorrectIdentifier(String idPrefix, Map jsonObject) {
    for (int i = 0; i < (jsonObject["identifier"] as List).length; i++) {
      if ((jsonObject["identifier"][i] as String).startsWith(idPrefix)) {
        return jsonObject["identifier"][i];
      }
    }
    return "identifier not found";
  }


  ///The first ten digits in a response for a date format is YYYY-MM-DD.
  ///The rest of the information is superfluous.
  DateTime formatDate(String dateString) {
    return DateTime.parse(dateString.substring(0, 10));
  }
}
