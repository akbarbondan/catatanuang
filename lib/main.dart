import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personalcahs/db/sql.dart';
import 'package:personalcahs/model/models.dart';
import 'package:personalcahs/ui/pages/pages.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}
