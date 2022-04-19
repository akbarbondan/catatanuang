part of 'models.dart';

class Category {
  int id;
  String category;

  Category({this.id, this.category});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'category': category};
    return map;
  }

  factory Category.tormMap(Map<String, dynamic> data) {
    return Category(id: data['id'], category: data['category']);
  }
}
