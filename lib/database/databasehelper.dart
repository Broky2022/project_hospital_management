import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/appointments.dart';
import '../models/doctor.dart';
import '../models/review.dart';
import '../models/user.dart';
import '../models/userdetails.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE appointments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        doc_id INTEGER,
        date TEXT,
        day TEXT,
        time TEXT,
        status TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE doctors (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        doc_id TEXT,
        category TEXT,
        patients INTEGER,
        experience INTEGER,
        bio_data TEXT,
        status TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE reviews (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        doc_id INTEGER,
        ratings REAL,
        reviews TEXT,
        reviewed_by TEXT,
        status TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        type TEXT,
        email TEXT,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE user_details (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        bio_data TEXT,
        fav TEXT,
        status TEXT
      )
    ''');
  }

  // CRUD Operations for Appointments
  Future<int> createAppointment(Appointment appointment) async {
    final db = await instance.database;
    return await db.insert('appointments', appointment.toMap());
  }

  Future<List<Appointment>> readAllAppointments() async {
    final db = await instance.database;
    final result = await db.query('appointments');

    return result.map((map) => Appointment.fromMap(map)).toList();
  }

  Future<int> updateAppointment(Appointment appointment) async {
    final db = await instance.database;
    return await db.update(
      'appointments',
      appointment.toMap(),
      where: 'id = ?',
      whereArgs: [appointment.id],
    );
  }

  Future<int> deleteAppointment(int id) async {
    final db = await instance.database;
    return await db.delete(
      'appointments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD Operations for Doctors
  Future<int> createDoctor(Doctor doctor) async {
    final db = await instance.database;
    return await db.insert('doctors', doctor.toMap());
  }

  Future<List<Doctor>> readAllDoctors() async {
    final db = await instance.database;
    final result = await db.query('doctors');

    return result.map((map) => Doctor.fromMap(map)).toList();
  }

  Future<int> updateDoctor(Doctor doctor) async {
    final db = await instance.database;
    return await db.update(
      'doctors',
      doctor.toMap(),
      where: 'id = ?',
      whereArgs: [doctor.id],
    );
  }

  Future<int> deleteDoctor(int id) async {
    final db = await instance.database;
    return await db.delete(
      'doctors',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD Operations for Reviews
  Future<int> createReview(Review review) async {
    final db = await instance.database;
    return await db.insert('reviews', review.toMap());
  }

  Future<List<Review>> readAllReviews() async {
    final db = await instance.database;
    final result = await db.query('reviews');

    return result.map((map) => Review.fromMap(map)).toList();
  }

  Future<int> updateReview(Review review) async {
    final db = await instance.database;
    return await db.update(
      'reviews',
      review.toMap(),
      where: 'id = ?',
      whereArgs: [review.id],
    );
  }

  Future<int> deleteReview(int id) async {
    final db = await instance.database;
    return await db.delete(
      'reviews',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD Operations for Users
  Future<int> createUser(User user) async {
    final db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  Future<List<User>> readAllUsers() async {
    final db = await instance.database;
    final result = await db.query('users');

    return result.map((map) => User.fromMap(map)).toList();
  }

  Future<int> updateUser(User user) async {
    final db = await instance.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await instance.database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD Operations for UserDetails
  Future<int> createUserDetails(UserDetails userDetails) async {
    final db = await instance.database;
    return await db.insert('user_details', userDetails.toMap());
  }

  Future<List<UserDetails>> readAllUserDetails() async {
    final db = await instance.database;
    final result = await db.query('user_details');

    return result.map((map) => UserDetails.fromMap(map)).toList();
  }

  Future<int> updateUserDetails(UserDetails userDetails) async {
    final db = await instance.database;
    return await db.update(
      'user_details',
      userDetails.toMap(),
      where: 'id = ?',
      whereArgs: [userDetails.id],
    );
  }

  Future<int> deleteUserDetails(int id) async {
    final db = await instance.database;
    return await db.delete(
      'user_details',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
