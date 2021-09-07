import 'package:smashhit_ui/data/models.dart';

class ResponseParser {
  Contract parseContract(Map jsonContract) {
    return Contract(contractId: jsonContract["bindings"][0]['Contract']['value']);
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
        contractStatus: "Created"
    );
  }

  List<Contract> parseAllContractIds(List jsonList) {
    return jsonList.map((jsonContractIds) => parseContractId(jsonContractIds)).toList();
  }

  DateTime formatDate(String dateString) {
    var length = dateString.length;
    int year = int.parse(dateString.substring(length - 4, length));
    int month = int.parse(dateString.substring(length - 7, length - 5));
    int day = int.parse(dateString.substring(length - 10, length - 8));
    DateTime date = new DateTime(year, month, day);

    return date;
  }
}
