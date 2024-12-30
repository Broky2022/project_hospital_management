class User {
  final int? id;  // Đổi thành nullable vì khi tạo mới sẽ chưa có id
  final String email;
  final String password;
  final String role;

  User({
    this.id,
    required this.email,
    required this.password,
    required this.role,
  });

  // Thêm method để convert thành Map cho việc lưu vào database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  // Factory constructor để tạo User từ Map (khi đọc từ database)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      email: map['email'] as String,
      password: map['password'] as String,
      role: map['role'] as String,
    );
  }
}