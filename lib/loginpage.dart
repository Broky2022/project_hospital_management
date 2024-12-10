import 'package:flutter/material.dart';
import 'config.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Thông tin đăng nhập mặc định (có thể thay đổi theo yêu cầu)
  final String validUsername = "admin";
  final String validPassword = "12345";

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Kiểm tra thông tin đăng nhập
      if (_usernameController.text == validUsername &&
          _passwordController.text == validPassword) {
        // Nếu đúng, chuyển đến trang BottomNavigationBarExample
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavigationBarExample()),
        );
      } else {
        // Hiển thị thông báo lỗi nếu thông tin sai
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tên đăng nhập hoặc mật khẩu sai'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng Nhập'),
      ),
      body: Center(
        child: Card(
          elevation: 4.0, // Độ phủ bóng
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Thêm khoảng cách bên ngoài
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4, // Giới hạn chiều rộng của Card
              height: MediaQuery.of(context).size.height * 0.4, // Giới hạn chiều cao của Card
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Tên đăng nhập',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên đăng nhập';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _login,
                      child: Text('Đăng nhập'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}