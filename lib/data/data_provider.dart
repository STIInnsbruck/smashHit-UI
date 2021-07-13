import 'dart:async';
import 'dart:convert';
import 'dart:io';
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

  static final String token = "asd";

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

  createContract() async {
    var response = await http.post(kBaseUrl.replace(path: "/contract/create/"));
  }

  acceptContract(Uri path) async {}

  rejectContract(Uri path) async {}

  getContractById(int contractId) async {

    Map<String, String> queryParams = {
      'id': contractId.toString()
    };

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await http.get(
        kBaseUrl.replace(path: "/contract/by_contractId/", queryParameters: queryParams),
        headers: headers);

    if(response.statusCode == 201) {
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

    var response = await http.get(kBaseUrl.replace(path: "/contract/list_of_contracts/"), headers: headers);

    if(response.statusCode == 200) {
      var data = (response.body);
      print("$data");
    } else {
      print("Error getContracts()");
      print("${response.statusCode}");
    }

  }


/**
 * Example request with token in it
 *  String token = await Candidate().getToken();
    final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
    });
    print('Token : ${token}');
    print(response);
 */
}
