import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../database/databaseHelper.dart';
import '../utils/config.dart';
import 'dateTimePickerDialog.dart';

class PatientsTab extends StatefulWidget {
  @override
  _PatientsTabState createState() => _PatientsTabState();
}

class _PatientsTabState extends State<PatientsTab> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _patients = [];
  List<Map<String, dynamic>> _filteredPatients = [];

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  // Tải dữ liệu bệnh nhân từ cơ sở dữ liệu
  Future<void> _loadPatients() async {
    final data = await DatabaseHelper.instance.queryAllRows('patients');
    setState(() {
      _patients = data;
      _filteredPatients = data; // Khởi tạo danh sách bệnh nhân hiển thị
    });
  }

  // Hàm tìm kiếm
  void _searchPatient(String query) {
    final results = _patients.where((patient) {
      final name = patient['name'].toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredPatients = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            onChanged: _searchPatient,
            decoration: InputDecoration(
              labelText: 'Tìm kiếm bệnh nhân theo tên',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        Expanded(
          child: _filteredPatients.isEmpty
              ? Center(child: Text('Không tìm thấy bệnh nhân'))
              : FutureBuilder<List<Map<String, dynamic>>>(
                  future: DatabaseHelper.instance.queryAllRows('patients'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return buildShimmerEffect(); // Effect khi tải dữ liệu
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Có lỗi xảy ra',
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'Không có bệnh nhân',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _filteredPatients.length,
                      itemBuilder: (context, index) {
                        final patient = _filteredPatients[index];
                        return AnimatedOpacity(
                          opacity: 1.0,
                          duration: const Duration(milliseconds: 500),
                          child: Card(
                            elevation: 6,
                            margin: const EdgeInsets.only(bottom: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () =>
                                  _showPatientDetails(context, patient),
                              splashColor: Colors.blueAccent.withOpacity(0.1),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blueAccent.withOpacity(0.1),
                                      Colors.white,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor:
                                            Colors.blueAccent.withOpacity(0.2),
                                        child: const Icon(Icons.person,
                                            color: Colors.blueAccent),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              patient['name'] ?? 'Không rõ tên',
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(Icons.cake,
                                                    size: 16,
                                                    color: Colors.grey[600]),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'Tuổi: ${patient['age'] ?? 'Không rõ'}',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(Icons.location_on,
                                                    size: 16,
                                                    color: Colors.grey[600]),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'Địa chỉ: ${patient['address'] ?? 'Không rõ'}',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.arrow_forward_ios,
                                          color: Colors.grey),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  // Hiển thị chi tiết bệnh nhân
  void _showPatientDetails(BuildContext context, Map<String, dynamic> patient) {
    TextEditingController descriptionController = TextEditingController(
      text: patient['description'] ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Tránh keyboard
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Chi tiết bệnh nhân',
                  style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(height: 8),
              buildInfoRow(Icons.person, 'Tên', patient['name']),
              buildInfoRow(Icons.cake, 'Tuổi', '${patient['age']}'),
              buildInfoRow(
                  Icons.monitor_weight, 'Cân nặng', '${patient['weight']} kg'),
              buildInfoRow(Icons.location_on, 'Địa chỉ', patient['address']),
              SizedBox(height: 16),
              Text('Mô tả:',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nhập mô tả bệnh nhân...',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  updatePatientDescription(
                      patient['patient_id'], descriptionController.text);
                  Navigator.pop(context);
                },
                child: Text('Lưu thay đổi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm cập nhật mô tả trong cơ sở dữ liệu
  void updatePatientDescription(int patientId, String description) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'patients',
      {'description': description},
      where: 'patient_id = ?',
      whereArgs: [patientId],
    );
  }

  // Hàm xây dựng dòng thông tin
  Widget buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blueAccent),
        SizedBox(width: 8),
        Text(
          '$label: $value',
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
        ),
      ],
    );
  }
}
