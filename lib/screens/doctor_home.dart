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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tiêu đề
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Thông tin bệnh nhân',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),

            // Thông tin chi tiết
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Họ tên'),
              subtitle: Text(patient['name']),
            ),
            ListTile(
              leading: const Icon(Icons.cake),
              title: const Text('Tuổi'),
              subtitle: Text('${patient['age']} tuổi'),
            ),
            ListTile(
              leading: const Icon(Icons.monitor_weight),
              title: const Text('Cân nặng'),
              subtitle: Text('${patient['weight']} kg'),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Địa chỉ'),
              subtitle: Text(patient['address']),
            ),

            // Nút đặt lịch khám
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _scheduleAppointment(context, patient['patient_id']),
                icon: const Icon(Icons.calendar_today),
                label: const Text('Đặt lịch khám'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Xử lý đặt lịch khám
  void _scheduleAppointment(BuildContext context, int patientId) {
    // TODO: Implement đặt lịch khám
    Navigator.pop(context); // Đóng modal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng đang được phát triển')),
    );
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
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
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
                        const Icon(Icons.person_search, size: 48, color: Colors.grey),
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onTabChanged,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Bệnh nhân',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Lịch khám',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Hồ sơ',
          ),
        ],
      ),
    );
  }
}