import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:smashhit_ui/data/parser.dart';
import 'package:smashhit_ui/data/models.dart';

class DataProvider {

  ResponseParser parser = ResponseParser();

  //TODO: change dynamic model to the contract model.
  dynamic model;


  //----------------------ACT CONTRACT API--------------------------------------

  static final String kHost = 'actool.contract.sti2.at';
  static final String kBasePath = '/';
  Uri kBaseUrl = new Uri.https(kHost, kBasePath);

  static final String token =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwiZXhwIjoxNjQwNDI3Mzc4fQ.aD7XNfGsCqgzshdiwcqWEc2srtd56TlNCtAm0o-fFLI";

  var headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  Future<bool> createAgent(String name, String agentId, String address, String city,
      String country, String state, String phone, String agentType, String email) async {

    var body = {
      "Address": "16, Fuerstenweg",
      "AgentId": "SvenR",
      "AgentType": "Person",
      "City": "Innsbruck",
      "Country": "Austria",
      "Email": "sven@home.lu",
      "Name": "Sven",
      "Phone": "69187542169",
      "State": "Tyrol"
    };

    var jsonBody = jsonEncode(body);

    final response = await http.post(kBaseUrl.replace(path: "/agent/create/"),
        headers: headers, body: jsonBody);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print("Message: \t $data");
      return true;
    } else {
      print("Statuscode: ${response.statusCode}");
      print("Response body: ${response.body}");
      return false;
    }
  }

  Future<bool> createContract(String title, String contractTerms, String contractType,
      DateTime startDate, DateTime expireDate, String requester, String provider) async {

    var body = {
      "ContractId": title.replaceAll(' ', ''),
      "ContractType": contractType,
      "Purpose": contractTerms.replaceAll('\n', ''),
      "ContractRequester": requester.replaceAll(' ', ''),
      "ContractProvider": provider.replaceAll(' ', ''),
      "DataController": requester.replaceAll(' ', ''),
      "StartDate": _formatDate(startDate),
      "ExecutionDate": _formatDate(startDate),
      "EffectiveDate": _formatDate(startDate),
      "ExpireDate": _formatDate(expireDate),
      "Medium": "SmashHit Flutter Application",
      "Waiver": "string",
      "Amendment": "string",
      "ConfidentialityObligation": "string",
      "DataProtection": "string",
      "LimitationOnUse": "string",
      "MethodOfNotice": "string",
      "NoThirdPartyBeneficiaries": "string",
      "PermittedDisclosure": "string",
      "ReceiptOfNotice": "string",
      "Severability": "string",
      "TerminationForInsolvency": "string",
      "TerminationForMaterialBreach": "string",
      "TerminationOnNotice": "string",
      "ContractStatus": "string"
    };

    var jsonBody = jsonEncode(body);

    final response = await http.post(kBaseUrl.replace(path: "/contract/create/"),
        headers: headers, body: jsonBody);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print("Data: \t $data");
      print("Contract Created.");
      return true;
    } else {
      print("Error createContract()");
      print("${response.statusCode}");
      print("${response.body}");
      return false;
    }
  }

  acceptContract(Uri path) async {}

  rejectContract(Uri path) async {}

  Future<Contract> fetchContractById(String contractId) async {
    final response = await http.get(kBaseUrl.replace(path: '/contract/by_contractId/$contractId/'), headers: headers);

    if (response.statusCode == 200) {
      Contract contract;
      try {
        contract = parser.parseContractId(jsonDecode(response.body));
        return contract;
      } catch (e) {
        throw Exception('Failed to load contract.');
      }
      return parser.parseContractId(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load contract.');
    }
  }

  Future<List<Contract>> fetchAllContracts() async {
    final response = await http.get(kBaseUrl.replace(path: '/contract/list_of_contracts/'), headers: headers);

    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      return parser.parseAllContracts(data["bindings"]);
    } else {
      throw Exception('Failed to load all contracts.');
    }
  }

  Future<List<User>> fetchAllUsers() async {
    final response = await http.get(kBaseUrl.replace(path: 'contract/agents/'), headers: headers);

    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      return parser.parseAllUsers(data["bindings"]);
    } else {
      throw Exception('Failed to load all users.');
    }
  }

  Future<User> fetchUserById(String agentId) async {
    final response = await http.get(kBaseUrl.replace(path: 'agent/by_agentId/SvenRasmusen'), headers: headers);

    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      return parser.parseUser(data["bindings"]);
    } else {
      throw Exception('Failed to load agent by id: $agentId.');
    }
  }

  Future<bool> deleteContractById(String contractId) async {
    final response = await http.delete(kBaseUrl.replace(path: '/contract/delete/$contractId/'), headers: headers);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete contract $contractId.\nBack-end response: ${response.reasonPhrase}.');
    }
  }

  updateContract(String title, String contractTerms, String contractType,
      DateTime startDate, DateTime expireDate, String requester, String provider) async {

    var body = {
      "ContractId": title.replaceAll(' ', ''),
      "ContractType": contractType,
      "Purpose": contractTerms.replaceAll('\n', ''),
      "ContractRequester": requester.replaceAll(' ', ''),
      "ContractProvider": provider.replaceAll(' ', ''),
      "DataController": requester.replaceAll(' ', ''),
      "StartDate": _formatDate(startDate),
      "ExecutionDate": _formatDate(startDate),
      "EffectiveDate": _formatDate(startDate),
      "ExpireDate": _formatDate(expireDate),
      "Medium": "SmashHit Flutter Application",
      "Waiver": "string",
      "Amendment": "string",
      "ConfidentialityObligation": "string",
      "DataProtection": "string",
      "LimitationOnUse": "string",
      "MethodOfNotice": "string",
      "NoThirdPartyBeneficiaries": "string",
      "PermittedDisclosure": "string",
      "ReceiptOfNotice": "string",
      "Severability": "string",
      "TerminationForInsolvency": "string",
      "TerminationForMaterialBreach": "string",
      "TerminationOnNotice": "string",
      "ContractStatus": "string"
    };

    var jsonBody = jsonEncode(body);

    final response = await http.post(kBaseUrl.replace(path: "/contract/update/"),
        headers: headers, body: jsonBody);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print("Contract Updated.");
      return true;
    } else {
      print("Error createContract()");
      print("${response.statusCode}");
      print("${response.body}");
      return false;
    }
  }

  ///Standard function to format the date to send a correctly structured date.
  String _formatDate(DateTime? date) {
    String dateString = "${date!.year}-${date.month}-${date.day}";
    return dateString;
  }

  /// Check for internet connection. Either wifi or mobile.
  Future<bool> ensureInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

}

