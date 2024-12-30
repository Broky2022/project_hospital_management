import 'user.dart';

class Patient extends User {
  final int patientId;
  final String name;
  final int age;
  final double weight;
  final String address;
  final int diseaseId;
  final String description;

  Patient({
    required int id,
    required String email,
    required String password,
    required this.patientId,
    required this.name,
    required this.age,
    required this.weight,
    required this.address,
    required this.diseaseId,
    required this.description,
  }) : super(id: id, email: email, password: password, role: 'patient');

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      patientId: map['patient_id'],
      name: map['name'],
      age: map['age'],
      weight: map['weight'],
      address: map['address'],
      diseaseId: map['disease_id'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'role': role,
      'patient_id': patientId,
      'name': name,
      'age': age,
      'weight': weight,
      'address': address,
      'disease_id': diseaseId,
      'description': description,
    };
  }
}
