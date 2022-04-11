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
    return Contract(contractId: jsonContract['Contract']['value']);
  }

  Contract parseContractId(Map jsonContract) {
    List contractContent = jsonContract["bindings"];
    //initiate contract with its foundational data.
    Contract contract = new Contract(
        contractId: contractContent[0]['Contract']['value'].substring(45),
        contractStatus: contractContent[0]['ContractStatus']['value'].substring(45),
        contractType: contractContent[0]['ContractType']['value'].substring(45),
        effectiveDate: formatDate(contractContent[0]["EffectiveDate"]["value"].substring(45)),
        executionDate: formatDate(contractContent[0]["ExecutionDate"]["value"].substring(45)),
        endDate: formatDate(contractContent[0]["ExecutionDate"]["value"].substring(45)),
        medium: contractContent[0]["Medium"]["value"],
        purpose: contractContent[0]['Purpose']['value'],
        //TODO: add consideration
    );
    //insert first contractor, obligation, and term.
    contract.contractors.add(contractContent[0]["contractors"]["value"].substring(45));
    contract.obligations.add(contractContent[0]["obligations"]["value"].substring(45));
    contract.terms.add(contractContent[0]["terms"]["value"].substring(45));

    //check if there are any other contractors, obligations, or terms.
    for(int i = 1; i < contractContent.length; i++) {
      //First check if we're still in the same contract, otherwise break.
      if(contract.contractId!.compareTo(contractContent[i]["Contract"]["value"].substring(45)) == 0) {
        //Check if the termId is already inserted, otherwise insert.
        if(!contract.terms.contains(contractContent[i]["terms"]["value"].substring(45))) {
          contract.terms.add(contractContent[i]["terms"]["value"].substring(45));
        }
        //check if obligationId is already inserted, otherwise insert.
        if(!contract.obligations.contains(contractContent[i]["obligations"]["value"].substring(45))) {
          contract.obligations.add(contractContent[i]["obligations"]["value"].substring(45));
        }
        //check if userId is already inserted, otherwise insert.
        if(!contract.contractors.contains(contractContent[i]["contractors"]["value"].substring(45))) {
          contract.contractors.add(contractContent[i]["contractors"]["value"].substring(45));
        }
      } else {
        break;
      }

    }

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
    List obligationContent = jsonObligation["bindings"];
    //initiate obligation with its foundational data.
    Obligation obligation = new Obligation(
      id: obligationContent[0]["Obligation"]["value"].substring(45),
      description: obligationContent[0]["description"]["value"],
      executionDate: obligationContent[0]["executiondate"]["value"],
      endDate: obligationContent[0]["enddate"]["value"],
      state: obligationContent[0]["state"]["value"].substring(45),
      //the first json has contractorId
      contractorId: obligationContent[0]["identifier"]["value"].substring(45),
      //the second json has termId
      termId: obligationContent[1]["identifier"]["value"].substring(45),
      //the third json has contractId
      contractId: obligationContent[2]["identifier"]["value"].substring(45),
    );

    return obligation;

  }

  List<Obligation> parseAllObligations(List jsonList) {
    return jsonList.map((jsonObligation) => parseObligation(jsonObligation)).toList();
  }

  //TERM PARSERS
  Term parseTerm(Map jsonTerm) {
    return Term(id: jsonTerm['Term']['value']);
  }

  Term parseTermId(Map jsonTerm) {
    Term term = new Term(
      id: jsonTerm["bindings"][0]["Term"]["value"],
      description: jsonTerm["bindings"][0]["description"]["value"],
      name: jsonTerm["bindings"][0]["name"]["value"]
    );

    return term;
  }

  List<Term> parseAllTerm(List jsonList) {
    return jsonList.map((jsonTerm) => parseTerm(jsonTerm)).toList();
  }

  DateTime formatDate(String dateString) {
    return DateTime.parse(dateString);
  }
}
