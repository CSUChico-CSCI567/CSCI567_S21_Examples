import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CounterStorage {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }


  Future<bool> writeCounter(int counter) async{
    try {
      final file = await _localFile;
      await file.writeAsString('$counter');
      return true;
    } catch (e) {
      // If encountering an error, return 0
      print(e);
      return false;
    }
  }

  Future<int> readCounter() async{
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      print(e);
      return 0;
    }
  }
}