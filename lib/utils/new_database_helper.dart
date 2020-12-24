import 'package:flutter_monthly_budget/models/newPDF.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

//Database Helper for accessing SQLite

class DatabaseHelper1 {
  static DatabaseHelper1 _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  DatabaseHelper1._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper1() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper1
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  //Opening Database
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  //Initialising database
  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'budgetDatabase.db';

    // Open/create the database at a given path
    var budgetDatabase =
        await openDatabase(path, version: 3, onCreate: _createDb);
    return budgetDatabase;
  }

  //Create Table
  void _createDb(Database db, int newVersion) async {
    await db.execute('''CREATE TABLE CD_TABLE(
    id TEXT, 
    description TEXT, 
    transact TEXT, 
    amount TEXT, 
    date TEXT);''').catchError((onError) {
      print("onError $onError");
    });
  }

  // Insert Operation
  Future<int> insertCD(CreditDebitClass creditDebit) async {
    Database db = await this.database;
    var result = await db.insert("CD_TABLE", creditDebit.toMap());
    return result;
  }

  // Update Operation
  Future<int> updateCD(CreditDebitClass creditDebit) async {
    var db = await this.database;
    var result = await db.update("CD_TABLE", creditDebit.toMap(),
        where: 'id = ?_ref', whereArgs: [creditDebit.id]);
    return result;
  }

  // Delete All Rows Operation
  Future<int> deleteCD() async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM CD_TABLE');
    return result;
  }

  // Fetch Operation
  Future<List<Map<String, dynamic>>> getCreditDebitMapList() async {
    Database db = await this.database;
    var result = await db.query('CD_TABLE', orderBy: 'id DESC');
    return result;
  }
}
