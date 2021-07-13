import 'package:smashhit_ui/data/models.dart';
import 'dart:io';

class ResponseParser {

  List<Contract> parseAllContract(List jsonList) {
    return jsonList.map((jsonEvent) => parseEvent(jsonEvent)).toList();
  }

  Contract parseContract(Map jsonEvent) {
    return Contract(
      title: jsonEvent['title'],
      description: jsonEvent['description'],
      date: jsonEvent['date'],
      time: jsonEvent['time'],
      participants: jsonEvent['participants'],
      creator: jsonEvent['creator'],
    );
  }

  User parseUser(Map jsonUser) {
    return new User(
      jsonUser['id'],
      jsonUser['username'],
      jsonUser['password'],
      jsonUser['isOrganizer'],
      jsonUser['email'],
      jsonUser['img'],
    );
  }
}