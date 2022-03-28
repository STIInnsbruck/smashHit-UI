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
    Contract contract = new Contract(
        contractId: jsonContract["bindings"][0]['Contract']['value'],
        contractStatus: jsonContract["bindings"][0]['ContractStatus']['value'],
        contractType: jsonContract["bindings"][0]['ContractType']['value'],
        effectiveDate: formatDate(jsonContract["bindings"][0]["EffectiveDate"]["value"]),
        executionDate: formatDate(jsonContract["bindings"][0]["ExecutionDate"]["value"]),
        endDate: formatDate(jsonContract["bindings"][0]["ExecutionDate"]["value"]),
        medium: jsonContract["bindings"][0]["Medium"]["value"],
        purpose: jsonContract["bindings"][0]['Purpose']['value'],
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
    if(dateString.length > 12) {
      var length = dateString.length;
      int year = int.parse(dateString.substring(length - 4, length));
      int month = int.parse(dateString.substring(length - 7, length - 5));
      int day = int.parse(dateString.substring(length - 10, length - 8));
      DateTime date = new DateTime(year, month, day);

      return date;
    } else {
      int year = int.parse(dateString.substring(0, 4));
      int month = int.parse(dateString.substring(5, 7));
      int day = int.parse(dateString.substring(8, 10));
      DateTime date = new DateTime(year, month, day);

      return date;
    }

  }
}
