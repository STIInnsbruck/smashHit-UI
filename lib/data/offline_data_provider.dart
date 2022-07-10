import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:smashhit_ui/data/parser.dart';
import 'package:smashhit_ui/data/models.dart';

class OfflineDataProvider {
  ResponseParser parser = ResponseParser();

  //Find document storages path
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

}

