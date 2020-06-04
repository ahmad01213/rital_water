import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

import '../shared_data.dart';

class DBHelper {
  static Future<Database> database(String query) async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'user_cart.db'),
        onCreate: (db, version) {
      return db.execute(sql_cart_query);
    }, version: 1);
  }

  static Future<void> insert(
      String table, Map<String, Object> data, query) async {
    final db = await DBHelper.database(sql_cart_query);
    db.insert(
      'user_cart',
      data,
    );
  }

  static Future<void> clearCart() async {
    final db = await DBHelper.database(sql_cart_query);
    await db.execute("DROP Table user_cart");
    await db.execute(sql_cart_query);
  }

  static Future<int> delete(String table, int id, query) async {
    final db = await DBHelper.database(query);
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> update(String table, int key, int quantity, query) async {
    final db = await DBHelper.database(query);
    await db.update(
        table,
        <String, int>{
          'quantity': quantity,
        },
        where: 'id = ?',
        whereArgs: [key]);
  }

  static Future<List<Map<String, dynamic>>> getData(String table, query) async {
    final db = await DBHelper.database(query);
    return db.query(table);
  }

  static Future<Database> orderdatabase(String query) async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'user_orders.db'),
        onCreate: (db, version) {
      return db.execute(query);
    }, version: 1);
  }

  static Future<void> insertorder(
      String table, Map<String, Object> data, query) async {
    final db = await DBHelper.orderdatabase(query);
    db.insert(
      table,
      data,
    );
  }

  static Future<List<Map<String, dynamic>>> getorderData(
      String table, query) async {
    final db = await DBHelper.orderdatabase(query);
    return db.query(table);
  }
}
