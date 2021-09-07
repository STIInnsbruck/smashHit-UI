import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:smashhit_ui/data/parser.dart';
import 'package:smashhit_ui/data/models.dart';

class DataProvider {

  //TODO: change URL to the contract url. This is currently only used to ensure correct https requests.
  static final String testUrl = "rickandmortyapi.com";
  static final String testPath = "/";
  Uri kTestUrl = new Uri.https(testUrl, testPath);

  static final String kHost = 'actool.contract.sti2.at';
  static final String kBasePath = '/';
  Uri kBaseUrl = new Uri.https(kHost, kBasePath);

  ResponseParser parser = ResponseParser();

  static final String token =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwiZXhwIjoxNjMxMDA4ODc0fQ.6EEyI0qOXbEbWlQEMFztD2TsTQ7veoscv6Sj41VVVtc";

  var headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  };

  //TODO: change dynamic model to the contract model.
  dynamic model;

  createContract(String title, String contractTerms, String contractType,
      DateTime startDate, DateTime expireDate) async {
    var headers = {
      //'Content-Type': 'application/json',
      //'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var body = {
      "ContractId": "1337",
      "ContractType": contractType,
      "Purpose": "Testing the flutter application.",
      "ContractRequester": "string",
      "ContractProvider": "string",
      "DataController": "string",
      "StartDate": _formatDate(startDate),
      "ExecutionDate": _formatDate(startDate),
      "EffectiveDate": _formatDate(startDate),
      "ExpireDate": _formatDate(expireDate),
      "Medium": "SmashHitFlutterApp",
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

    var response = await http.post(kBaseUrl.replace(path: "/contract/create/"),
        headers: headers, body: jsonBody);

    if (response.statusCode == 201) {
      var data = json.decode(response.body);
      print("Data: \t $data");
      print("Contract Created.");
    } else {
      print("Error createContract()");
      print("${response.statusCode}");
      print("${response.body}");
    }
  }

  acceptContract(Uri path) async {}

  rejectContract(Uri path) async {}

  Future<Contract> fetchContractById() async {
    String id = "kg244565";

    final response = await http.get(kBaseUrl.replace(path: '/contract/by_contractId/$id'), headers: headers);

    if (response.statusCode == 200) {
      return Contract.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load contract.');
    }
  }



  /**getContracts() async {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await http.get(
        kBaseUrl.replace(path: "/contract/list_of_contracts/"),
        headers: headers);

    if (response.statusCode == 200) {
      var data = (response.body);
      var jsonMap = json.decode(data);
      var id = parser.parseAllContractIds(jsonMap["bindings"]);
      print("id: $id");
      return id;
    } else {
      print("Error getContracts()");
      print("${response.statusCode}");
    }
  }*/

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
