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
    // Get doctorId from AuthProvider
    final doctorId = Provider.of<AuthProvider>(context, listen: false).userId;
    if (doctorId != null) {
      // Initialize Future to get doctor details
      _doctorDetails = DatabaseHelper.instance.getDoctorDetails(doctorId);
    } else {
      // If doctorId not found, handle error (or display a message)
      _doctorDetails = Future.value(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ Bác sĩ'),
        centerTitle: true,
        backgroundColor: Colors.teal, // Customize app bar color
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _doctorDetails,
        builder: (context, snapshot) {
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

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Profile Picture
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      doctor['image'] != null && doctor['image'].isNotEmpty
                          ? AssetImage(doctor['image'])
                          : null,
                  child: doctor['image'] != null && doctor['image'].isNotEmpty
                      ? null
                      : Text(
                          doctor['name'][0],
                          style: TextStyle(fontSize: 48, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Doctor Name
              Text(
                doctor['name'],
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Specialty
              Text(
                doctor['specialty'],
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              // Details Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Years of Experience
                      ListTile(
                        leading: Icon(Icons.access_time, color: Colors.teal),
                        title: Text(
                          'Kinh nghiệm:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          doctor['years_of_experience'].toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),

                      // Status
                      ListTile(
                        leading: Icon(Icons.account_circle, color: Colors.teal),
                        title: Text(
                          'Trạng thái:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          doctor['status'] == 1
                              ? 'Hoạt động'
                              : 'Không hoạt động',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),

                      // Description
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mô tả:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            child: Text(
                              doctor['description'] ?? 'Không có mô tả',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
