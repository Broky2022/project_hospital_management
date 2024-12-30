import 'package:flutter/material.dart';
import '../database/databasehelper.dart';

class AuthProvider with ChangeNotifier {
  String? _userRole;
  int? _userId;

  String? get userRole => _userRole;
  int? get userId => _userId;

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

  Future<bool> signup(Map<String, dynamic> userData, String role) async {
    try {
      final db = DatabaseHelper.instance;
      final userId = await db.insertUser({
        'email': userData['email'],
        'password': userData['password'],
        'role': role
      });

      if (role == 'doctor') {
        await db.insert('doctors', {
          'id': userId,
          'specialty': userData['specialty'],
          'years_of_experience': userData['experience'],
          'description': userData['description'],
          'status': 1
        });
      } else {
        await db.insert('patients', {
          'id': userId,
          'name': userData['name'],
          'age': userData['age'],
          'weight': userData['weight'],
          'address': userData['address'],
          'description': userData['description']
        });
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    _userRole = null;
    _userId = null;
    notifyListeners();
  }
}
