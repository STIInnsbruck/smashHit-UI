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
    return new Contract(
        contractId: jsonContract["bindings"][0]['Contract']['value'],
        contractType: jsonContract["bindings"][0]['ContractType']['value'],
        //contractorId: jsonContract["bindings"][0]['ContractRequester']['value'],
        //contracteeId: jsonContract["bindings"][0]['ContractProvider']['value'],
        title: "Contract Title (Hardcoded, not in ontology.)",
        purpose: jsonContract["bindings"][0]['Purpose']['value'],
        executionDate: formatDate(jsonContract["bindings"][0]["ExecutionDate"]["value"]),
        //expireDate: formatDate(jsonContract["bindings"][0]["EndingDate"]["value"]),
        contractStatus: jsonContract["bindings"][0]['ContractStatus']['value'],
        //amendment: jsonContract["bindings"][0]['Amendment']['value'],
        //confidentialityObligation: jsonContract["bindings"][0]['ConfidentialityObligation']['value'],
        //existDataController: jsonContract["bindings"][0]['DataController']['value'],
        //existDataProtection: jsonContract["bindings"][0]['DataProtection']['value'],
        //limitation: jsonContract["bindings"][0]['LimitationOnUse']['value'],
        //methodNotice: jsonContract["bindings"][0]['MethodOfNotice']['value'],
        //thirdParties: jsonContract["bindings"][0]['NoThirdPartyBeneficiaries']['value'],
        //disclosure: jsonContract["bindings"][0]['PermittedDisclosure']['value'],
        //receiptNotice: jsonContract["bindings"][0]['ReceiptOfNotice']['value'],
        //severability: jsonContract["bindings"][0]['Severability']['value'],
        //terminationInsolvency: jsonContract["bindings"][0]['TerminationForInsolvency']['value'],
        //terminationMaterialBreach: jsonContract["bindings"][0]['TerminationForMaterialBreach']['value'],
        //terminationNotice: jsonContract["bindings"][0]['TerminationOnNotice']['value'],
        //waiver: jsonContract["bindings"][0]['Waiver']['value']
    );
  }

  List<Contract> parseAllContracts(List jsonList) {
    return jsonList.map((jsonContract) => parseContract(jsonContract)).toList();
  }

  DateTime formatDate(String dateString) {
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
