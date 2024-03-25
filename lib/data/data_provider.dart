import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:smashhit_ui/data/parser.dart';
import 'package:smashhit_ui/data/models.dart';
import 'dart:developer';
class DataProvider {
  ResponseParser parser = ResponseParser();
  //----------------------ACT CONTRACT API DETAILS------------------------------
  static final String kHost = 'actool.contract.sti2.at';
  static final String kBasePath = '/';
  String? token='';
  Uri kBaseUrl = new Uri.https(kHost, kBasePath);
 
  
   Future<User> loginUser(String name, String password) async {
    // var body = {
    //   "Name": name,
    //   "Password": password
    // };
    // var jsonBody = jsonEncode(body);

    // final response = await http.post(kBaseUrl.replace(path: '/contract/login/'),  headers:await make_header("apiendpoint"), body: jsonBody);


    // if (response.statusCode == 200) {
    //   try {
    //     token  = parser.parseNewUser(jsonDecode(response.body)).token;
   var a = make_header("userlogin");
    log("resposnse--$a");
      
        return parser.parseNewUser(make_header("userlogin"));
    //   }catch (e) {
    //     throw Exception('Failed to load token.');
    //   }

    // } else {
    //   throw Exception('Failed to fetch token');
    // }
  }

make_header(fromUser) async {
  String? token;  
  String name = "Jonas";
  String password = "Jonas123";
  var usercredential = {
      "Name": "Jonas",
      "Password": "Jonas123"
    };
  var jsonBody = jsonEncode(usercredential);
  var contenttype = {'Content-Type': 'application/json'};

  final responses = await http.post(kBaseUrl.replace(path: '/contract/login/'), headers: contenttype, body: jsonBody);

  if (responses.statusCode == 200 && fromUser=="apiendpoint") {
      try {
        token  = parser.parseNewUser(jsonDecode(responses.body)).token;
        log("Token from server: $token");

        var headers = {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      print("header gen from code: $headers");
    //var otype = headeroriginal.runtimeType;

      
        return headers;
      }catch (e) {
        throw Exception('Failed to load token. $e');
      }

    }
     if  (responses.statusCode == 200 && fromUser=="userlogin") {
      var res = jsonDecode(responses.body);
       log("Success==$res");
       return res;
    }
    
    //  else {
    //   var a = responses.statusCode;
    //   throw Exception('Failed to fetch token 2----$a ');
    // }

 
  
  }
//log(make_header("apiendpoint"));
//make_header("apiendpoint"); 
/*
   final response = await http.post(kBaseUrl.replace(path: "/contract/login/"),


}

def make_header("apiendpoint"){
  token=login_user();
   var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    return header;
  

}
*/
  //---------------------------- CONTRACTORS -----------------------------------

  Future<User> createAgent(User user) async {


    var body = {
      "Address": user.streetAddress,
      "CompanyId": user.companyId,
      "Country": user.country,
      "CreateDate": user.createDate!.toIso8601String(),
      "Email": user.email,
      "Name": user.name,
      "Phone": user.phone,
      "Role": user.role,
      "Territory": user.city,
      "Vat": user.vat
    };

    var jsonBody = jsonEncode(body);

    final response = await http.post(kBaseUrl.replace(path: "/contract/contractor/create/"),
         headers:await make_header("apiendpoint"), body: jsonBody);

    if (response.statusCode == 200) {

      try {
        return parser.parseUserRegister(jsonDecode(response.body));
      } catch (e) {
        throw Exception('Failed to parse create user\nError Message: User response JSON is different than expected.');
      }
    } else {
      throw Exception('Error on creating user on server.\nError Message: ${response.body}');
    }
  }

  Future<List<User>> fetchAllUsers() async {
    final response = await http.get(kBaseUrl.replace(path: '/contract/contractors/'),  headers:await make_header("apiendpoint"));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return parser.parseAllUsers(data);
    } else {
      throw Exception('Failed to load all users.');
    }
  }

  Future<User> fetchUserById(String contractorId) async {
    
    final response = await http.get(kBaseUrl.replace(path: '/contract/contractor/$contractorId/'), headers:await make_header("apiendpoint") );
 

    if (response.statusCode == 200) {
      try {
        return parser.parseUserById(jsonDecode(response.body));
      }catch (e) {
        throw Exception('Failed to fetch user by id: $contractorId.');
      }

    } else {
      throw Exception('Failed to load user by id: $contractorId.');
    }
  }

