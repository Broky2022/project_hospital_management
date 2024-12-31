import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/databaseHelper.dart';
import '../providers/auth_provider.dart';

class PatientProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context).userId;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hồ sơ bệnh nhân'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit profile screen
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _getPatientProfile(userId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Không tìm thấy thông tin'));
          }

          final patient = snapshot.data!;
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Avatar và tên
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.person, size: 50),
                      ),
                      SizedBox(height: 16),
                      Text(
                        patient['name'],
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Thông tin cơ bản
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thông tin cá nhân',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Divider(),
                        _buildInfoTile(
                          Icons.email,
                          'Email',
                          patient['email'],
                        ),
                        _buildInfoTile(
                          Icons.cake,
                          'Tuổi',
                          '${patient['age']} tuổi',
                        ),
                        _buildInfoTile(
                          Icons.monitor_weight,
                          'Cân nặng',
                          '${patient['weight']} kg',
                        ),
                        _buildInfoTile(
                          Icons.location_on,
                          'Địa chỉ',
                          patient['address'],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Thông tin bệnh
                if (patient['disease_id'] != null)
                  FutureBuilder<Map<String, dynamic>?>(
                    future: _getDisease(patient['disease_id']),
                    builder: (context, diseaseSnapshot) {
                      if (!diseaseSnapshot.hasData) {
                        return SizedBox.shrink();
                      }

                      final disease = diseaseSnapshot.data!;
                      return Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Thông tin bệnh',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Divider(),
                              Text('Tên bệnh: ${disease['name']}'),
                              SizedBox(height: 8),
                              Text('Mô tả: ${disease['description']}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      dense: true,
    );
  }

  Future<Map<String, dynamic>?> _getPatientProfile(int userId) async {
    final db = DatabaseHelper.instance;
    return await db.getPatientProfile(userId);
  }

  Future<Map<String, dynamic>?> _getDisease(int diseaseId) async {
    final db = DatabaseHelper.instance;
    return await db.getDisease(diseaseId);
  }
}
