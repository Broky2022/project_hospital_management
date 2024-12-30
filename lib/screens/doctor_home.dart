import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/databasehelper.dart';
import '../providers/auth_provider.dart';

class DoctorHome extends StatefulWidget {
  @override
  _DoctorHomeState createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search patients...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: DatabaseHelper.instance.queryAllRows('patients'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final patient = snapshot.data![index];
                      return ListTile(
                        title: Text(patient['name']),
                        subtitle: Text('Age: ${patient['age']}'),
                        onTap: () => _showPatientDetails(context, patient),
                      );
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Patients'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  void _showPatientDetails(BuildContext context, Map<String, dynamic> patient) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Patient Details',
                style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 8),
            Text('Name: ${patient['name']}'),
            Text('Age: ${patient['age']}'),
            Text('Weight: ${patient['weight']} kg'),
            Text('Address: ${patient['address']}'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  _scheduleAppointment(context, patient['patient_id']),
              child: Text('Schedule Appointment'),
            ),
          ],
        ),
      ),
    );
  }

  void _scheduleAppointment(BuildContext context, int patientId) {
    // Implementation for scheduling appointment
  }
}
