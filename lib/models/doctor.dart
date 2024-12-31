import 'user.dart';

class Doctor extends User {
  final int doctorId;
  @override
  final String name;
  final String specialty;
  final int yearsOfExperience;
  final String description;
  final bool status;

  Doctor({
    required int id,
    required String email,
    required String password,
    required this.doctorId,
    required this.name,
    required this.specialty,
    required this.yearsOfExperience,
    required this.description,
    required this.status,
  }) : super(
            id: id,
            email: email,
            password: password,
            role: 'doctor',
            name: name);

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'] as int,
      email: map['email'] as String,
      password: map['password'] as String,
      name: map['name'] as String,
      doctorId: map['doctor_id'] as int,
      specialty: map['specialty'] as String,
      yearsOfExperience: map['years_of_experience'] as int,
      description: map['description'] as String,
      status: (map['status'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'role': role,
      'doctor_id': doctorId,
      'specialty': specialty,
      'years_of_experience': yearsOfExperience,
      'description': description,
      'status': status ? 1 : 0,
    };
  }
}
