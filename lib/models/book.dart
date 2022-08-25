import 'package:localstore/localstore.dart';

class Book {
  final String id;
  final String title;
  final double price;
  final int pageSize;
  final int edition;
  final String coverImage;
  final String sampleFile;
  final String rating;
  final String description;

  Book({
    required this.id,
    required this.sampleFile,
    required this.rating,
    required this.description,
    required this.title,
    required this.price,
    required this.pageSize,
    required this.edition,
    required this.coverImage,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'page_size': pageSize,
      'edition': edition,
      'cover_photo': coverImage,
      'description': description,
      'sample_file': sampleFile,
      'rating': rating,
    };
  }

  factory Book.fromJson(Map<String, dynamic> jsonData) {
    return Book(
      id: jsonData['id'],
      title: jsonData['title'],
      price: jsonData['price'].toDouble(),
      pageSize: jsonData['page_size'],
      edition: jsonData['edition'],
      coverImage: jsonData['cover_photo'],
      description: jsonData['description'],
      rating: jsonData['rating'].toString(),
      sampleFile: jsonData['sample_file'],
    );
  }
}

extension ExtTodo on Book {
  Future save() async {
    final _db = Localstore.instance;
    return _db.collection('books').doc(id).set(toMap());
  }

  Future delete() async {
    final _db = Localstore.instance;
    return _db.collection('books').doc(id).delete();
  }
}
