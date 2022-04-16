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
  };

  //---------------------------- CONTRACTORS -----------------------------------
  Future<int> createAgent(String name, String address, String city,
      String country, String phone, String role, String email) async {

    var body = {
      "Address": address,
      "Country": country,
      "Email": email,
      "Name": name,
      "Phone": phone,
      "Role": role,
      "Territory": city
    };

    var jsonBody = jsonEncode(body);

    final response = await http.post(kBaseUrl.replace(path: "/contractor/create/"),
        headers: headers, body: jsonBody);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print("Message: \t $data");
      if(data.toString().compareTo('{Error: Contractor id already exist}') == 0 ) {
        return -1;
      } else if (data.toString().compareTo('{Success: Record inserted successfully.}') == 0 ){
        return 1;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  Future<List<User>> fetchAllUsers() async {
    final response = await http.get(kBaseUrl.replace(path: 'contractors/'), headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return parser.parseAllUsers(data);
    } else {
      throw Exception('Failed to load all users.');
    }
  }

  Future<User> fetchUserById(String contractorId) async {
    final response = await http.get(kBaseUrl.replace(path: '/contractor/$contractorId/'), headers: headers);

    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      try {
        return parser.parseUserById(jsonDecode(response.body));
      }catch (e) {
        throw Exception('Failed to fetch agent by id: $contractorId.');
      }

    } else {
      throw Exception('Failed to load agent by id: $contractorId.');
    }
  }

  Future<bool> deleteUserById(String agentId) async {
    final response = await http.delete(kBaseUrl.replace(path: '/agent/delete/$agentId/'), headers: headers);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete account $agentId.\nBack-end response: ${response.reasonPhrase}.');
    }
  }

  //---------------------------- Contract --------------------------------------
  Future<List<Contract>> fetchAllContracts() async {
    final response = await http.get(kBaseUrl.replace(path: '/contract/list_of_contracts/'), headers: headers);

    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      return parser.parseAllContracts(data["bindings"]);
    } else {
      throw Exception('Failed to load all contracts.');
    }
  }

  Future<bool> createContract(Contract contract) async {

    var body = {
      "ContractId": contract.contractId!.replaceAll(' ', ''),
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

  Future<bool> createBaseContract(Contract contract) async {
    var body = {
      "ConsentId": "string",
      "ConsiderationDescription": contract.considerationDescription,
      "ConsiderationValue": contract.considerationValue,
      "ContractCategory": contract.contractCategory,
      "ContractStatus": "hasCreated",
      "ContractType": "Written",
      "Contractors": [
        contract.contractors[0]
      ],
      "EffectiveDate": _formatDate(contract.effectiveDate),
      "EndDate": _formatDate(contract.endDate),
      "ExecutionDate": _formatDate(contract.executionDate),
      "Medium": "App Based",
      "Obligations": [
        "string"
      ],
      "Purpose": contract.purpose,
      "Signatures": [
        "string"
      ],
      "Terms": [
        "string"
      ]
    };

    var jsonBody = jsonEncode(body);

    final response = await http.post(kBaseUrl.replace(path: "/contract/create/"),
        headers: headers, body: jsonBody);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data.toString().compareTo('{"Success": "Record inserted successfully."}') == 0 ) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<String> fetchContractIdByContractorId(String contractorId) async {
    final response = await http.get(kBaseUrl.replace(path: '/contract/byContractor/$contractorId/'), headers: headers);

    if (response.statusCode == 200) {
      return parser.parseFetchContractId(jsonDecode(response.body));
    } else {
      throw Exception('Failed to find contract id.');
    }
  }

  Future<Contract> fetchContractById(String contractId) async {
    final response = await http.get(kBaseUrl.replace(path: '/contract/byContract/$contractId/'), headers: headers);

    if (response.statusCode == 200) {
      Contract contract;
      try {
        contract = parser.parseContractId(jsonDecode(response.body));
        return contract;
      } catch (e) {
        throw Exception('Failed to load contract.');
      }
    } else {
      throw Exception('Failed to load contract.');
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

  Future<List<Contract>> fetchContractsByContractorId(String contractorId) async {
    final response = await http.get(kBaseUrl.replace(path: '/contract/byContractor/$contractorId/'), headers: headers);

    if (response.statusCode == 200) {
      List<Contract> contracts = [];
      try {
        contracts = parser.parseAllContracts(jsonDecode(response.body));
        return contracts;
      } catch (e) {
        return contracts;
      }
    } else {
      throw Exception('Failed to load all contracts.');
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
      print("Contract Updated.");
      return true;
    } else {
      print("Error createContract()");
      print("${response.statusCode}");
      print("${response.body}");
      return false;
    }
  }

  //---------------------------- Obligation ------------------------------------
  Future<Obligation> fetchObligationById(String obligationId) async {
    final response = await http.get(kBaseUrl.replace(path: '/obligation/$obligationId/'), headers: headers);

    if (response.statusCode == 200) {
      Obligation obligation;
      try {
        obligation = parser.parseObligationId(jsonDecode(response.body)[0]);
        return obligation;
      } catch (e) {
        throw Exception('Failed to load obligation $obligationId.');
      }
    } else {
      throw Exception('Failed to load obligation $obligationId.');
    }
  }

  //---------------------------- Term ------------------------------------------
  Future<Term> fetchTermById(String termId) async {
    final response = await http.get(kBaseUrl.replace(path: '/contract/term/$termId/'), headers: headers);

    if (response.statusCode == 200) {
      Term term;
      try {
        term = parser.parseTermId(jsonDecode(response.body));
        return term;
      } catch (e) {
        throw Exception('Failed to parse response for term $termId.');
      }
    } else {
      throw Exception('Failed to load term $termId.');
    }
  }

  Future<TermType> fetchTermTypeById(String termTypeId) async {
    final response = await http.get(kBaseUrl.replace(path: '/termType/$termTypeId/'), headers: headers);

    if (response.statusCode == 200) {
      TermType termType;
      try {
        termType = parser.parseTermTypeId(jsonDecode(response.body));
        return termType;
      } catch (e) {
        throw Exception('Failed to parse response for termType $termTypeId.');
      }
    } else {
      throw Exception('Failed to load termType $termTypeId.');
    }
  }

  //---------------------------- Term Type -------------------------------------
  Future<bool> createTermType(TermType termType) async {
    var body = {
      "Description": termType.description,
      "Name": termType.name
    };
    var jsonBody = jsonEncode(body);
    final response = await http.post(kBaseUrl.replace(path: "/term/type/create/"),
        headers: headers, body: jsonBody);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data.toString().compareTo('{"Success": "Record inserted successfully."}') == 0 ) {
        return true;
      } else {
        return false;
      }
    } else {
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

