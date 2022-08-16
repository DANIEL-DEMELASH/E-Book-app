import 'package:localstore/localstore.dart';

class Book {
  final String title;
  final String price;
  final String pageSize;
  final String edition;
  final String coverImage;
  Book({
    required this.title,
    required this.price,
    required this.pageSize,
    required this.edition,
    required this.coverImage,
  });
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'page_size': pageSize,
      'edition': edition,
      'cover_photo': coverImage
    };
  }

  factory Book.fromJson(Map<String, dynamic> jsonData) {
    return Book(
      title: jsonData['title'],
      price: jsonData['price'],
      pageSize: jsonData['page_size'],
      edition: jsonData['edition'],
      coverImage: jsonData['cover_photo'],
    );
  }
}

extension ExtTodo on Book {
  Future save() async {
    final _db = Localstore.instance;
    return _db.collection('books').doc(title).set(toMap());
  }

  Future delete() async {
    final _db = Localstore.instance;
    return _db.collection('books').doc(title).delete();
  }
}