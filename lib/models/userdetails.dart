class UserDetails {
  final int? id;
  final int userId;
  final String bioData;
  final String fav;
  final String status;

  UserDetails({
    this.id,
    required this.userId,
    required this.bioData,
    required this.fav,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'bio_data': bioData,
      'fav': fav,
      'status': status,
    };
  }

  factory UserDetails.fromMap(Map<String, dynamic> map) {
    return UserDetails(
      id: map['id'],
      userId: map['user_id'],
      bioData: map['bio_data'],
      fav: map['fav'],
      status: map['status'],
    );
  }
}
