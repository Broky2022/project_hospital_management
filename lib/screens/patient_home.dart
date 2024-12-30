import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/databasehelper.dart';
import '../providers/auth_provider.dart';

class PatientHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context).userId;

    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: FutureBuilder<Map<String, dynamic>?>(
                  future: DatabaseHelper.instance.getPatientProfile(userId!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final profile = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Profile',
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                          SizedBox(height: 8),
                          Text('Name: ${profile['name']}'),
                          Text('Age: ${profile['age']}'),
                          Text('Weight: ${profile['weight']} kg'),
                          Text('Address: ${profile['address']}'),
                        ],
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            Text('My Appointments',
                style: Theme.of(context).textTheme.headlineMedium),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: DatabaseHelper.instance.getPatientAppointments(userId!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final appointment = snapshot.data![index];
                      return Card(
                        child: ListTile(
                          title: Text('Dr. ${appointment['doctor_name']}'),
                          subtitle: Text('Date: ${appointment['date_time']}'),
                          trailing: Text(appointment['status']),
                          onTap: () => _showDoctorDetails(
                              context, appointment['doctor_id']),
                        ),
                      );
                    },
                  );
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDoctorDetails(BuildContext context, int doctorId) {
    // Implementation for showing doctor details
  }
}
