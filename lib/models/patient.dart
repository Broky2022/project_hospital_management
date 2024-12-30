import 'package:project_hospital_management/models/user.dart';

class Patient extends User {
  int patientId;
  String name;
  int age;
  double weight;
  String address;
  int diseaseId;
  String description;

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

  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'patientId': patientId,
      'name': name,
      'age': age,
      'weight': weight,
      'address': address,
      'diseaseId': diseaseId,
      'description': description,
    };
  }

  static Patient fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      patientId: map['patientId'],
      name: map['name'],
      age: map['age'],
      weight: map['weight'],
      address: map['address'],
      diseaseId: map['diseaseId'],
      description: map['description'],
    );
  }
}
