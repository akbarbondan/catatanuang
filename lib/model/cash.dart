part of 'models.dart';

class Cash {
  int? id;
  String? catatan;
  String? balance;
  DateTime? date;

  Cash({this.id, this.catatan, this.balance, this.date});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = id;
    }

    map['balance'] = balance;
    map['catatan'] = catatan;
    map['date'] = date;

    return map;
  }

  Cash.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.catatan = map['catatan'];
    this.balance = map['balance'];
    this.date = map['date'];
  }
}
