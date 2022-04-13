part of 'models.dart';

class Cash {
  int id;
  int debit;
  int credit;
  String catatan;
  String status;
  String category;
  String date;

  Cash(
      {this.id,
      this.debit,
      this.credit,
      this.catatan,
      this.category,
      this.status,
      this.date});
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'debit': debit,
      'credit': credit,
      'catatan': catatan,
      'status': status,
      'category': category,
    };

    return map;
  }

  factory Cash.fromMap(Map<String, dynamic> data) {
    return Cash(
        id: data['id'],
        debit: data['debit'],
        credit: data['credit'],
        catatan: data['catatan'],
        category: data['category'],
        status: data['status'],
        date: data['createdAt']);
  }
}
