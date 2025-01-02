import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/databaseHelper.dart';
import '../providers/auth_provider.dart';

class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({Key? key}) : super(key: key);

  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  late Future<Map<String, dynamic>?> _doctorDetails;
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  // Controllers for editing
  late TextEditingController _nameController;
  late TextEditingController _specialtyController;
  late TextEditingController _experienceController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _specialtyController = TextEditingController();
    _experienceController = TextEditingController();
    _descriptionController = TextEditingController();

    final doctorId = Provider.of<AuthProvider>(context, listen: false).userId;
    if (doctorId != null) {
      _doctorDetails = DatabaseHelper.instance.getDoctorDetails(doctorId);
      _doctorDetails.then((data) {
        if (data != null) {
          _nameController.text = data['name'] ?? '';
          _specialtyController.text = data['specialty'] ?? '';
          _experienceController.text =
              data['years_of_experience']?.toString() ?? '';
          _descriptionController.text = data['description'] ?? '';
        }
      });
    } else {
      _doctorDetails = Future.value(null);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _experienceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile(
      int doctorId, Map<String, dynamic> currentData) async {
    final updatedData = {
      ...currentData,
      'name': _nameController.text,
      'specialty': _specialtyController.text,
      'years_of_experience': int.tryParse(_experienceController.text) ?? 0,
      'description': _descriptionController.text,
    };

    try {
      await DatabaseHelper.instance.updateDoctorProfile(doctorId, updatedData);
      setState(() {
        _isEditing = false;
        _doctorDetails = DatabaseHelper.instance.getDoctorDetails(doctorId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thành công')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  Widget _buildEditableField(String label, TextEditingController controller,
      {int? maxLines}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng nhập $label';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ Bác sĩ'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        // Ẩn nút back mặc định khi không ở chế độ chỉnh sửa
        automaticallyImplyLeading:
            false, // Thêm dòng này để ẩn nút back mặc định
        // Thêm nút quay lại khi đang trong chế độ chỉnh sửa
        leading: _isEditing
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  // Reset lại các controller về giá trị ban đầu
                  _doctorDetails.then((data) {
                    if (data != null) {
                      _nameController.text = data['name'] ?? '';
                      _specialtyController.text = data['specialty'] ?? '';
                      _experienceController.text =
                          data['years_of_experience']?.toString() ?? '';
                      _descriptionController.text = data['description'] ?? '';
                    }
                  });
                  // Tắt chế độ chỉnh sửa
                  setState(() => _isEditing = false);
                },
              )
            : null,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                if (_formKey.currentState!.validate()) {
                  final doctorId =
                      Provider.of<AuthProvider>(context, listen: false).userId;
                  if (doctorId != null) {
                    _doctorDetails.then((currentData) {
                      if (currentData != null) {
                        _saveProfile(doctorId, currentData);
                      }
                    });
                  }
                }
              } else {
                setState(() => _isEditing = true);
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _doctorDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Không tìm thấy thông tin bác sĩ.'));
          }

          final doctor = snapshot.data!;

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: doctor['image'] != null &&
                                doctor['image'].isNotEmpty
                            ? AssetImage(doctor['image'])
                            : null,
                        child: doctor['image'] != null &&
                                doctor['image'].isNotEmpty
                            ? null
                            : Text(
                                _nameController.text.isNotEmpty
                                    ? _nameController.text[0]
                                    : '',
                                style: TextStyle(
                                    fontSize: 48, color: Colors.white),
                              ),
                      ),
                      if (_isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.teal,
                            radius: 18,
                            child: IconButton(
                              icon: Icon(Icons.camera_alt,
                                  size: 18, color: Colors.white),
                              onPressed: () {
                                // TODO: Implement image upload
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (_isEditing) ...[
                  _buildEditableField('Tên', _nameController),
                  _buildEditableField('Chuyên khoa', _specialtyController),
                  _buildEditableField(
                      'Số năm kinh nghiệm', _experienceController),
                  _buildEditableField('Mô tả', _descriptionController,
                      maxLines: 3),
                ] else ...[
                  Text(
                    doctor['name'],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    doctor['specialty'],
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading:
                                Icon(Icons.access_time, color: Colors.teal),
                            title: Text(
                              'Kinh nghiệm:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              doctor['years_of_experience'].toString(),
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          ListTile(
                            leading:
                                Icon(Icons.account_circle, color: Colors.teal),
                            title: Text(
                              'Trạng thái:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              doctor['status'] == 1
                                  ? 'Hoạt động'
                                  : 'Không hoạt động',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mô tả:',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                child: Text(
                                  doctor['description'] ?? 'Không có mô tả',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
