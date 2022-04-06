import 'package:path_provider/path_provider.dart';
import 'package:personalcahs/model/models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DbHelper {
  static Database? _database;

  //inisialisasi beberapa variabel yang dibutuhkan
  static String tableName = 'tabelUangKu';
  static String ID = 'id';
  static String BALANCE = 'balance';
  static String CATATAN = 'catatan';
  static String DATE = 'date';
  static String NM_DB = "uangku.db";

  //cek apakah database ada
  Future<Database?> get _db async {
    if (_database != null) {
      return _database;
    }
    _database = await initDb();
    return _database;
  }

  Future<Database?> initDb() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, NM_DB);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    print("ini path data");
    print(path);
  }

  //membuat tabel dan field-fieldnya
  Future<void> _onCreate(Database db, int version) async {
    var sql = "CREATE TABLE $tableName($tableName INTEGER PRIMARY KEY, "
        "$ID TEXT,"
        "$BALANCE TEXT,"
        "$CATATAN TEXT,"
        "$BALANCE TEXT,)";

    await db.execute(sql);
  }

  //insert ke database
  Future<int> saveData(Cash cash) async {
    print("Data berhasil disimpan");
    var dbClient = await _db;
    return cash.id = await dbClient!.insert(tableName, cash.toMap());

    await dbClient.transaction((txn) async {
      var query = "INSERT INTO $tableName VALUES ('" +
          cash.id.toString() +
          "', '" +
          cash.catatan.toString() +
          "', '" +
          cash.balance.toString() +
          "', '" +
          cash.date.toString() +
          "')";

      return await txn.rawInsert(query);
    });
  }

  //read database
  Future<List<Cash>> getData() async {
    var dbClient = await _db;
    List<Map<String, dynamic>> maps =
        await dbClient!.query(tableName, columns: [ID, BALANCE, CATATAN, DATE]);
    List<Cash> cashs = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        cashs.add(Cash.fromMap(maps[i]));
      }
    }
    return cashs;
  }

  //update database
  Future<int?> updateData(Cash cash) async {
    var dbClient = await _db;
    return await dbClient!.update(tableName, cash.toMap(),
        where: '$ID = ?', whereArgs: [cash.id]);
  }

  //hapus database
  Future<int?> deletData(int id) async {
    var dbClient = await _db;
    return await dbClient!.delete(tableName, where: '$ID = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    var dbClient = await _database;
    dbClient!.close();
  }
}
