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
    // Fetch appointment details
    _appointmentDetails =
        DatabaseHelper.instance.getAppointments(widget.appointmentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),
        centerTitle: true,
        backgroundColor: Colors.teal, // Custom app bar color
        elevation: 4,
      ),
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor Details Section
                Card(
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
                          'Doctor Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        SizedBox(height: 10),
                        _buildDetailRow('Name', appointment['name'] ?? 'N/A'),
                        _buildDetailRow(
                            'Specialty', appointment['specialty'] ?? 'N/A'),
                        _buildDetailRow(
                            'Years of Experience',
                            appointment['yearsOfExperience']?.toString() ??
                                'N/A'),
                        _buildDetailRow('Status',
                            appointment['doctor_status']?.toString() ?? 'N/A'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Patient Details Section
                Card(
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
                          'Patient Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        SizedBox(height: 10),
                        _buildDetailRow(
                            'Name', appointment['patient_name'] ?? 'N/A'),
                        _buildDetailRow('Age',
                            appointment['patient_age']?.toString() ?? 'N/A'),
                        _buildDetailRow('Weight',
                            appointment['patient_weight']?.toString() ?? 'N/A'),
                        _buildDetailRow(
                            'Address', appointment['patient_address'] ?? 'N/A'),
                        _buildDetailRow(
                            'Disease ID',
                            appointment['patient_diseaseId']?.toString() ??
                                'N/A'),
                        _buildDetailRow('Description',
                            appointment['patient_description'] ?? 'N/A'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper method to build a detail row
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
