import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBhelper {
  static Future<sql.Database> dataBase() async {
    final dbpath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbpath, 'places.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places (id TEXT PRIMARY KEY, title TEXT, image TEXT,loc_lat REAL ,loc_lng REAL, adress TEXT )');
    }, version: 1);
  }
  //returning the data bas access

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBhelper.dataBase();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBhelper.dataBase();
    return db.query(table);
  }

  static Future<void> DeleteData(String table, String placeId) async {
    final db = await DBhelper.dataBase();
    db.rawDelete('DELETE FROM $table WHERE id = "$placeId"');
  }
}
