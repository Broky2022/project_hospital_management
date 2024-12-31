import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/databaseHelper.dart';
import '../providers/auth_provider.dart';
import 'login_form.dart';

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
                  style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: 8),
              Text('Name: ${patient['name']}'),
              Text('Age: ${patient['age']}'),
              Text('Weight: ${patient['weight']} kg'),
              Text('Address: ${patient['address']}'),
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

  // Xử lý đặt lịch khám
  Future<void> _scheduleAppointment(BuildContext context, int patientId) async {
    final doctorId = Provider.of<AuthProvider>(context, listen: false).userId;
    final result = await showDialog<DateTime>(
      context: context,
      builder: (context) => _DateTimePickerDialog(),
    );

    if (result != null) {
      await DatabaseHelper.instance.insert('appointments', {
        'doctor_id': doctorId,
        'patient_id': patientId,
        'date_time': result.toIso8601String(),
        'status': 'Đã đặt',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý bệnh nhân'),
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
      body: Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm bệnh nhân...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),

          // Danh sách bệnh nhân
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: DatabaseHelper.instance.queryAllRows('patients'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Đã có lỗi xảy ra\nVui lòng thử lại',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.person_search,
                            size: 48, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'Không tìm thấy bệnh nhân',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  );
                }

                // Lọc danh sách theo search query
                final patients = snapshot.data!.where((patient) {
                  return patient['name']
                      .toString()
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase());
                }).toList();

                return ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: patients.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final patient = patients[index];
                    return ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(
                        patient['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Tuổi: ${patient['age']} • Cân nặng: ${patient['weight']} kg',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showPatientDetails(context, patient),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
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

class _AppointmentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final doctorId = Provider.of<AuthProvider>(context).userId;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper.instance.getDoctorAppointments(doctorId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Không có lịch hẹn nào'));
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final appointment = snapshot.data![index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text(appointment['patient_name'] ?? 'Unknown'),
                subtitle: Text('Thời gian: ${appointment['date_time']}\n'
                    'Trạng thái: ${appointment['status']}'),
                isThreeLine: true,
              ),
            );
          },
        );
      },
    );
  }
}
