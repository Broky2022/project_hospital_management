import 'package:flutter/material.dart';
import '../database/databasehelper.dart';
import '../models/user.dart';
import '../models/doctor.dart';
import '../view/signup_form.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>
    with SingleTickerProviderStateMixin {
  // Controllers để quản lý input từ các TextFormField
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Key để validate form

  bool _isLoading = false; // Trạng thái loading khi đăng nhập

  // Controllers cho animation fade-in
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Khởi tạo animation fade-in khi màn hình được load
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi widget bị hủy
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Validate email với regex
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email của bạn';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Vui lòng nhập địa chỉ email hợp lệ';
    }
    return null;
  }

  // Validate mật khẩu
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu của bạn';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải dài ít nhất 6 ký tự';
    }
    return null;
  }

  // Xử lý đăng nhập
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true); // Hiển thị loading

      try {
        // Lấy dữ liệu từ form
        final email = _emailController.text.trim();
        final password = _passwordController.text;

        // Kiểm tra thông tin đăng nhập trong database
        final db = await DatabaseHelper.instance.database;
        final users = await db.query(
          'users',
          where: 'email = ? AND password = ?',
          whereArgs: [email, password],
        );

        if (mounted) {
          if (users.isNotEmpty) {
            // Đăng nhập thành công
            final user = User.fromMap(users.first);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Welcome ${user.name}!'),
                backgroundColor: Colors.green,
              ),
            );
            // TODO: Chuyển đến trang chủ hoặc dashboard
          } else {
            // Đăng nhập thất bại
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đã xảy ra lỗi. Vui lòng thử lại'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        // Xử lý lỗi và hiển thị thông báo
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã xảy ra lỗi. Vui lòng thử lại.'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        // Tắt loading
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      // Animation fade-in cho toàn bộ form
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icon đăng nhập
                const SizedBox(height: 32),
                Icon(
                  Icons.account_circle,
                  size: 80,
                  color: theme.primaryColor,
                ),
                const SizedBox(height: 32),

                // Form field nhập email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                ),

                // Form field nhập mật khẩu
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  validator: _validatePassword,
                ),

                // Nút đăng nhập với loading indicator
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(fontSize: 16),
                        ),
                ),

                // Link đến trang đăng ký
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpForm()),
                          ),
                  child: const Text('Bạn chưa có tài khoản? Đăng ký'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
