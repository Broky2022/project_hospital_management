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

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
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
    'description': TextEditingController(text: "Không có mô tả"),
  };

  // Các biến trạng thái
  bool _isLoading = false;
  bool _obscurePassword = true;
  String _selectedRole = 'patient';

  // Animation controller
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

  // Tạo widget cho input field
  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool obscureText = false,
    VoidCallback? toggleObscure,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: toggleObscure != null
            ? IconButton(
                icon:
                    Icon(obscureText ? Icons.visibility : Icons.visibility_off),
                onPressed: toggleObscure,
              )
            : null,
      ),
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText,
    );
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

        final success =
            await context.read<AuthProvider>().signup(userData, _selectedRole);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(success ? 'Đăng ký thành công' : 'Đăng ký thất bại'),
              backgroundColor: success ? Colors.green : Colors.red,
            ),
          );

          if (success) Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Lỗi: ${e.toString()}'),
                backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
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
                      onChanged: (value) =>
                          setState(() => _selectedRole = value!),
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
                        _buildTextField(
                          label: 'Email',
                          icon: Icons.email_outlined,
                          controller: controllers['email']!,
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'Mật khẩu',
                          icon: Icons.lock_outline,
                          controller: controllers['password']!,
                          validator: _validatePassword,
                          obscureText: _obscurePassword,
                          toggleObscure: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Form thông tin theo vai trò
                if (_selectedRole == 'patient')
                  _buildPatientForm()
                else
                  _buildDoctorForm(),

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

  Widget _buildPatientForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              label: 'Họ tên',
              icon: Icons.person_outline,
              controller: controllers['name']!,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Vui lòng nhập họ tên' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Tuổi',
              icon: Icons.cake_outlined,
              controller: controllers['age']!,
              keyboardType: TextInputType.number,
              validator: (value) => _validateNumber(value, 'tuổi'),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Cân nặng (kg)',
              icon: Icons.monitor_weight_outlined,
              controller: controllers['weight']!,
              keyboardType: TextInputType.number,
              validator: (value) => _validateNumber(value, 'cân nặng'),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Địa chỉ',
              icon: Icons.home_outlined,
              controller: controllers['address']!,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Vui lòng nhập địa chỉ' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              label: 'Họ tên',
              icon: Icons.person_outline,
              controller: controllers['name']!,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Vui lòng nhập họ tên' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Chuyên khoa',
              icon: Icons.medical_services_outlined,
              controller: controllers['specialty']!,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Vui lòng nhập chuyên khoa' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Số năm kinh nghiệm',
              icon: Icons.work_outline,
              controller: controllers['experience']!,
              keyboardType: TextInputType.number,
              validator: (value) =>
                  _validateNumber(value, 'số năm kinh nghiệm'),
            ),
          ],
        ),
      ),
    );
  }
}
