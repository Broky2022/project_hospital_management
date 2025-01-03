import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/databaseHelper.dart';
import '../providers/auth_provider.dart';
import 'login_form.dart';
import '../utils/config.dart';

class PatientHome extends StatefulWidget {
  const PatientHome({Key? key}) : super(key: key);

  @override
  _PatientHomeState createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  // Biến trạng thái
  bool _isLoading = false;

  // Xử lý đăng xuất
  Future<void> _handleLogout() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<AuthProvider>(context, listen: false).logout();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng xuất thất bại. Vui lòng thử lại.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Hiển thị thông tin bác sĩ
  void _showDoctorDetails(BuildContext context, int doctorId) async {
    try {
      final doctor = await DatabaseHelper.instance.getDoctorDetails(doctorId);
      if (mounted && doctor != null) {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Thông tin bác sĩ',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text('${doctor['name']}'),
                  subtitle: Text('Chuyên khoa: ${doctor['specialty']}'),
                ),
                ListTile(
                  leading: const Icon(Icons.work),
                  title: const Text('Kinh nghiệm'),
                  subtitle: Text('${doctor['years_of_experience']} năm'),
                ),
                if (doctor['description'] != null) ...[
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      doctor['description'],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể tải thông tin bác sĩ'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Format ngày giờ
  String _formatDateTime(String dateTime) {
    final dt = DateTime.parse(dateTime);
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context).userId;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin bệnh nhân'),
        centerTitle: true,
        actions: [
          if (_isLoading)
            const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _handleLogout,
              tooltip: 'Đăng xuất',
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: userId == null
          ? const Center(child: Text('Vui lòng đăng nhập lại'))
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {}); // Refresh data
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thông tin cá nhân
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: FutureBuilder<Map<String, dynamic>?>(
                          future:
                              DatabaseHelper.instance.getPatientProfile(userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError || !snapshot.hasData) {
                              return const Center(
                                child: Text('Không thể tải thông tin'),
                              );
                            }

                            final profile = snapshot.data!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Hồ sơ bệnh nhân',
                                      style: theme.textTheme.titleLarge,
                                    ),
                                    // IconButton(
                                    //   icon: const Icon(Icons.edit),
                                    //   onPressed: () {
                                    //     // TODO: Implement edit profile
                                    //   },
                                    // ),
                                  ],
                                ),
                                const Divider(),
                                ListTile(
                                  leading: const Icon(Icons.person),
                                  title: const Text('Họ tên'),
                                  subtitle: Text(profile['name']),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.cake),
                                  title: const Text('Tuổi'),
                                  subtitle: Text('${profile['age']} tuổi'),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.monitor_weight),
                                  title: const Text('Cân nặng'),
                                  subtitle: Text('${profile['weight']} kg'),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.location_on),
                                  title: const Text('Địa chỉ'),
                                  subtitle: Text(profile['address']),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),

                    // Danh sách lịch hẹn
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Lịch hẹn khám bệnh',
                            style: theme.textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: DatabaseHelper.instance
                          .getPatientAppointments(userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Không thể tải danh sách lịch hẹn'),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Chưa có lịch hẹn nào',
                                  style: theme.textTheme.titleMedium,
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final appointment = snapshot.data![index];
                            return Card(
                              elevation: 1,
                              margin: const EdgeInsets.only(bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.medical_services),
                                ),
                                title: Text(
                                  '${appointment['doctor_name']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  _formatDateTime(appointment['date_time']),
                                ),
                                trailing: Chip(
                                  label: Text(
                                    appointment['status'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor:
                                      getStatusColor(appointment['status']),
                                ),
                                onTap: () => _showDoctorDetails(
                                  context,
                                  appointment['doctor_id'],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
