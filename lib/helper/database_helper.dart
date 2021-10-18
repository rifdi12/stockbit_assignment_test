import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "StockBitAlarm.db";
  static final _databaseVersion = 1;

  Future get database async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    Database db = await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);

    return db;
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE alarm_table (
            id INTEGER PRIMARY KEY,
            time TEXT NOT NULL,
            days TEXT NOT NULL,
            repeated BOOL NOT NULL,
            active BOOL NOT NULL,
            ringing BOOL NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE chart (
            id INTEGER PRIMARY KEY,
            alarm_id INTEGER NOT NULL,
            ringtone_count INTEGER,
            times_register TEXT NOT NULL,
            times_tap TEXT
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row, table) async {
    Database db = await database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future queryAllRows(table) async {
    Database? db = await database;
    return await db!.query(table);
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row, table, columnId) async {
    Database db = await database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id, table, columnId) async {
    Database db = await database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
