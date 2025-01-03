import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/databaseHelper.dart';
import '../database/showData.dart';
import '../providers/auth_provider.dart';
import 'appointmentDetail.dart';
import 'doctor_profile.dart';
import 'login_form.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({Key? key}) : super(key: key);

  @override
  _DoctorHomeState createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  // Controllers và biến trạng thái
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0; // Index cho bottom navigation
  String _searchQuery = ''; // Query tìm kiếm bệnh nhân
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
              _buildInfoRow(Icons.person, 'Name', patient['name']),
              _buildInfoRow(Icons.cake, 'Age', '${patient['age']}'),
              _buildInfoRow(
                  Icons.monitor_weight, 'Weight', '${patient['weight']} kg'),
              _buildInfoRow(Icons.location_on, 'Address', patient['address']),
              // Nút đặt lịch khám
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      _scheduleAppointment(context, patient['patient_id']),
                  style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(12)),
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blueAccent),
          SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Xử lý đặt lịch khám
  Future<void> _scheduleAppointment(BuildContext context, int patientId) async {
    final doctorId = Provider.of<AuthProvider>(context, listen: false).userId;
    final result = await showDialog<DateTime>(
      context: context,
      builder: (context) => _DateTimePickerDialog(), //chọn time
    );

    if (result != null) {
      await DatabaseHelper.instance.insert('appointments', {
        'doctor_id': doctorId,
        'patient_id': patientId,
        'date_time': result.toIso8601String(),
        'status': 'Đang chờ...',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã đặt lịch hẹn thành công!')),
      );
    }
  }

  // Xử lý chuyển tab
  void _onTabChanged(int index) {
    setState(() => _selectedIndex = index);
    // TODO: Implement chuyển tab
  }

//chuyển tab
  Widget _getTabContent(int index) {
    final doctorId = Provider.of<AuthProvider>(context, listen: false).userId;
    switch (index) {
      case 0: // Tab Bệnh nhân
        showData('patients'); //check dữ liệu từ bảng vào console
        return _patientsTab();
      case 1: // Tab Lịch khám
        print('=> Doctor ID: $doctorId');
        showData('appointments');
        return _AppointmentsTab();
      case 2: // Tab Hồ sơ
        showData('doctors');
        print('=> Doctor ID: $doctorId');

        if (doctorId != null) {
          // Trả về DoctorProfilePage với doctorId từ AuthProvider
          return DoctorProfilePage();
        } else {
          // Xử lý khi không tìm thấy doctorId (có thể hiển thị thông báo lỗi)
          return Center(child: Text('Không tìm thấy thông tin bác sĩ.'));
        }
      default:
        return _patientsTab();
    }
  }

  // Tab Hồ sơ
  Widget _profileTab() {
    final doctor = Provider.of<AuthProvider>(context).currentUser;
    return Center(
      child: Text('Welcome\nDoctor.${doctor?.name}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý bệnh nhân'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Đăng xuất',
          ),
        ],
      ),
      body: _getTabContent(_selectedIndex), // Hiển thị nội dung của tab
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabChanged,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Bệnh nhân',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Lịch khám',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Hồ sơ',
          ),
        ],
      ),
    );
  }

  Widget _patientsTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper.instance.queryAllRows('patients'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerEffect(); // Show shimmer effect while loading
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
    );
  }

// Shimmer effect for loading state
  Widget _buildShimmerEffect() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 6, // Number of shimmer placeholders
      itemBuilder: (context, index) {
        return Card(
          elevation: 6,
          margin: const EdgeInsets.only(bottom: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey[200]!,
                  Colors.grey[100]!,
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
                    backgroundColor: Colors.grey[300],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120,
                          height: 18,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 80,
                          height: 14,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 150,
                          height: 14,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DateTimePickerDialog extends StatefulWidget {
  @override
  _DateTimePickerDialogState createState() => _DateTimePickerDialogState();
}

class _DateTimePickerDialogState extends State<_DateTimePickerDialog> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Chọn thời gian khám'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
              );
              if (date != null) {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  setState(() {
                    selectedDate = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    );
                  });
                }
              }
            },
            child: Text('Chọn thời gian'),
          ),
          if (selectedDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Thời gian đã chọn: ${selectedDate.toString()}',
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: selectedDate == null
              ? null
              : () => Navigator.pop(context, selectedDate),
          child: Text('Xác nhận'),
        ),
      ],
    );
  }
}

class _AppointmentsTab extends StatefulWidget {
  @override
  _AppointmentsTabState createState() => _AppointmentsTabState();
}

class _AppointmentsTabState extends State<_AppointmentsTab> {
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
                                  color: _getStatusColor(appointment['status']),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Đã khám':
        return Colors.green;
      case 'đã khám':
        return Colors.green;
      case 'Đang chờ...':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
