import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/appointments.dart';
import '../models/doctor.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'medical_app.db');
    await deleteDatabase(path);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        role TEXT NOT NULL,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE doctors(
        doctor_id INTEGER PRIMARY KEY AUTOINCREMENT,
        id INTEGER,
        name TEXT NOT NULL,
        specialty TEXT NOT NULL,
        years_of_experience INTEGER NOT NULL,
        description TEXT,
        status INTEGER NOT NULL,
        FOREIGN KEY (id) REFERENCES users (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE patients(
        patient_id INTEGER PRIMARY KEY AUTOINCREMENT,
        id INTEGER,
        name TEXT NOT NULL,
        age INTEGER NOT NULL,
        weight REAL NOT NULL,
        address TEXT NOT NULL,
        disease_id INTEGER,
        description TEXT,
        FOREIGN KEY (id) REFERENCES users (id),
        FOREIGN KEY (disease_id) REFERENCES diseases (id)
      )
    ''');

    await db.execute('''
    CREATE TABLE appointments(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      doctor_id INTEGER,
      patient_id INTEGER,
      date_time TEXT NOT NULL,
      status TEXT NOT NULL,
      FOREIGN KEY (doctor_id) REFERENCES doctors (doctor_id),
      FOREIGN KEY (patient_id) REFERENCES patients (patient_id)
    )
  ''');

    await db.execute('''
      CREATE TABLE diseases(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT
      )
    ''');
  }

  // CRUD operations for each model will go here
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  Future<int> insertAppointment(Map<String, dynamic> appointmentData) async {
    final db = await database;
    return await db.insert('appointments', appointmentData);
  }

  Future<int> insertDisease(Map<String, dynamic> diseaseData) async {
    final db = await database;
    return await db.insert('diseases', diseaseData);
  }

  // Example for User:
  Future<int> insertUser(Map<String, dynamic> userData) async {
    final db = await database;
    return await db.insert('users', userData);
  }

  Future<int> insertDoctor(Map<String, dynamic> doctorData) async {
    final db = await database;
    return await db.insert('doctors', doctorData);
  }

  Future<int> insertPatient(Map<String, dynamic> patientData) async {
    final db = await database;
    return await db.insert('patients', patientData);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> update(String table, Map<String, dynamic> row, String whereClause,
      List<dynamic> whereArgs) async {
    Database db = await instance.database;
    return await db.update(table, row,
        where: whereClause, whereArgs: whereArgs);
  }

  Future<int> delete(
      String table, String whereClause, List<dynamic> whereArgs) async {
    Database db = await instance.database;
    return await db.delete(table, where: whereClause, whereArgs: whereArgs);
  }

  Future<Map<String, dynamic>?> getPatientProfile(int userId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(
      'patients',
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<List<Map<String, dynamic>>> getPatientAppointments(
      int patientId) async {
    Database db = await instance.database;
    return await db.rawQuery('''
    SELECT a.*, d.name as doctor_name
    FROM appointments a
    JOIN doctors d ON a.doctor_id = d.doctor_id
    WHERE a.patient_id = ?
  ''', [patientId]);
  }

  Future<Appointment?> getAppointmentById(int id) async {
    final db = await database;

    final List<Map<String, dynamic>> result =
        await db.query('appointments', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return Appointment.fromMap(result.first);
    }
    return null;
  }

  Future<Map<String, dynamic>?> getDoctorDetails(int doctorId) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> result = await db.query(
        'doctors',
        where: 'doctor_id = ?',
        whereArgs: [doctorId],
      );
      print('Query result: $result'); // Thêm log để kiểm tra kết quả truy vấn
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      print('Error getting doctor details: $e');
      return null;
    }
  }

  // Thêm phương thức getDisease
  Future<Map<String, dynamic>?> getDisease(int diseaseId) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> result = await db.query(
        'diseases',
        where: 'id = ?',
        whereArgs: [diseaseId],
        limit: 1,
      );
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      print('Error getting disease: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getDoctorAppointments(int doctorId) async {
    final db = await database;
    return await db.rawQuery('''
    SELECT a.*, p.name as patient_name
    FROM appointments a
    JOIN patients p ON a.patient_id = p.patient_id
    WHERE a.doctor_id = ?
  ''', [doctorId]);
  }

  Future<Doctor?> getDoctorById(int doctorId) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'doctors',
      where: 'doctor_id = ?',
      whereArgs: [doctorId],
    );

    if (result.isNotEmpty) {
      // Chuyển đổi dữ liệu từ QueryRow sang Doctor bằng phương thức fromMap
      return Doctor.fromMap(result.first);
    }
    return null;
  }

  // Hàm lấy chi tiết cuộc hẹn từ bảng Appointment
  Future<List<Map<String, dynamic>>> getAppointments(int appointmentId) async {
    final db = await instance.database;

    // Thêm print để debug
    print('Querying appointment with ID: $appointmentId');

    final result = await db.rawQuery('''
    SELECT 
      appointments.*,
      doctors.name,
      doctors.specialty,
      doctors.years_of_experience,
      doctors.status as doctor_status,
      patients.name as patient_name,
      patients.age as patient_age,
      patients.weight as patient_weight,
      patients.address as patient_address,
      patients.disease_id as patient_diseaseId,
      patients.description as patient_description
    FROM appointments
    JOIN doctors ON appointments.doctor_id = doctors.doctor_id
    JOIN patients ON appointments.patient_id = patients.patient_id
    WHERE appointments.id = ?
  ''', [appointmentId]);

    // Thêm print để debug
    print('Query result: $result');

    return result;
  }
}
