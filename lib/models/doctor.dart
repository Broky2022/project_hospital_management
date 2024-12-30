class Doctor {
  final int? id;
  final String docId;
  final String category;
  final int patients;
  final int experience;
  final String bioData;
  final String status;

  Doctor({
    this.id,
    required this.docId,
    required this.category,
    required this.patients,
    required this.experience,
    required this.bioData,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'doc_id': docId,
      'category': category,
      'patients': patients,
      'experience': experience,
      'bio_data': bioData,
      'status': status,
    };
  }

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'],
      docId: map['doc_id'],
      category: map['category'],
      patients: map['patients'],
      experience: map['experience'],
      bioData: map['bio_data'],
      status: map['status'],
    );
  }
}
