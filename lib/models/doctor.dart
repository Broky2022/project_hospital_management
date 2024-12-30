import 'package:project_hospital_management/models/user.dart';

class Doctor extends User {
  int doctorId;
  String specialty;
  int yearsOfExperience;
  String description;
  String status; // "active" hoặc "inactive"

  Doctor({
    required int id,
    required String email,
    required String password,
    required this.doctorId,
    required this.specialty,
    required this.yearsOfExperience,
    required this.description,
    required this.status,
  }) : super(id: id, email: email, password: password, role: 'doctor');

  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'doctorId': doctorId,
      'specialty': specialty,
      'yearsOfExperience': yearsOfExperience,
      'description': description,
      'status': status,
    };
  }

  static Doctor fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      doctorId: map['doctorId'],
      specialty: map['specialty'],
      yearsOfExperience: map['yearsOfExperience'],
      description: map['description'],
      status: map['status'],
    );
  }
}
