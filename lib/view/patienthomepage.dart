import 'package:flutter/material.dart';

import '../models/user.dart';

class PatientHomePage extends StatelessWidget {
  final User user;

  PatientHomePage({required this.user});

  @override
  Widget build(BuildContext context) {
    // Thông tin bác sĩ điều trị giả
    User doctor = User(
        id: 1, email: 'doctor@example.com', password: '123456', role: 'doctor');

    return Scaffold(
      appBar: AppBar(
        title: Text('Trang Chủ Bệnh Nhân'),
      ),
      body: Column(
        children: [
          Text('Chào mừng ${user.email}!', style: TextStyle(fontSize: 24)),
          SizedBox(height: 16),
          Text('Thông tin bác sĩ điều trị của bạn:',
              style: TextStyle(fontSize: 20)),
          SizedBox(height: 16),
          ListTile(
            title: Text(doctor.email), // Hiển thị email của bác sĩ
            subtitle: Text('Vai trò: ${doctor.role}'),
            onTap: () {
              // Điều hướng đến thông tin chi tiết bác sĩ
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorDetailPage(doctor: doctor),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DoctorDetailPage extends StatelessWidget {
  final User doctor;

  DoctorDetailPage({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông Tin Bác Sĩ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Tên bác sĩ: ${doctor.email}', style: TextStyle(fontSize: 20)),
            Text('Vai trò: ${doctor.role}', style: TextStyle(fontSize: 20)),
            // Thêm các thông tin khác ở đây
          ],
        ),
      ),
    );
  }
}
