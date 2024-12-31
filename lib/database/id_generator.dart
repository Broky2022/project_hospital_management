import 'package:sqflite/sqflite.dart';
import 'databasehelper.dart';

class IDGenerator {
  static final IDGenerator instance = IDGenerator._init();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  IDGenerator._init();

  Future<String> generateDoctorId() async {
    final db = await _dbHelper.database;
    final result =
        await db.rawQuery('SELECT MAX(doctor_id) as last_id FROM doctors');
    final String? lastId = result.first['last_id'] as String?;

    if (lastId == null) {
      return 'DOC001';
    }

    // Extract the numeric part and increment
    int currentNumber = int.parse(lastId.substring(3));
    currentNumber++;

    // Format new ID with leading zeros
    return 'DOC${currentNumber.toString().padLeft(3, '0')}';
  }

  Future<String> generatePatientId() async {
    final db = await _dbHelper.database;
    final result =
        await db.rawQuery('SELECT MAX(patient_id) as last_id FROM patients');
    final String? lastId = result.first['last_id'] as String?;

    if (lastId == null) {
      return 'PAT001';
    }

    // Extract the numeric part and increment
    int currentNumber = int.parse(lastId.substring(3));
    currentNumber++;

    // Format new ID with leading zeros
    return 'PAT${currentNumber.toString().padLeft(3, '0')}';
  }
}
