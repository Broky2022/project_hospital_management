class User {
  int id;
  String email;
  String password;
  String role; // "doctor" hoặc "patient"

  User(
      {required this.id,
      required this.email,
      required this.password,
      required this.role});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
    );
  }
}
