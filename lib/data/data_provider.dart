import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

class DataProvider {
  //TODO: change URL to the contract url. This is currently only used to ensure correct https requests.
  static final String testUrl = "rickandmortyapi.com";
  static final String testPath = "/";
  Uri kTestUrl = new Uri.https(testUrl, testPath);

  static final String kHost = 'actool.contract.sti2.at';
  static final String kBasePath = '/';
  Uri kBaseUrl = new Uri.https(kHost, kBasePath);

  static final String token =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwiZXhwIjoxNjI3OTA0NzQ3fQ.RI5YZQm4wSXHFueL-Aqu0gNQmuR_ermV8d7UUWdSAuw";

  //TODO: change dynamic model to the contract model.
  dynamic model;

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

  createContract(String title, String contractTerms, String contractType,
      DateTime startDate, DateTime expireDate) async {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var body = {
      "ContractId": "",
      "ContractType": contractType,
      "Purpose": "string",
      "ContractRequester": "string",
      "ContractProvider": "string",
      "DataController": "string",
      "StartDate": _formatDate(startDate),
      "ExecutionDate": _formatDate(startDate),
      "EffectiveDate": _formatDate(startDate),
      "ExpireDate": _formatDate(expireDate),
      "Medium": "string",
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

  getContractById() async {
    String id = "kg244564";
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await http.get(
        kBaseUrl.replace(path: "/contract/by_contractId/$id"),
        headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print("Data: \t $data");
      print("Contract Created.");
    } else {
      print("Error getContractsById()");
      print("${response.statusCode}");
    }
  }

  getContracts() async {
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
      print("$data");
    } else {
      print("Error getContracts()");
      print("${response.statusCode}");
    }
  }

  ///Standard function to format the date to send a correctly structured date.
  String _formatDate(DateTime? date) {
    String dateString = "${date!.year}-${date.month}-${date.day}";
    return dateString;
  }

  ///With query params examples. I do not want to lose them in case they are
  ///needed in the future.
//getContractById() async {
//     Map<String, String> queryParams = {'id': 'kg244565'};
//     var headers = {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token'
//     };
//     var response = await http.get(
//         kBaseUrl.replace(
//             path: "/contract/by_contractId/", queryParameters: queryParams),
//         headers: headers);
//
//     if (response.statusCode == 200) {
//       var data = json.decode(response.body);
//       print("Data: \t $data");
//       print("Contract Created.");
//     } else {
//       print("Error getContractsById()");
//       print("${response.statusCode}");
//       print("${response.body}");
//     }
//   }
}
