part of 'db.dart';

class DBHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE uangku(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        debit INTEGER,
        credit INTEGER,
        catatan TEXT,
        status TEXT,
        category TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);

    await database.execute(
        """CREATE TABLE category(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, category TEXT)""");
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

// TODO : CATEGORY
  static Future<int> craateCategoty(Category category) async {
    final db = await DBHelper.db();
    final id = await db.insert('category', category.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<int> deleteCategory(int id) async {
    final db = await DBHelper.db();
    final result =
        await db.delete('category', where: 'id =? ', whereArgs: [id]);
    return result;
  }

  static Future<List<Category>> getAllCategory() async {
    final db = await DBHelper.db();
    final maps = await db.query('category', orderBy: "id DESC");
    return List.generate(maps.length, (index) {
      return Category(id: maps[index]['id'], category: maps[index]['category']);
    });
  }

// TODO : KEUANGAN
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
          credit: maps[index]['credit'],
          debit: maps[index]['debit'],
          catatan: maps[index]['catatan'],
          category: maps[index]['category'],
          status: maps[index]['status'],
          date: maps[index]['createdAt']);
    });
  }

  static Future calculate() async {
    final db = await DBHelper.db();
    final total = await db
        .rawQuery("SELECT SUM(debit) - SUM(credit) AS total FROM uangku");
    return total.toList();
  }

  static Future calculateIn() async {
    final db = await DBHelper.db();
    final totalIn =
        await db.rawQuery("SELECT  SUM(debit) AS inbalance  FROM uangku");

    return totalIn.toList();
  }

  static Future calculateOut() async {
    final db = await DBHelper.db();
    final totalIn =
        await db.rawQuery("SELECT  SUM(credit) AS outbalance  FROM uangku");
    return totalIn.toList();
  }

  static Future<int> deletData(int id) async {
    final db = await DBHelper.db();
    int result = await db.delete('uangku', where: 'id =?', whereArgs: [id]);

    return result;
  }

  static Future<int> upadateData(
    int id,
    int debit,
    int credit,
    String catatan,
    String category,
  ) async {
    final db = await DBHelper.db();
    final data = {
      'debit': debit,
      'credit': credit,
      'catatan': catatan,
      'category': category,
      'createdAt': DateTime.now().toString()
    };
    final result =
        await db.update('uangku', data, where: 'id =?', whereArgs: [id]);

    return result;
  }
}