  /*Future<User> loginUser(String name, String password) async {
    var body = {
      "Name": name,
      "Password": password
    };
    var jsonBody = jsonEncode(body);

    final response = await http.post(kBaseUrl.replace(path: '/contract/login/'), headers: headers, body: jsonBody);

    if (response.statusCode == 200) {
      try {
        token  = parser.parseNewUser(jsonDecode(response.body)).token;
      headers['Authorization'] = 'Bearer $token';
        log('token $token');
        return parser.parseNewUser(jsonDecode(response.body));
      }catch (e) {
        throw Exception('Failed to load user.');
      }

    } else {
      throw Exception('Failed to fetch user.');
    }
  }
*/
  Future<bool> register(String name, String email, String password) async {
    var body = {
      "Name": name,
      "Email": email,
      "Password": password
    };
    var jsonBody = jsonEncode(body);

    final response = await http.post(kBaseUrl.replace(path: '/contract/register/'),  headers:await make_header("apiendpoint"), body: jsonBody);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      try {
        if (data.toString().compareTo('{Success: Record added successfully.}') == 0) {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        throw Exception('Failed to load user.');
      }

    } else {
      throw Exception('Failed to fetch user.');
    }
  }

  Future<int> updateUser(User user) async {
    var body = {
      "Address": user.streetAddress,
      "CompanyId": user.companyId,
      "ContractorId": user.id,
      "Country": user.country,
      "CreateDate": user.createDate!.toIso8601String(),
      "Email": user.email,
      "Name": user.name,
      "Phone": user.phone,
      "Role": user.role,
      "Territory": user.city,
      "Vat": user.vat
    };

    var jsonBody = jsonEncode(body);

    final response = await http.put(kBaseUrl.replace(path: "/contract/contractor/update/"),
         headers:await make_header("apiendpoint"), body: jsonBody);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print("Message: \t $data");
      if(data.toString().compareTo('{"Success": "No record found for this ID"}') == 0 ) {
        return -1;
      } else if (data.toString().compareTo('{"Success": "Record updated successfully"}') == 0 ){
        return 1;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  Future<bool> deleteUserById(String contractorId) async {
    final response = await http.delete(kBaseUrl.replace(path: '/contract/contractor/delete/$contractorId/'),  headers:await make_header("apiendpoint"));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete account $contractorId.\nBack-end response: ${response.reasonPhrase}.');
    }
  }

  //---------------------------- Contract --------------------------------------
  Future<List<Contract>> fetchAllContracts() async {
    final response = await http.get(kBaseUrl.replace(path: '/contract/list_of_contracts/'),  headers:await make_header("apiendpoint"));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return parser.parseAllContracts(data);
    } else {
      throw Exception('Failed to load all contracts.');
    }
  }

  Future<bool> createContract(Contract contract) async {

    var body = {
      "ContractId": contract.id!.replaceAll(' ', ''),
      "ContractStatus": "string"
    };

    var jsonBody = jsonEncode(body);

    final response = await http.post(kBaseUrl.replace(path: "/contract/create/"),
         headers:await make_header("apiendpoint"), body: jsonBody);

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

  Future<String> createBaseContract(Contract contract) async {
    var body = {
      "ConsentId": "string",
      "ConsiderationDescription": contract.consideration,
      "ConsiderationValue": contract.value,
      "ContractCategory": contract.category,
      "ContractStatus": contract.status,
      "ContractType": contract.type,
      "Contractors": contract.contractors,
      "EffectiveDate": contract.effectiveDate!.toIso8601String(),
      "EndDate":contract.endDate!.toIso8601String(),
      "ExecutionDate": contract.executionDate!.toIso8601String(),
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
         headers:await make_header("apiendpoint"), body: jsonBody);

    if (response.statusCode == 200) {
      Contract contract;
      try {
        contract = parser.parseContractById(jsonDecode(response.body));
        return contract.id!;
      } catch (e) {
        throw Exception('Failed to load contract.');
      }
    } else {
      return "to return failed creation 2";
    }
  }

  Future<Contract> fetchContractById(String contractId) async {
    final response = await http.get(kBaseUrl.replace(path: '/contract/byContract/$contractId/'),  headers:await make_header("apiendpoint"));

    if (response.statusCode == 200) {
      Contract contract;
      try {
        contract = parser.parseContractById(jsonDecode(response.body));
        return contract;
      } catch (e) {
        throw Exception('Failed to load contract.');
      }
    } else {
      throw Exception('Failed to load contract.');
    }
  }

  Future<bool> deleteContractById(String contractId) async {
    final response = await http.delete(kBaseUrl.replace(path: '/contract/delete/$contractId/'),  headers:await make_header("apiendpoint"));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete contract $contractId.\nBack-end response: ${response.reasonPhrase}.');
    }
  }

