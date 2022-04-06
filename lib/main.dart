import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personalcahs/db/sql.dart';
import 'package:personalcahs/model/models.dart';
import 'package:personalcahs/ui/pages/pages.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DbHelper _dbHelper = DbHelper();
  @override
  void initState() {
    super.initState();
    _dbHelper.saveData(Cash(id: 1, catatan: "Test", balance: "2000"));
    print(_dbHelper.initDb());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
