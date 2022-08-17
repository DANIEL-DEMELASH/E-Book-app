class User {
  final String id;
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final bool isAuthor;
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.isAuthor,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'isAuthor': isAuthor,
      'gender': gender,
    };
  }

  factory User.fromJson(Map<String, dynamic> jsonData) {
    return User(
      id: jsonData['id'],
      firstName: jsonData['first_name'],
      lastName: jsonData['last_name'],
      email: jsonData['email'],
      gender: jsonData['gender'] ?? '',
      isAuthor: jsonData['isAuthor'],
    );
  }
}
