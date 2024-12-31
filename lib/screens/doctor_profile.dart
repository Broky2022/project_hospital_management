import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/databaseHelper.dart';
import '../providers/auth_provider.dart';

class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({Key? key}) : super(key: key);

  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  late Future<Map<String, dynamic>?> _doctorDetails;

  @override
  void initState() {
    super.initState();
    // Lấy doctorId từ AuthProvider
    final doctorId = Provider.of<AuthProvider>(context, listen: false).userId;
    if (doctorId != null) {
      // Khởi tạo Future để lấy thông tin bác sĩ
      _doctorDetails = DatabaseHelper.instance.getDoctorDetails(doctorId);
    } else {
      // Nếu không tìm thấy doctorId, xử lý lỗi (hoặc có thể hiển thị thông báo)
      _doctorDetails = Future.value(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ Bác sĩ'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _doctorDetails,
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
                _buildInfoRow('Doctor', doctor['name']),
                _buildInfoRow('Specialty', doctor['specialty']),
                _buildInfoRow('Years of Experience',
                    doctor['years_of_experience'].toString()),
                _buildInfoRow(
                    'Status', doctor['status'] == 1 ? 'Active' : 'Inactive'),
                _buildInfoRow(
                    'Description', doctor['description'] ?? 'No description'),
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
