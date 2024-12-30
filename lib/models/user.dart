class User {
  final int? id;
  final String name;
  final String type;
  final String email;
  final String password;

  User({
    this.id,
    required this.name,
    required this.type,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'email': email,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      email: map['email'],
      password: map['password'],
    );
  }
}
