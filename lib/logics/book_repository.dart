import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:sqflite/sqflite.dart';

class BookRepository {

  static Future<Database> getBibleDatabase()async{
    final dbPath = await getDatabasesPath();
    final esvPath = join(dbPath, "kjv_bible.SQLite3");
    final esvExist = await databaseExists(esvPath);
    if (!esvExist) {
      await Directory(dirname(esvPath)).create(recursive: true);
      ByteData data = await rootBundle.load("assets/sqlite/kjv_bible.SQLite3");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(esvPath).writeAsBytes(bytes, flush: true);
    }
    final bibleDatabase = await openDatabase(esvPath, readOnly: true);
    return bibleDatabase;
  }

  static Future<Database> getDictionary()async{
    final dbPath = await getDatabasesPath();
    final biblePath = join(dbPath, "isbe_dictionary.SQLite3");
    final bibleExist = await databaseExists(biblePath);
    if (!bibleExist) {
      await Directory(dirname(biblePath)).create(recursive: true);
      ByteData data = await rootBundle.load("assets/sqlite/isbe_dictionary.SQLite3");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(biblePath).writeAsBytes(bytes, flush: true);
    }
    final bibleDatabase = await openDatabase(biblePath, readOnly: true);
    return bibleDatabase;
  }

}