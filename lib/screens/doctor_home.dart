import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/databaseHelper.dart';
import '../database/showData.dart';
import '../providers/auth_provider.dart';
import '../utils/config.dart';
import 'appointmentDetail.dart';
import 'appointmentsTab.dart';
import 'dateTimePickerDialog.dart';
import 'doctor_profile.dart';
import 'login_form.dart';
import 'package:google_fonts/google_fonts.dart';

import 'patientsTab.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({Key? key}) : super(key: key);

  @override
  _DoctorHomeState createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  // Controllers và biến trạng thái
  int _selectedIndex = 0; // Index cho bottom navigation
  bool _isLoading = false;

  // Xử lý đăng xuất
  Future<void> _handleLogout() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<AuthProvider>(context, listen: false).logout();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng xuất thất bại. Vui lòng thử lại.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Xử lý chuyển tab
  void _onTabChanged(int index) {
    setState(() => _selectedIndex = index);
    // TODO: Implement chuyển tab
  }

//chuyển tab
  Widget _getTabContent(int index) {
    final doctorId = Provider.of<AuthProvider>(context, listen: false).userId;
    switch (index) {
      case 0: // Tab Bệnh nhân
        showData('patients'); //check dữ liệu từ bảng vào console
        return PatientsTab();
      case 1: // Tab Lịch khám
        print('=> Doctor ID: $doctorId');
        showData('appointments');
        return AppointmentsTab();
      case 2: // Tab Hồ sơ
        showData('doctors');
        print('=> Doctor ID: $doctorId');

        if (doctorId != null) {
          // Trả về DoctorProfilePage với doctorId từ AuthProvider
          return DoctorProfilePage();
        } else {
          // Xử lý khi không tìm thấy doctorId (có thể hiển thị thông báo lỗi)
          return Center(child: Text('Không tìm thấy thông tin bác sĩ.'));
        }
      default:
        return PatientsTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý bệnh nhân'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Đăng xuất',
          ),
        ],
      ),
      body: _getTabContent(_selectedIndex), // Hiển thị nội dung của tab
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabChanged,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Bệnh nhân',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Lịch khám',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Hồ sơ',
          ),
        ],
      ),
    );
  }
}
