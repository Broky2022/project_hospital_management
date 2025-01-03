import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/databaseHelper.dart';
import '../providers/auth_provider.dart';
import '../utils/config.dart';
import 'appointmentDetail.dart';

class AppointmentsTab extends StatefulWidget {
  @override
  _AppointmentsTabState createState() => _AppointmentsTabState();
}

class _AppointmentsTabState extends State<AppointmentsTab> {
  late Future<List<Map<String, dynamic>>> _appointmentsFuture;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  void _loadAppointments() {
    final doctorId = Provider.of<AuthProvider>(context, listen: false).userId;
    _appointmentsFuture =
        DatabaseHelper.instance.getDoctorAppointments(doctorId!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _appointmentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'Không có lịch hẹn nào',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final appointment = snapshot.data![index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentDetailPage(
                          appointmentId: appointment['id'],
                        ),
                      ),
                    );

                    // Tải lại danh sách khi quay về từ AppointmentDetailPage
                    setState(() {
                      _loadAppointments();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blueAccent.withOpacity(0.2),
                          child: Icon(Icons.person, color: Colors.blueAccent),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appointment['patient_name'] ?? 'Unknown',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Thời gian: ${appointment['date_time']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Trạng thái: ${appointment['status']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: getStatusColor(appointment['status']),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, color: Colors.grey),
                      ],
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
}
