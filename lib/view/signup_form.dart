import 'package:flutter/material.dart';
import '../database/databasehelper.dart';
import '../models/user.dart';
import '../models/doctor.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> with SingleTickerProviderStateMixin {
  // Controllers để quản lý input từ các TextFormField
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _bioDataController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Key để validate form

  // Các biến trạng thái
  bool _isLoading = false; // Trạng thái đang xử lý
  bool _isDoctor = false; // Kiểm tra có phải bác sĩ không
  bool _obscurePassword = true; // Ẩn/hiện mật khẩu

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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioDataController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Validate tên người dùng
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    return null;
  }

  // Validate email với regex
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Validate mật khẩu (yêu cầu có chữ hoa và số)
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  // Validate bio data cho bác sĩ
  String? _validateBioData(String? value) {
    if (_isDoctor && (value == null || value.isEmpty)) {
      return 'Please enter your bio data';
    }
    return null;
  }

  // Xử lý đăng ký
  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true); // Hiển thị loading

      try {
        // Lấy dữ liệu từ form
        final name = _nameController.text.trim();
        final email = _emailController.text.trim();
        final password = _passwordController.text;
        final type = _isDoctor ? 'doctor' : 'user';
        final bioData = _bioDataController.text.trim();

        final db = DatabaseHelper.instance;

        // Nếu là bác sĩ thì tạo thêm record trong bảng doctors
        if (_isDoctor) {
          final doctor = Doctor(
            docId: email,
            category: 'General',
            patients: 0,
            experience: 0,
            bioData: bioData,
            status: 'active',
          );
          await db.createDoctor(doctor);
        }

        // Tạo user mới
        final user = User(
          name: name,
          type: type,
          email: email,
          password: password,
        );
        await db.createUser(user);

        // Hiển thị thông báo thành công và quay lại màn hình login
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully! Please login.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        // Xử lý lỗi và hiển thị thông báo
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error occurred. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
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
        title: const Text('Sign Up'),
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
                // Icon đăng ký
                const SizedBox(height: 24),
                Icon(
                  Icons.person_add_rounded,
                  size: 80,
                  color: theme.primaryColor,
                ),
                const SizedBox(height: 24),

                // Form field nhập họ tên
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: _validateName,
                ),
                // Form field nhập email
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                ),
                // Form field nhập mật khẩu với toggle ẩn/hiện
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  validator: _validatePassword,
                ),


                // Switch chọn loại tài khoản (user/doctor)
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Register as Doctor'),
                  value: _isDoctor,
                  onChanged: (value) {
                    setState(() => _isDoctor = value);
                  },
                  secondary: Icon(
                    Icons.medical_services_outlined,
                    color: _isDoctor ? theme.primaryColor : null,
                  ),
                ),
                // Form field nhập bio data (chỉ hiện khi đăng ký là bác sĩ)
                if (_isDoctor) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _bioDataController,
                    decoration: InputDecoration(
                      labelText: 'Bio Data',
                      hintText: 'Enter your qualifications and experience',
                      prefixIcon: const Icon(Icons.description_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
                    validator: _validateBioData,
                  ),
                ],
                // Nút đăng ký với loading indicator
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _signUp,
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
                    'Create Account',
                    style: TextStyle(fontSize: 16),
                  ),
                ),

                // Link quay lại trang đăng nhập
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: const Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}