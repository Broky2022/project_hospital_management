import 'package:flutter/material.dart';
import '../database/databaseHelper.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  int? _userId; // Khai báo biến _userId kiểu nullable int
  String? _userRole;

  // Getters để truy cập từ bên ngoài
  int? get userId => _userId;
  String? get userRole => _userRole;

  User? _currentUser;

  User? get currentUser => _currentUser;

  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void clearCurrentUser() {
    _currentUser = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final db = DatabaseHelper.instance;
    final user = await db.getUserByEmail(email);

    if (user == null) {
      throw Exception('Người dùng không tồn tại');
    }

    if (user['password'] == password) {
      _userRole = user['role'];
      _userId = user['id'];
      setCurrentUser(
          User.fromMap(user)); // Cập nhật thông tin người dùng hiện tại
      notifyListeners();
      return true;
    } else {
      throw Exception('Mật khẩu không chính xác');
    }
  }

  Future<bool> signup(Map<String, String> userData, String role) async {
    try {
      // Kiểm tra email tồn tại
      final existingUser =
          await DatabaseHelper.instance.getUserByEmail(userData['email']!);
      if (existingUser != null) {
        throw Exception('Email đã được sử dụng');
      }

      // 1. Insert vào bảng users trước
      final userMap = {
        'email': userData['email'],
        'password': userData['password'],
        'role': role,
        'name': userData['name'],
      };
      final userId = await DatabaseHelper.instance.insertUser(userMap);

      // 2. Nếu là doctor thì insert vào bảng doctors
      if (role == 'doctor') {
        final doctorMap = {
          'id': userId,
          'name': userData['name'],
          'specialty': userData['specialty'],
          'years_of_experience': int.tryParse(userData['experience'] ?? '0') ??
              0, // Giá trị mặc định là 0
          'description': userData['description'],
          'status': 1, // Giả sử status mặc định là 1 (active)
        };

        await DatabaseHelper.instance.insertDoctor(doctorMap);
      }
      // 3. Nếu là patient thì insert vào bảng patients
      else if (role == 'patient') {
        final patientMap = {
          'id': userId,
          'name': userData['name'],
          'age': int.tryParse(userData['age'] ?? '0') ??
              0, // Giá trị mặc định là 0
          'weight': double.tryParse(userData['weight'] ?? '0.0') ??
              0.0, // Giá trị mặc định là 0.0
          'address':
              userData['address'] ?? '', // Giá trị mặc định là chuỗi rỗng
          'description': userData['description'],
        };

        await DatabaseHelper.instance.insertPatient(patientMap);
      }

      return true;
    } catch (e) {
      print('Signup error: $e');
      throw e; // Ném lỗi để xử lý ở lớp gọi
    }
  }

  Future<void> logout() async {
    _userId = null;
    _userRole = null;
    _currentUser = null;
    await _clearLocalData();
    notifyListeners();
  }

  Future<void> _clearLocalData() async {
    // Xóa dữ liệu local (ví dụ: SharedPreferences)
    // Ví dụ:
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
  }
}
