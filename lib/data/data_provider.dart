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
  static final String kBasePath = '/contract/list_of_contracts/';
  Uri kBaseUrl = new Uri.https(kHost, kBasePath);

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

  postContract(Uri path) async {}

  acceptContract(Uri path) async {}

  rejectContract(Uri path) async {}

  getContracts() async {
    var response = await http.get(kBaseUrl);

    if(response.statusCode == 200) {
      var data = json.decode(response.body);
      print("Data: \t $data");
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
