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
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwiZXhwIjoxNjQwNDI3Mzc4fQ.aD7XNfGsCqgzshdiwcqWEc2srtd56TlNCtAm0o-fFLI";

  var headers = {
    'accept': '*/*',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  //TODO: change dynamic model to the contract model.
  dynamic model;

  createContract(String title, String contractTerms, String contractType,
      DateTime startDate, DateTime expireDate, String requester, String provider) async {

    var bodies = new Map<String, String>();
    bodies["ContractId"] = title;
    bodies["ContractType"] = contractType;
    bodies["Purpose"] = contractTerms;
    bodies["ContractRequester"] = requester;
    bodies["ContractProvider"] = provider;
    bodies["DataController"] = "Same as ContractRequester: $requester";
    bodies["StartDate"] = "2021-08-02";
    bodies["ExecutionDate"] = "2021-08-02";
    bodies["EffectiveDate"] = "2021-08-02";
    bodies["ExpireDate"] = "2021-08-02";
    bodies["Medium"] = "SmashHit Flutter Application";
    bodies["Waiver"] = "string";
    bodies["Amendment"] = "string";
    bodies["ConfidentialityObligation"] = "string";
    bodies["DataProtection"] = "string";
    bodies["LimitationOnUse"] = "string";
    bodies["MethodOfNotice"] = "string";
    bodies["NoThirdPartyBeneficiaries"] = "string";
    bodies["PermittedDisclosure"] = "string";
    bodies["ReceiptOfNotice"] = "string";
    bodies["Severability"] = "string";
    bodies["TerminationForInsolvency"] = "string";
    bodies["TerminationForMaterialBreach"] = "string";
    bodies["TerminationOnNotice"] = "string";
    bodies["ContractStatus"] = "string";

    var body = {
      "ContractId": title.replaceAll(' ', ''),
      "ContractType": contractType,
      "Purpose": contractTerms,
      "ContractRequester": requester.replaceAll(' ', ''),
      "ContractProvider": provider.replaceAll(' ', ''),
      "DataController": requester.replaceAll(' ', ''),
      "StartDate": "",
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
    var body2 = jsonEncode(body);

    final response = await http.post(kBaseUrl.replace(path: "/contract/create/"),
        headers: headers, body: body2);

    if (response.statusCode == 200) {
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
