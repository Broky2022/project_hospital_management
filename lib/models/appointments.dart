class Appointment {
  int id;
  int doctorId;
  int patientId;
  String time;
  String status; // "scheduled", "completed", "cancelled"

  Appointment({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.time,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'doctorId': doctorId,
      'patientId': patientId,
      'time': time,
      'status': status,
    };
  }

  static Appointment fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'],
      doctorId: map['doctorId'],
      patientId: map['patientId'],
      time: map['time'],
      status: map['status'],
    );
  }
}
