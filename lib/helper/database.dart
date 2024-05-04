import 'package:sqflite/sqflite.dart';

class MyDatabase {
  static Future<Database> openDB() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = "$databasesPath/resign.db";

// Delete the database
//     await deleteDatabase(path);

// open the database
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE data_resign (id INTEGER PRIMARY KEY AUTOINCREMENT, nama TEXT, alasan TEXT, jenis TEXT, tanggal TEXT, tahun TEXT)');
    });

    return database;
  }
}
