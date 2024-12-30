class Appointment {
  final int id;
  final int doctorId;
  final int patientId;
  final DateTime dateTime;
  final String status;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.dateTime,
    required this.status,
  });

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'],
      doctorId: map['doctor_id'],
      patientId: map['patient_id'],
      dateTime: DateTime.parse(map['date_time']),
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'patient_id': patientId,
      'date_time': dateTime.toIso8601String(),
      'status': status,
    };
  }
}
