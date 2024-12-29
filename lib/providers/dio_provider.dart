import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioProvider {
  Future<bool> getToken(String email, String password) async {
    try {
      var response = await Dio().post(
        'http://127.0.0.1:8000/api/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 && response.data != '') {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data);
        return true;
      }
      return false;
    } catch (error) {
      print('Login error: $error');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUser(String token) async {
    try {
      var user = await Dio().get(
        'http://127.0.0.1:8000/api/user',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (user.statusCode == 200 && user.data != '') {
        return user.data;
      }
      return null;
    } catch (error) {
      print('Get user error: $error');
      return null;
    }
  }

  Future<bool> registerUser(String username, String email, String password) async {
    try {
      var user = await Dio().post(
        'http://127.0.0.1:8000/api/register',
        data: {
          'name': username,
          'email': email,
          'password': password
        },
      );

      return user.statusCode == 201 && user.data != '';
    } catch (error) {
      print('Register error: $error');
      return false;
    }
  }
}