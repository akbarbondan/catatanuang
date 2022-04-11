part of 'models.dart';

class Cash {
  int id;
  int balance;
  String catatan;
  String category;

  Cash({this.id, this.balance, this.catatan, this.category});
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'balance': balance,
      'catatan': catatan,
      'category': category,
    };

    return map;
  }

  factory Cash.fromMap(Map<String, dynamic> data) {
    return Cash(
        id: data['id'],
        balance: data['balance'],
        catatan: data['catatan'],
        category: data['category']);
  }
}
