import 'package:flutter/material.dart';
import '../database/databaseHelper.dart';
import '../utils/config.dart';

class AppointmentDetailPage extends StatefulWidget {
  final int appointmentId;

  AppointmentDetailPage({required this.appointmentId});

  @override
  _AppointmentDetailPageState createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  bool isButtonDisabled = false;

  // Hàm để lấy tên bệnh từ bảng diseases dựa trên disease_id
  Future<String> _getDiseaseName(int? diseaseId) async {
    if (diseaseId == null) {
      return 'Chưa xác định';
    }

    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'diseases',
      columns: ['name'],
      where: 'id = ?',
      whereArgs: [diseaseId],
    );

    if (result.isNotEmpty) {
      return result.first['name'] as String;
    } else {
      return 'Chưa xác định';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết cuộc hẹn', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future:
            DatabaseHelper.instance.getAppointmentsById(widget.appointmentId),
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

          final appointment = snapshot.data!.first;
          isButtonDisabled = appointment['appointment_status'] == 'Đã khám';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppointmentCard(appointment),
                SizedBox(height: 16),
                _buildDoctorCard(appointment),
                SizedBox(height: 16),
                _buildPatientCard(appointment),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isButtonDisabled
                            ? null
                            : () => _updateAppointmentStatus(appointment),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: isButtonDisabled
                              ? Colors.grey
                              : Colors.blueAccent,
                        ),
                        child: Text(
                          'Đã khám',
                          style: TextStyle(
                              color: isButtonDisabled
                                  ? Colors.white
                                  : Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _confirmDeleteAppointment(),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.redAccent,
                        ),
                        child: Text('Xóa'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin cuộc hẹn',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8),
            _buildInfoRow('Mã cuộc hẹn', appointment['appointment_id']),
            _buildInfoRow('Thời gian', appointment['date_time']),
            _buildInfoRow('Trạng thái', appointment['appointment_status'],
                color: getStatusColor(appointment['appointment_status'])),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(Map<String, dynamic> appointment) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin bác sĩ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8),
            _buildInfoRow('Tên bác sĩ', appointment['doctor_name']),
            _buildInfoRow('Chuyên môn', appointment['doctor_specialty']),
            _buildInfoRow('Kinh nghiệm',
                '${appointment['doctor_years_of_experience']} năm'),
            _buildInfoRow('Mô tả', appointment['doctor_description']),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard(Map<String, dynamic> appointment) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin bệnh nhân',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8),
            _buildInfoRow('Tên bệnh nhân', appointment['patient_name']),
            _buildInfoRow('Tuổi', appointment['patient_age']),
            _buildInfoRow('Cân nặng', '${appointment['patient_weight']} kg'),
            _buildInfoRow('Địa chỉ', appointment['patient_address']),
            // Sử dụng FutureBuilder để hiển thị tên bệnh
            FutureBuilder<String>(
              future: _getDiseaseName(appointment['patient_disease_id']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildInfoRow('Bệnh lý', 'Đang tải...');
                } else if (snapshot.hasError) {
                  return _buildInfoRow('Bệnh lý', 'Lỗi: ${snapshot.error}');
                } else {
                  return _buildInfoRow(
                      'Bệnh lý', snapshot.data ?? 'Chưa xác định');
                }
              },
            ),
            _buildInfoRow('Mô tả', appointment['patient_description']),
          ],
        ),
      ),
    );
  }

  void _updateAppointmentStatus(Map<String, dynamic> appointment) async {
    setState(() {
      isButtonDisabled = true;
    });

    bool success = await DatabaseHelper.instance
        .updateAppointmentStatus(widget.appointmentId, 'Đã khám');

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Trạng thái đã cập nhật thành công')),
      );
      setState(() {});
    } else {
      setState(() {
        isButtonDisabled = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật trạng thái thất bại')),
      );
    }
  }

  void _confirmDeleteAppointment() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận'),
          content: Text('Bạn có chắc chắn muốn xóa cuộc hẹn này?'),
          actions: [
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Xóa'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteAppointment();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAppointment() async {
    bool success =
        await DatabaseHelper.instance.deleteAppointment(widget.appointmentId);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cuộc hẹn đã được xóa thành công')),
      );
      Navigator.of(context)
          .pop(true); // Trả về `true` để báo hiệu xóa thành công
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xóa cuộc hẹn thất bại')),
      );
    }
  }

  Widget _buildInfoRow(String label, dynamic value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: 16,
                color: color ?? Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
