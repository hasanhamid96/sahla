import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';
class DBHelper {
  static Future<sql.Database> Database() async {
    final DBPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(DBPath, 'service.db'),
      version: 1,
      onCreate: (db, version) {
        db.execute(
            "CREATE TABLE serviceFav(id TEXT PRIMARY KEY,name TEXT,desc TEXT,price TEXT,image TEXT)");
      },
    );}
    static Future<void> insert(String table, Map<String, Object> data) async {
      final db = await DBHelper.Database();
      db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);}
      static Future<List<Map<String, dynamic>>> get(String table) async {
        final db = await DBHelper.Database();
        return db.query(table); //get data
      }
        static Future<void> delete(String table, String id) async {
        final db = await DBHelper.Database();
        return await db.delete(table, where: 'id=?', whereArgs: [id]);
//   return   db.rawDelete('DELETE FROM user_table WHERE id = $id');
      }}