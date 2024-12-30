class Appointment {
  final int? id;
  final int userId;
  final int docId;
  final String date;
  final String day;
  final String time;
  final String status;

  Appointment({
    this.id,
    required this.userId,
    required this.docId,
    required this.date,
    required this.day,
    required this.time,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'doc_id': docId,
      'date': date,
      'day': day,
      'time': time,
      'status': status,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'],
      userId: map['user_id'],
      docId: map['doc_id'],
      date: map['date'],
      day: map['day'],
      time: map['time'],
      status: map['status'],
    );
  }
}
