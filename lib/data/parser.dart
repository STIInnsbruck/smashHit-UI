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
    contract.contractors.add(User(id: jsonContract["bindings"][0]["contractors"]["value"]));

    return contract;
  }

  List<Contract> parseAllContracts(List jsonList) {
    return jsonList.map((jsonContract) => parseContract(jsonContract)).toList();
  }

  DateTime formatDate(String dateString) {
    dateString = dateString.substring(45);
    print("formatDateString = $dateString");
    return DateTime.parse(dateString);
  }
}
