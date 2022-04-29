import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
Database db;
class DatabaseCreator {
  static const cartTable = 'cart';
  static const id = 'id';
  static const product_id = 'product_id';
  static const name = 'name';
  static const photo = 'photo';
  static const color_code = 'color_code';
  static const size = 'size';
  static const quantity = 'quantity';
  static const quantityTotal = 'quantityTotal';
  static const price = 'price';
  static const pieceId = 'pieceId';
  static const points = 'points';
  static const earnedPoints = 'earnedPoints';
  static const isUsePoint = 'isUsePoint';
  static const addressTable = 'address';
  static const id_address = 'id_address';
  static const name_address = 'name_address';
  static const point_address = 'point_address';
  static const phone_address = 'phone_address';
  static const country_address = 'country_address';
  static const city_address = 'city_address';
  static const cityId = 'cityId';
  static const lat = 'lat';
  static const long = 'long';
  static const String dataBaseName = 'sahla';
  static void databaseLog(String functionName, String sql,
      [List<Map<String, dynamic>> selectQueryResult,
        int insertAndUpdateQueryResult,
        List<dynamic> params]) {
    if (params != null) {
      // print(params);
    }
    if (selectQueryResult != null) {
      // print(selectQueryResult);
    } else if (insertAndUpdateQueryResult != null) {
      //  print(insertAndUpdateQueryResult);
    }}

    Future<void> createCartTable(Database db) async {
      final cartSql = '''CREATE TABLE $cartTable
    (
      $id INTEGER PRIMARY KEY,
      $product_id INTEGER,
      $name TEXT,
      $photo TEXT,
      $color_code TEXT,
      $size TEXT,
      $quantity INTEGER,
      $quantityTotal INTEGER,
      $price INTEGER,
      $pieceId INTEGER,
      $points INTEGER,
      $earnedPoints INTEGER,
      $isUsePoint BOOLEAN
    )''';
      await db.execute(cartSql);}
      Future<void> createAddressTable(Database db) async {
        final addressSql = '''CREATE TABLE $addressTable
    (
      $id_address INTEGER PRIMARY KEY,
      $name_address TEXT,
      $phone_address INTEGER,
      $country_address TEXT,
      $city_address TEXT,
      $point_address TEXT,
      $lat TEXT,
      $long TEXT,
      $cityId INTEGER
    )''';
        await db.execute(addressSql);}
        Future<String> getDatabasePath(String dbName) async {
          final databasePath = await getDatabasesPath();
          final path = join(databasePath, dbName);
          //make sure the folder exists
          if (await Directory(dirname(path)).exists()) {
            //await deleteDatabase(path);
          } else {
            await Directory(dirname(path)).create(recursive: true);
          }
          return path;}
          Future<void> initDatabase() async {
            final path = await getDatabasePath(dataBaseName);
            db = await openDatabase(path, version: 1, onCreate: onCreate);}

            Future<void> onCreate(Database db, int version) async {
              await createCartTable(db);
              await createAddressTable(db);}}