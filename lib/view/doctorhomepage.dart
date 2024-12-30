import 'package:flutter/material.dart';
import 'package:project_hospital_management/models/doctor.dart';
import '../models/patient.dart';
import '../models/user.dart';
import 'doctorprofile.dart';

class DoctorHomePage extends StatelessWidget {
  final Doctor user;

  DoctorHomePage({required this.user});

  @override
  Widget build(BuildContext context) {
    // Danh sách bệnh nhân giả
    List<Patient> patients = [
      // Thêm các bệnh nhân khác ở đây
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Trang Chủ Bác Sĩ'),
      ),
      body: Column(
        children: [
          // Danh sách bệnh nhân
          Expanded(
            child: ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                return ListTile(
                  title: Text(patient.name),
                  subtitle: Text('Tuổi: ${patient.age}'),
                  onTap: () {
                    // Điều hướng đến trang chi tiết bệnh nhân
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PatientDetailPage(patient: patient),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Nút tới trang profile của bác sĩ
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorProfilePage(doctor: user),
                ),
              );
            },
            child: Text('Xem Hồ Sơ Bác Sĩ'),
          ),
        ],
      ),
    );
  }
}

class PatientDetailPage extends StatelessWidget {
  final Patient patient;

  PatientDetailPage({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông Tin Bệnh Nhân'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Tên: ${patient.name}', style: TextStyle(fontSize: 20)),
            Text('Tuổi: ${patient.age}', style: TextStyle(fontSize: 20)),
            // Thêm thông tin chi tiết ở đây
            ElevatedButton(
              onPressed: () {
                // Chức năng đặt lịch hẹn
              },
              child: Text('Đặt Lịch Hẹn'),
            ),
          ],
        ),
      ),
    );
  }
}