  Future<List<Contract>> fetchContractsByContractorId(String contractorId) async {
   

    final response = await http.get(kBaseUrl.replace(path: '/contract/byContractor/$contractorId/'),  headers:await make_header("apiendpoint"));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
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

  Future<int> updateContract(Contract contract) async {
    var body = {
      "ConsentId": "string",
      "ConsiderationDescription": contract.consideration,
      "ConsiderationValue": contract.value,
      "ContractCategory": contract.category,
      "ContractId": contract.id,
      "ContractStatus": contract.status,
      "ContractType": contract.type,
      "Contractors": contract.contractors,
      "EffectiveDate": contract.effectiveDate!.toIso8601String(),
      "EndDate": contract.endDate!.toIso8601String(),
      "ExecutionDate": contract.executionDate!.toIso8601String(),
      "Medium": contract.medium,
      "Obligations": contract.obligations,
      "Purpose": contract.purpose,
      "Signatures": contract.signatures,
      "Terms": contract.terms
    };

    var jsonBody = jsonEncode(body);

    final response = await http.put(kBaseUrl.replace(path: "/contract/update/"), headers:await make_header("apiendpoint"), body: jsonBody);
     

     
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      log("Contract is being updated");
      print("Message: \t $data");
      if(data.toString().compareTo('{"Success": "No record found for this ID"}') == 0 ) {
        return -1;
      } else if (data.toString().compareTo('{"Success": "Record updated successfully"}') == 0 ){
        return 1;
      } else {
        return 0;
      }
    } else {
      var aa = response.statusCode;
     log("Response for update: $aa");
      return 0;
    }
  }

