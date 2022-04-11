import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:personalcahs/model/models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'dart:async';

class DBHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE uangku(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        balance INTEGER,
        catatan TEXT,
        category TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'Uangku.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createItem(Cash cash) async {
    final db = await DBHelper.db();

    final id = await db.insert('uangku', cash.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Cash>> getItems() async {
    final db = await DBHelper.db();
    final maps = await db.query('uangku', orderBy: "id DESC");

    return List.generate(maps.length, (index) {
      return Cash(
        id: maps[index]['id'],
        balance: maps[index]['balance'],
        catatan: maps[index]['catatan'],
        category: maps[index]['category'],
      );
    });
  }

  static Future calculate() async {
    final db = await DBHelper.db();
    final total = await db.rawQuery("SELECT SUM(balance) AS total FROM uangku");
    print(total);
    return total.toList();
  }

  static Future calculateIn() async {
    final db = await DBHelper.db();
    final totalIn = await db.rawQuery(
        "SELECT  SUM(balance) AS inbalance  FROM uangku where category = 'Masuk'");

    return totalIn.toList();
  }

  static Future calculateOut() async {
    final db = await DBHelper.db();
    final totalIn = await db.rawQuery(
        "SELECT  SUM(balance) AS outbalance  FROM uangku where category = 'Keluar'");
    return totalIn.toList();
  }

  static Future<int> deletData(int id) async {
    final db = await DBHelper.db();
    int result = await db.delete('uangku', where: 'id =?', whereArgs: [id]);

    return result;
  }

  static Future<int> upadateData(
      int id, int balance, String catatan, String category) async {
    final db = await DBHelper.db();
    final data = {
      'balance': balance,
      'catatan': catatan,
      'category': category,
      'createdAt': DateTime.now().toString()
    };
    final result =
        await db.update('uangku', data, where: 'id =?', whereArgs: [id]);

    return result;
  }
}
