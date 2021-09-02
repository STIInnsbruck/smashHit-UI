import 'package:smashhit_ui/data/models.dart';

class ResponseParser {
  /**Contract parseContract(Map jsonEvent) {
    return Contract(null, null, null, null, null, null);
  }

  Contract? parseContractId(Map jsonEvent) {
    return new Contract(
      jsonEvent["Contract"]["value"],
      jsonEvent["ContractType"]["value"],
      jsonEvent["ContractProvider"]["value"],
      jsonEvent["ContractRequester"]["value"],
      formatDate(jsonEvent["ExecutionDate"]["value"]),
      formatDate(jsonEvent["EndingDate"]["value"])
    );jsonEvent.toString();
  }

  List<Contract?> parseAllContractIds(List jsonList) {
    return jsonList.map((jsonContractIds) => parseContractId(jsonContractIds)).toList();
  }*/

  DateTime formatDate(String dateString) {
    var length = dateString.length;
    int year = int.parse(dateString.substring(length - 4, length));
    int month = int.parse(dateString.substring(length - 7, length - 5));
    int day = int.parse(dateString.substring(length - 10, length - 8));
    DateTime date = new DateTime(year, month, day);

    return date;
  }
}
