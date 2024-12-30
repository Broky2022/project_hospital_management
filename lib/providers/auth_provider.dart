import 'package:flutter/material.dart';
import '../database/databaseHelper.dart';

class AuthProvider with ChangeNotifier {
  int? _userId;  // Khai báo biến _userId kiểu nullable int
  String? _userRole;

  // Getters để truy cập từ bên ngoài
  int? get userId => _userId;
  String? get userRole => _userRole;

  Future<bool> login(String email, String password) async {
    final db = DatabaseHelper.instance;
    final user = await db.getUserByEmail(email);

    if (user != null && user['password'] == password) {
      _userRole = user['role'];
      _userId = user['id'];
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> signup(Map<String, String> userData, String role) async {
    try {
      // Kiểm tra email tồn tại
      final existingUser = await DatabaseHelper.instance.getUserByEmail(userData['email']!);
      if (existingUser != null) {
        throw Exception('Email đã được sử dụng');
      }

      // 1. Insert vào bảng users trước
      final userMap = {
        'email': userData['email'],
        'password': userData['password'],
        'role': role,
      };

      final userId = await DatabaseHelper.instance.insertUser(userMap);

      // 2. Nếu là patient thì insert vào bảng patients
      if (role == 'patient') {
        final patientMap = {
          'id': userId, // Foreign key reference to users table
          'name': userData['name'],
          'age': int.parse(userData['age']!),
          'weight': double.parse(userData['weight']!),
          'address': userData['address'],
          'description': userData['description'],
        };

        await DatabaseHelper.instance.insert('patients', patientMap);
      }

      return true;
    } catch (e) {
      print('Signup error: $e');
      return false;
    }
  }
  Future<void> logout() async {
    _userId = null;
    _userRole = null;
    notifyListeners();
  }


  Future<void> _clearLocalData() async {
    // Clear các dữ liệu local
  }


}


