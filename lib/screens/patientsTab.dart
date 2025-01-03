import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../database/databaseHelper.dart';
import '../utils/config.dart';
import 'dateTimePickerDialog.dart';

Widget patientsTab() {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: DatabaseHelper.instance.queryAllRows('patients'),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return buildShimmerEffect(); // Show shimmer effect while loading
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
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          final patient = snapshot.data![index];
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
                onTap: () => _showPatientDetails(context, patient),
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
                          backgroundColor: Colors.blueAccent.withOpacity(0.2),
                          child: const Icon(Icons.person,
                              color: Colors.blueAccent),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                      size: 16, color: Colors.grey[600]),
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
                                      size: 16, color: Colors.grey[600]),
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
                        const Icon(Icons.arrow_forward_ios, color: Colors.grey),
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
  );
}

// Hiển thị chi tiết bệnh nhân
void _showPatientDetails(BuildContext context, Map<String, dynamic> patient) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Cho phép scroll
    builder: (context) => SingleChildScrollView(
      // Wrap bằng SingleChildScrollView
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
            Text('Patient Details',
                style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 8),
            buildInfoRow(Icons.person, 'Name', patient['name']),
            buildInfoRow(Icons.cake, 'Age', '${patient['age']}'),
            buildInfoRow(
                Icons.monitor_weight, 'Weight', '${patient['weight']} kg'),
            buildInfoRow(Icons.location_on, 'Address', patient['address']),
            // Nút đặt lịch khám
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    scheduleAppointment(context, patient['patient_id']),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 8),
                    Text('Đặt lịch khám'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16), // Thêm padding bottom
          ],
        ),
      ),
    ),
  );
}
