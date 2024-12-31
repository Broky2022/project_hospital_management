import 'package:flutter/material.dart';
import 'package:project_hospital_management/models/user.dart';
import 'package:provider/provider.dart';
import '../database/databaseHelper.dart';
import '../providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  // Key để quản lý và validate form
  final _formKey = GlobalKey<FormState>();

  // Map các controllers cho các trường input
  final Map<String, TextEditingController> controllers = {
    'email': TextEditingController(),
    'password': TextEditingController(),
    'name': TextEditingController(),
    'age': TextEditingController(),
    'weight': TextEditingController(),
    'address': TextEditingController(),
    'specialty': TextEditingController(),
    'experience': TextEditingController(),
    'description': TextEditingController(),
  };

  // Các biến trạng thái
  bool _isLoading = false;
  bool _obscurePassword = true;
  String _selectedRole = 'patient';

  // Controllers cho animation
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Khởi tạo animation fade-in
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
    // Giải phóng bộ nhớ
    controllers.forEach((_, controller) => controller.dispose());
    _animationController.dispose();
    super.dispose();
  }

  // Validate email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  // Validate password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }

  // Validate số (tuổi, cân nặng, kinh nghiệm)
  String? _validateNumber(String? value, String field) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập $field';
    }
    if (int.tryParse(value) == null) {
      return '$field phải là số';
    }
    return null;
  }

  // Xử lý đăng ký
  Future<void> _handleSignup() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        final userData = {
          'email': controllers['email']!.text.trim(),
          'password': controllers['password']!.text,
          'name': controllers['name']!.text.trim(),
          'age': controllers['age']!.text.trim(),
          'weight': controllers['weight']!.text.trim(),
          'address': controllers['address']!.text.trim(),
          'description': controllers['description']!.text.trim(),
        };

        if (_selectedRole == 'doctor') {
          userData['specialty'] = controllers['specialty']!.text.trim();
          userData['experience'] = controllers['experience']!.text.trim();
        }

        print('Signup data: $userData'); // Debug log
        final success = await context.read<AuthProvider>().signup(
          userData,
          _selectedRole,
        );
        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đăng ký thành công'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đăng ký thất bại. Vui lòng thử lại'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký'),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Dropdown chọn vai trò
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButtonFormField<String>(
                      value: _selectedRole,
                      decoration: const InputDecoration(
                        labelText: 'Vai trò',
                        border: InputBorder.none,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'patient',
                          child: Text('BỆNH NHÂN'),
                        ),
                        DropdownMenuItem(
                          value: 'doctor',
                          child: Text('BÁC SĨ'),
                        ),
                      ],
                      onChanged: (value) => setState(() => _selectedRole = value!),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Form đăng ký chung
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controllers['email'],
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: controllers['password'],
                          decoration: InputDecoration(
                            labelText: 'Mật khẩu',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          obscureText: _obscurePassword,
                          validator: _validatePassword,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Form thông tin bệnh nhân
                if (_selectedRole == 'patient')
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: controllers['name'],
                            decoration: const InputDecoration(
                              labelText: 'Họ tên',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: (value) => value?.isEmpty ?? true ? 'Vui lòng nhập họ tên' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: controllers['age'],
                            decoration: const InputDecoration(
                              labelText: 'Tuổi',
                              prefixIcon: Icon(Icons.cake_outlined),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) => _validateNumber(value, 'tuổi'),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: controllers['weight'],
                            decoration: const InputDecoration(
                              labelText: 'Cân nặng (kg)',
                              prefixIcon: Icon(Icons.monitor_weight_outlined),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) => _validateNumber(value, 'cân nặng'),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: controllers['address'],
                            decoration: const InputDecoration(
                              labelText: 'Địa chỉ',
                              prefixIcon: Icon(Icons.home_outlined),
                            ),
                            validator: (value) => value?.isEmpty ?? true ? 'Vui lòng nhập địa chỉ' : null,
                          ),
                        ],
                      ),
                    ),
                  )
                // Form thông tin bác sĩ
                else
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: controllers['name'],
                            decoration: const InputDecoration(
                              labelText: 'Họ tên',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: (value) => value?.isEmpty ?? true ? 'Vui lòng nhập họ tên' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: controllers['specialty'],
                            decoration: const InputDecoration(
                              labelText: 'Chuyên khoa',
                              prefixIcon: Icon(Icons.medical_services_outlined),
                            ),
                            validator: (value) => value?.isEmpty ?? true ? 'Vui lòng nhập chuyên khoa' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: controllers['experience'],
                            decoration: const InputDecoration(
                              labelText: 'Số năm kinh nghiệm',
                              prefixIcon: Icon(Icons.work_outline),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) => _validateNumber(value, 'số năm kinh nghiệm'),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Form mô tả
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: controllers['description'],
                      decoration: const InputDecoration(
                        labelText: 'Mô tả',
                        prefixIcon: Icon(Icons.description_outlined),
                      ),
                      maxLines: 3,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Nút đăng ký
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignup,
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
                    'Đăng ký',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}