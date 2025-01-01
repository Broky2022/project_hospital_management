import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/databaseHelper.dart';
import '../providers/auth_provider.dart';

class DoctorProfilePage extends StatefulWidget {
  final int doctorId;

  const DoctorProfilePage({Key? key, required this.doctorId}) : super(key: key);

  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  late Future<Map<String, dynamic>?> _doctorDetails;

  @override
  void initState() {
    super.initState();
    // Khởi tạo Future để lấy thông tin bác sĩ
    _doctorDetails = DatabaseHelper.instance.getDoctorDetails(widget.doctorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ Bác sĩ'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _doctorDetails, // Sử dụng _doctorDetails đã khởi tạo
        builder: (context, snapshot) {
          print('Snapshot state: ${snapshot.connectionState}');
          print('Snapshot data: ${snapshot.data}');
          print('Snapshot error: ${snapshot.error}');

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Không tìm thấy thông tin bác sĩ.'));
          }

          final doctor = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tên: ${doctor['name']}'),
                Text('Chuyên khoa: ${doctor['specialty']}'),
                Text('Số năm kinh nghiệm: ${doctor['years_of_experience']}'),
                Text(
                    'Trạng thái: ${doctor['status'] == 1 ? 'Đang hoạt động' : 'Không hoạt động'}'),
                Text('Mô tả: ${doctor['description'] ?? 'Không có mô tả'}'),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget để hiển thị thông tin dạng hàng
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
