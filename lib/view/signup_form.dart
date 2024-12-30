import 'package:flutter/material.dart';
import 'package:project_hospital_management/models/user.dart';
import '../database/databasehelper.dart'; // Import lớp DataHelper và các model cần thiết

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  bool _isPasswordVisible =
      false; // Biến điều khiển trạng thái mật khẩu (ẩn/hiện)
  String _selectedRole = 'user'; // Biến chọn loại tài khoản (user/doctor)
  String _errorMessage = '';

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty || _selectedRole.isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng nhập đầy đủ thông tin.';
      });
      return;
    }

    // Kiểm tra nếu email đã tồn tại trong cơ sở dữ liệu
    final existingUser = await DataHelper.instance.getUserByEmail(email);
    if (existingUser != null) {
      setState(() {
        _errorMessage = 'Email này đã được sử dụng.';
      });
      return;
    }

    // Thêm người dùng mới vào cơ sở dữ liệu
    final newUser =
        User(id: 0, email: email, password: password, role: _selectedRole);
    await DataHelper.instance.addUser(newUser);

    // Chuyển đến màn hình đăng nhập
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng Ký'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Nhập email của bạn',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText:
                  !_isPasswordVisible, // Điều khiển trạng thái ẩn/hiện mật khẩu
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                hintText: 'Nhập mật khẩu của bạn',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            // Dropdown để chọn loại tài khoản
            DropdownButtonFormField<String>(
              value: _selectedRole,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRole = newValue!;
                });
              },
              items: [
                DropdownMenuItem(
                  value: 'user',
                  child: Text('User'),
                ),
                DropdownMenuItem(
                  value: 'doctor',
                  child: Text('Doctor'),
                ),
              ],
              decoration: InputDecoration(
                labelText: 'Chọn loại tài khoản',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _register,
              child: Text('Đăng Ký'),
            ),
          ],
        ),
      ),
    );
  }
}
