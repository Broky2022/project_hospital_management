import 'package:flutter/material.dart';
import '../database/databaseHelper.dart';

class AppointmentDetailPage extends StatefulWidget {
  final int appointmentId;

  AppointmentDetailPage({required this.appointmentId});

  @override
  _AppointmentDetailPageState createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  late Future<List<Map<String, dynamic>>> _appointmentDetails;

  @override
  void initState() {
    super.initState();
    // Gọi hàm getAppointments từ dataHelper
    _appointmentDetails =
        DatabaseHelper.instance.getAppointments(widget.appointmentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Appointment Details')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _appointmentDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No appointment details found.'));
          }

          final appointment = snapshot.data!.first;

          // Hiển thị thông tin chi tiết cuộc hẹn
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Doctor: ${appointment['doctor_id']} - ${appointment['doctor_description']}'),
                Text('Specialty: ${appointment['specialty']}'),
                Text(
                    'Years of Experience: ${appointment['yearsOfExperience']}'),
                Text('Status: ${appointment['doctor_status']}'),
                SizedBox(height: 20),
                Text('Patient: ${appointment['patient_name']}'),
                Text('Age: ${appointment['patient_age']}'),
                Text('Weight: ${appointment['patient_weight']}'),
                Text('Address: ${appointment['patient_address']}'),
                Text('Disease ID: ${appointment['patient_diseaseId']}'),
                Text(
                    'Patient Description: ${appointment['patient_description']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
