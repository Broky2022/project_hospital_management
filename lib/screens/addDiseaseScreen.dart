import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';
import '../database/databaseHelper.dart';

class AddDiseaseScreen extends StatefulWidget {
  @override
  _AddDiseaseScreenState createState() => _AddDiseaseScreenState();
}

class _AddDiseaseScreenState extends State<AddDiseaseScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Hàm lưu bệnh vào cơ sở dữ liệu
  void _addDisease() async {
    final String name = _nameController.text.trim();
    final String description = _descriptionController.text.trim();

    if (name.isNotEmpty) {
      final db = await DatabaseHelper.instance.database;

      // Thêm bệnh vào bảng diseases
      await db.insert(
        'diseases',
        {'name': name, 'description': description},
        conflictAlgorithm: ConflictAlgorithm
            .replace, // Chọn phương thức thay thế nếu trùng lặp
      );

      // Sau khi thêm xong, đóng màn hình và quay lại
      Navigator.pop(context);
    } else {
      // Hiển thị thông báo nếu tên bệnh không được nhập
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng nhập tên bệnh'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Bệnh',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nhập thông tin bệnh:',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 16),
              // Trường nhập tên bệnh
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Tên bệnh',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.medical_services),
                ),
              ),
              SizedBox(height: 16),
              // Trường nhập mô tả bệnh
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Mô tả bệnh',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
              ),
              SizedBox(height: 24),
              // Nút lưu bệnh
              ElevatedButton(
                onPressed: _addDisease,
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.save),
                    SizedBox(width: 8),
                    Text('Lưu bệnh'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