  //---------------------------- Obligation ------------------------------------
  Future<Obligation> fetchObligationById(String obligationId) async {
    final response = await http.get(kBaseUrl.replace(path: '/contract/obligation/$obligationId/'),  headers:await make_header("apiendpoint"));

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

  Future<Obligation> createObligation(Contract contract, Obligation obligation) async {
    var body = {
      "ContractId": contract.id,
      "ContractIdB2C": "string",
      "ContractorId": obligation.contractorId,
      "Description": obligation.description!.replaceAll("\n", ""),
      "EndDate": obligation.endDate!.toIso8601String(),
      "ExecutionDate": obligation.executionDate!.toIso8601String(),
      "State": obligation.state,
      "TermId": obligation.termId
    };
    var jsonBody = jsonEncode(body);
    final response = await http.post(kBaseUrl.replace(path: "/contract/obligation/create/"),
         headers:await make_header("apiendpoint"), body: jsonBody);

    if (response.statusCode == 200) {
      Obligation tmpObligation;
      try {
        tmpObligation = parser.parseAllObligationsId(jsonDecode(response.body))[0];
        return tmpObligation;
      } catch (e) {
        throw Exception('Failed to parse response for obligation.');
      }
    } else {
      throw Exception('Failed to load obligation.');
    }
  }

  Future<bool> updateObligationStatus(Obligation obligation, String newStatus) async {
    final response = await http.get(kBaseUrl.replace(path: '/contract/obligation/status/${obligation.id}/${obligation.contractId}/${obligation.contractorId}/$newStatus/'));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //---------------------------- Term ------------------------------------------
  Future<Term> fetchTermById(String termId) async {
    final response = await http.get(kBaseUrl.replace(path: '/contract/term/$termId/'),  headers:await make_header("apiendpoint"));

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

  Future<Term> createTerm(String contractId, String description, String termTypeId) async {
    var body = {
      "ContractId": contractId,
      "CreateDate": DateTime.now().toIso8601String(),
      "Description": description.replaceAll("\n", ""),
      "TermTypeId": termTypeId
    };
    var jsonBody = jsonEncode(body);
    final response = await http.post(kBaseUrl.replace(path: "/contract/term/create/"),
         headers:await make_header("apiendpoint"), body: jsonBody);

    if (response.statusCode == 200) {
      Term tmpTerm;
      try {
        tmpTerm = parser.parseTermId(jsonDecode(response.body));
        return tmpTerm;
      } catch (e) {
        throw Exception('Failed to parse response for term with termTypeId: $termTypeId.');
      }
    } else {
      throw Exception('Failed to load term with termTypeId: $termTypeId.');
    }
  }

  //---------------------------- Term Type -------------------------------------
  Future<TermType> fetchTermTypeById(String termTypeId) async {
    final response = await http.get(kBaseUrl.replace(path: '/contract/termType/$termTypeId/'),  headers:await make_header("apiendpoint"));

    if (response.statusCode == 200) {
      TermType termType;
      try {
        termType = parser.parseTermType(jsonDecode(response.body));
        return termType;
      } catch (e) {
        throw Exception('Failed to parse response for termType $termTypeId.');
      }
    } else {
      throw Exception('Failed to load termType $termTypeId.');
    }
  }

  Future<List<TermType>> fetchAllTermTypes() async    {
    final response = await http.get(kBaseUrl.replace(path: '/contract/term/types'),  headers:await make_header("apiendpoint"));

    if (response.statusCode == 200) {
      List<TermType> termTypes = [];
      try {
        termTypes = parser.parseAllTermTypes(jsonDecode(response.body));
        return termTypes;
      } catch (e) {
        return termTypes;
      }
    } else {
      throw Exception('Failed to load all term types.');
    }
  }

  Future<bool> deleteTermTypeById(String termTypeId) async {
    final response = await http.delete(kBaseUrl.replace(path: '/contract/term/type/delete/$termTypeId/'),  headers:await make_header("apiendpoint"));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete term type $termTypeId.\nBack-end response: ${response.reasonPhrase}.');
    }
  }

  Future<bool> updateTermType(String termTypeId, String description, String name) async {
    var body = {
      "CreateDate": DateTime.now().toIso8601String(),
      "Description": description,
      "Name": name,
      "TermTypeId": termTypeId
    };

    var jsonBody = jsonEncode(body);

    final response = await http.put(kBaseUrl.replace(path: '/contract/term/type/update/'),  headers:await make_header("apiendpoint"), body: jsonBody);

    if (response.statusCode == 200) {
      try {
        String data = parser.parseSuccessResponse(jsonDecode(response.body));
        return true;
      } catch (e) {
        return false;
      }
    } else {
      throw Exception('Failed to update term type $termTypeId.\nBack-end response: ${response.reasonPhrase}.');
    }
  }

  Future<TermType> createTermType(String termTypeName, String termTypeDesc) async {
    var body = {
      "CreateDate": DateTime.now().toIso8601String(),
      "Description": termTypeDesc,
      "Name": termTypeName
    };
    var jsonBody = jsonEncode(body);
    final response = await http.post(kBaseUrl.replace(path: "/contract/term/type/create/"),
         headers:await make_header("apiendpoint"), body: jsonBody);

    if (response.statusCode == 200) {
      TermType tmpTermType;
      try {
        tmpTermType = parser.parseTermType(jsonDecode(response.body));
        return tmpTermType;
      } catch (e) {
        throw Exception('Failed to parse response for termType $termTypeName.');
      }
    } else {
      throw Exception('Failed to load termType $termTypeName.');
    }
  }

  //------------------------------ Other ---------------------------------------
  Future<Signature> createSignature(Signature signature) async {
    var body = {
      "ContractId": signature.contractId,
      "ContractorId": signature.contractorId,
      "CreateDate": signature.createDate!.toIso8601String().substring(0,10),
      "Signature": signature.signatureText,
    };

    var jsonBody = jsonEncode(body);
    final response = await http.post(kBaseUrl.replace(path: "/contract/signature/create/"),  headers:await make_header("apiendpoint"), body: jsonBody);
    var aa = response.statusCode;
   
    if (response.statusCode == 200) {
      Signature signature;
      try {
        signature = parser.parseSignatureId(jsonDecode(response.body)[0]);
         log("Response for signature---$signature");
        return signature;
      } catch (e) {
        throw Exception('Failed to parse response for signature.');
      }
    } else {
      throw Exception('Failed to create signature.');
    }
  }

  Future<Signature> fetchSignatureById(String signatureId) async {
    final response = await http.get(kBaseUrl.replace(path: '/contract/signature/$signatureId/'),  headers:await make_header("apiendpoint"));

    if (response.statusCode == 200) {
      Signature signature;
      try {
        signature = parser.parseSignatureId(jsonDecode(response.body)[0]);
        return signature;
      } catch (e) {
        throw Exception('Failed to parse response for signature $signatureId.');
      }
    } else {
      throw Exception('Failed to load signature $signatureId.');
    }
  }

  Future<List<Signature>> fetchAllSignaturesByContractId(String contractId) async    {
    final response = await http.get(kBaseUrl.replace(path: '/contract/signatures/$contractId'),  headers:await make_header("apiendpoint"));

    if (response.statusCode == 200) {
      List<Signature> signatures = [];
      try {
        signatures = parser.parseAllSignaturesByContractId(jsonDecode(response.body));
        return signatures;
      } catch (e) {
        return signatures;
      }
    } else {
      throw Exception('Failed to load all term types.');
    }
  }

  //------------------------------ Other ---------------------------------------
  Future<bool> checkCompliance() async {
    final response = await http.get(kBaseUrl.replace(path: '/contract/compliance/'), headers:make_header("apiendpoint"));

    if (response.statusCode == 200) {
      String data = json.decode(response.body);
      return (data.compareTo("Success") == 0);
    } else {
      throw Exception('Failed to initiate compliance checking.\nBack-end response: ${response.reasonPhrase}.');
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

