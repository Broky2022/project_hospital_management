import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../models/user.dart';

class DoctorProfilePage extends StatelessWidget {
  final Doctor doctor;

  DoctorProfilePage({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hồ Sơ Bác Sĩ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tên bác sĩ (email có thể là tên hiển thị)
            Text(
              'Tên Bác Sĩ: ${doctor.email}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Chuyên ngành của bác sĩ
            Text(
              'Chuyên Ngành: ${doctor.specialty ?? "Chưa có chuyên ngành"}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),

            // Số năm kinh nghiệm
            Text(
              'Kinh Nghiệm: ${doctor.yearsOfExperience ?? "Chưa cập nhật"} năm',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),

            // Mô tả về bác sĩ
            Text(
              'Mô Tả: ${doctor.description ?? "Chưa có mô tả"}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),

            // Nút để chỉnh sửa hồ sơ (nếu cần)
            ElevatedButton(
              onPressed: () {
                // Tạo trang sửa hồ sơ bác sĩ
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => EditDoctorProfilePage(doctor: doctor),
                //   ),
                // );
              },
              child: Text('Chỉnh Sửa Hồ Sơ'),
            ),
          ],
        ),
      ),
    );
  }
}
