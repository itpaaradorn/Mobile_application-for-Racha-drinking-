import 'package:application_drinking_water_shop/model/cart_model.dart';
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
  final String? size = 'size';
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
            'CREATE TABLE $tableDatabase ($idColumn INTEGER PRIMARY KEY, $water_id TEXT,$brand_id TEXT,$brand_name TEXT,$price TEXT,$size TEXT,$amount TEXT,$sum TEXT,$distance TEXT,$transport TEXT)'),
        version: version);
  }

  Future<Database> connectedDatabase() async {
    return openDatabase(join(await getDatabasesPath(), nameDatabase));
  }

  Future<Null> insertDataToSQLite(CartModel cartModel) async {
    Database database = await connectedDatabase();
    try {
      database.insert(
        tableDatabase!,
        cartModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('e insertData ==>> ${e.toString()}');
    }
  }

  Future<List<CartModel>> readAllDataFormSQLite() async {
    Database database = await connectedDatabase();
    List<CartModel> cartModels = [];

    List<Map<String, dynamic>> maps = await database.query(tableDatabase!);
    for (var map in maps) {
      CartModel cartModel = CartModel.fromJson(map);
      cartModels.add(cartModel);
    }

    return cartModels;
  }

  Future<Null> deleteDataWhereId(int id) async {
    Database database = await connectedDatabase();
    try {
      await database.delete(tableDatabase!, where: '$idColumn = $id');
    } catch (e) {
      print('e delete ==> ${e.toString()}');
    }
  }

  
  Future<Null> deleteAllData() async {
    Database database = await connectedDatabase();
    try {
      await database.delete(tableDatabase!);
    } catch (e) {
      print('e delete All ==> ${e.toString()}');
    }
  }



}
