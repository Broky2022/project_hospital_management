import 'package:flutter/material.dart';

import '../database/databaseHelper.dart';

class AppointmentDetailPage extends StatelessWidget {
  final int appointmentId;

  // Nhận appointmentId từ constructor
  AppointmentDetailPage({required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết cuộc hẹn'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance
            .getAppointmentsById(appointmentId), // Gọi hàm getAppointmentsById
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Có lỗi xảy ra: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có dữ liệu cho cuộc hẹn này'));
          }

          final appointment = snapshot
              .data!.first; // Lấy chi tiết cuộc hẹn đầu tiên (vì chỉ có một)

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mã cuộc hẹn: ${appointment['appointment_id']}'),
                SizedBox(height: 8),
                Text('Thời gian: ${appointment['date_time']}'),
                Text('Trạng thái: ${appointment['appointment_status']}'),
                SizedBox(height: 16),
                Text('Bác sĩ: ${appointment['doctor_name']}'),
                Text('Chuyên khoa: ${appointment['doctor_specialty']}'),
                Text(
                    'Kinh nghiệm: ${appointment['doctor_years_of_experience']} năm'),
                Text('Mô tả: ${appointment['doctor_description']}'),
                Text('Trạng thái bác sĩ: ${appointment['doctor_status']}'),
                SizedBox(height: 16),
                Text('Bệnh nhân: ${appointment['patient_name']}'),
                Text('Tuổi: ${appointment['patient_age']}'),
                Text('Cân nặng: ${appointment['patient_weight']} kg'),
                Text('Địa chỉ: ${appointment['patient_address']}'),
                Text('Mô tả: ${appointment['patient_description']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
