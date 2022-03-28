import 'package:smashhit_ui/data/models.dart';

class ResponseParser {

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

  List<User> parseAllUsersById(List jsonList) {
    return jsonList.map((jsonUser) => parseUserById(jsonUser)).toList();
  }

  Contract parseContract(Map jsonContract) {
    return Contract(contractId: jsonContract['Contract']['value']);
  }

  Contract parseContractId(Map jsonContract) {
    List contractContent = jsonContract["bindings"];
    Contract contract = new Contract(
        contractId: contractContent[0]['Contract']['value'],
        contractStatus: contractContent[0]['ContractStatus']['value'],
        contractType: contractContent[0]['ContractType']['value'],
        effectiveDate: formatDate(contractContent[0]["EffectiveDate"]["value"]),
        executionDate: formatDate(contractContent[0]["ExecutionDate"]["value"]),
        endDate: formatDate(contractContent[0]["ExecutionDate"]["value"]),
        medium: contractContent[0]["Medium"]["value"],
        purpose: contractContent[0]['Purpose']['value'],
        //TODO: add consideration
        //TODO: add obligations
        //TODO: add terms
    );
    contract.contractors.add(contractContent[0]["contractors"]["value"]);
    contract.obligations.add(contractContent[0]["obligations"]["value"]);
    contract.terms.add(contractContent[0]["terms"]["value"]);

    for(int i = 1; i < contractContent.length; i++) {
      //First check if we're still in the same contract, otherwise break.
      if(contract.contractId!.compareTo(contractContent[i]["Contract"]["value"]) == 0) {
        //Check if the termId is already inserted, otherwise insert.
        if(!contract.terms.contains(contractContent[i]["terms"]["value"])) {
          contract.terms.add(contractContent[i]["terms"]["value"]);
        }
        //check if obligationId is already inserted, otherwise insert.
        if(!contract.obligations.contains(contractContent[i]["obligations"]["value"])) {
          contract.obligations.add(contractContent[i]["obligations"]["value"]);
        }
        //check if userId is already inserted, otherwise insert.
        if(!contract.contractors.contains(contractContent[i]["contractors"]["value"])) {
          contract.contractors.add(contractContent[i]["contractors"]["value"]);
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

  DateTime formatDate(String dateString) {
    dateString = dateString.substring(45);
    return DateTime.parse(dateString);
  }
}
