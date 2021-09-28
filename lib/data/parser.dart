import 'package:smashhit_ui/data/models.dart';

class ResponseParser {
  Contract parseContract(Map jsonContract) {
    return Contract(contractId: jsonContract['Contract']['value']);
  }

  Contract parseContractId(Map jsonContract) {
    return new Contract(
        contractId: jsonContract["bindings"][0]['Contract']['value'],
        contractType: jsonContract["bindings"][0]['ContractType']['value'],
        contractor: jsonContract["bindings"][0]['ContractRequester']['value'],
        contractee: jsonContract["bindings"][0]['ContractProvider']['value'],
        title: "Contract Title (Hardcoded, not in ontology.)",
        description: jsonContract["bindings"][0]['Purpose']['value'],
        executionDate: formatDate(jsonContract["bindings"][0]["ExecutionDate"]["value"]),
        expireDate: formatDate(jsonContract["bindings"][0]["EndingDate"]["value"]),
        contractStatus: jsonContract["bindings"][0]['ContractStatus']['value']
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
