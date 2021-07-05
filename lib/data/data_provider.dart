import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:http/retry.dart';

class DataProvider {
  //TODO: change URL to the contract url. This is currently only used to ensure correct https requests.
  final String URL = "https://rickandmortyapi.com/api/character/";
  //TODO: change dynamic model to the contract model.
  dynamic model;

  /// Check for internet connection. Either wifi or mobile.
  ensureInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

  fetchData(Uri path) async {
    var response = await http.get(path);

    if(response.statusCode == 200) {
      var data = json.decode(response.body)['results'];
      return data;
    } else {
      throw "Unable to retrieve data.";
    }
  }

  postContract(Uri path) async { }

  acceptContract(Uri path) async { }

  rejectContract(Uri path) async { }

  getContracts(Uri path) async { }

  
}