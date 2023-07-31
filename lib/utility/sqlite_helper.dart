import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteHelper {
  final String? nameDatabase = 'waterproject.db';
  final String? tableDatabase = 'orderdetailTable';
  int version = 1;

  final String? idColumn = 'id';
  final String? water_id = 'water_id';
  final String? brand_id = 'brand_id';
  final String? brand_name = 'brand_name';
  final String? price = 'price';
  final String? amount = 'amount';
  final String? sum = 'sum';
  final String? distance = 'distance';
  final String? transport = 'transport';

  SQLiteHelper() {
    initDatabase();
  }

  Future<Null> initDatabase() async {
    await openDatabase(join(await getDatabasesPath(), nameDatabase),
        onCreate: (db, version) => db.execute(
            'CREATE TABLE $tableDatabase ($idColumn INTEGER PRIMARY KEY, $water_id TEXT, $brand_id TEXT, $brand_name TEXT, $price TEXT, $amount TEXT, $sum TEXT, $distance TEXT, $transport TEXT,)'),
        version: version);
  }
}
