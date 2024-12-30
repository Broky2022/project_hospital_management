import 'package:project_hospital_management/models/appointments.dart';
import 'package:project_hospital_management/models/disease.dart';
import 'package:project_hospital_management/models/doctor.dart';
import 'package:project_hospital_management/models/patient.dart';
import 'package:project_hospital_management/models/user.dart';
import 'package:sqflite/sqflite.dart';

class DataHelper {
  static final DataHelper instance = DataHelper._init();
  static Database? _database;

  DataHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath();
    final pathToDB = dbPath + path;
    return await openDatabase(pathToDB, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        email TEXT,
        password TEXT,
        role TEXT
      );
      CREATE TABLE doctors (
        doctorId INTEGER PRIMARY KEY,
        userId INTEGER,
        specialty TEXT,
        yearsOfExperience INTEGER,
        description TEXT,
        status TEXT,
        FOREIGN KEY(userId) REFERENCES users(id)
      );
      CREATE TABLE patients (
        patientId INTEGER PRIMARY KEY,
        userId INTEGER,
        name TEXT,
        age INTEGER,
        weight REAL,
        address TEXT,
        diseaseId INTEGER,
        description TEXT,
        FOREIGN KEY(userId) REFERENCES users(id),
        FOREIGN KEY(diseaseId) REFERENCES diseases(id)
      );
      CREATE TABLE appointments (
        id INTEGER PRIMARY KEY,
        doctorId INTEGER,
        patientId INTEGER,
        time TEXT,
        status TEXT,
        FOREIGN KEY(doctorId) REFERENCES doctors(doctorId),
        FOREIGN KEY(patientId) REFERENCES patients(patientId)
      );
      CREATE TABLE diseases (
        id INTEGER PRIMARY KEY,
        name TEXT,
        description TEXT
      );
    ''');
  }

  // Các phương thức như add, get, update cho các model sẽ được thêm vào đây
  // Add a User
  Future<int> addUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

// Get a User by id
  Future<User?> getUser(int id) async {
    final db = await database;
    final result = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  // Kiểm tra người dùng theo email và mật khẩu
  Future<User?> getUserByEmailAndPassword(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first); // Trả về người dùng nếu tìm thấy
    }

    return null; // Trả về null nếu không tìm thấy
  }

  // Kiểm tra người dùng theo email
  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first); // Trả về đối tượng User nếu tìm thấy
    }

    return null; // Trả về null nếu không tìm thấy người dùng
  }

// Update a User
  Future<int> updateUser(User user) async {
    final db = await database;
    return await db
        .update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

// Delete a User
  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

// Add a Doctor
  Future<int> addDoctor(Doctor doctor) async {
    final db = await database;
    return await db.insert('doctors', doctor.toMap());
  }

// Get a Doctor by id
  Future<Doctor?> getDoctor(int id) async {
    final db = await database;
    final result =
        await db.query('doctors', where: 'doctorId = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Doctor.fromMap(result.first);
    }
    return null;
  }

// Update a Doctor
  Future<int> updateDoctor(Doctor doctor) async {
    final db = await database;
    return await db.update('doctors', doctor.toMap(),
        where: 'doctorId = ?', whereArgs: [doctor.doctorId]);
  }

// Delete a Doctor
  Future<int> deleteDoctor(int id) async {
    final db = await database;
    return await db.delete('doctors', where: 'doctorId = ?', whereArgs: [id]);
  }

// Add a Patient
  Future<int> addPatient(Patient patient) async {
    final db = await database;
    return await db.insert('patients', patient.toMap());
  }

// Get a Patient by id
  Future<Patient?> getPatient(int id) async {
    final db = await database;
    final result =
        await db.query('patients', where: 'patientId = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Patient.fromMap(result.first);
    }
    return null;
  }

// Update a Patient
  Future<int> updatePatient(Patient patient) async {
    final db = await database;
    return await db.update('patients', patient.toMap(),
        where: 'patientId = ?', whereArgs: [patient.patientId]);
  }

// Delete a Patient
  Future<int> deletePatient(int id) async {
    final db = await database;
    return await db.delete('patients', where: 'patientId = ?', whereArgs: [id]);
  }

// Add an Appointment
  Future<int> addAppointment(Appointment appointment) async {
    final db = await database;
    return await db.insert('appointments', appointment.toMap());
  }

// Get an Appointment by id
  Future<Appointment?> getAppointment(int id) async {
    final db = await database;
    final result =
        await db.query('appointments', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Appointment.fromMap(result.first);
    }
    return null;
  }

// Get all Appointments by doctorId or patientId
  Future<List<Appointment>> getAppointmentsByDoctorOrPatient(int doctorId,
      {int? patientId}) async {
    final db = await database;
    final where =
        patientId != null ? 'doctorId = ? AND patientId = ?' : 'doctorId = ?';
    final whereArgs = patientId != null ? [doctorId, patientId] : [doctorId];
    final result =
        await db.query('appointments', where: where, whereArgs: whereArgs);
    return result.map((e) => Appointment.fromMap(e)).toList();
  }

// Update an Appointment
  Future<int> updateAppointment(Appointment appointment) async {
    final db = await database;
    return await db.update('appointments', appointment.toMap(),
        where: 'id = ?', whereArgs: [appointment.id]);
  }

// Delete an Appointment
  Future<int> deleteAppointment(int id) async {
    final db = await database;
    return await db.delete('appointments', where: 'id = ?', whereArgs: [id]);
  }

// Add a Disease
  Future<int> addDisease(Disease disease) async {
    final db = await database;
    return await db.insert('diseases', disease.toMap());
  }

// Get a Disease by id
  Future<Disease?> getDisease(int id) async {
    final db = await database;
    final result = await db.query('diseases', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Disease.fromMap(result.first);
    }
    return null;
  }

// Update a Disease
  Future<int> updateDisease(Disease disease) async {
    final db = await database;
    return await db.update('diseases', disease.toMap(),
        where: 'id = ?', whereArgs: [disease.id]);
  }

// Delete a Disease
  Future<int> deleteDisease(int id) async {
    final db = await database;
    return await db.delete('diseases', where: 'id = ?', whereArgs: [id]);
  }
}
