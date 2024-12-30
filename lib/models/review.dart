class Review {
  final int? id;
  final int userId;
  final int docId;
  final double ratings;
  final String reviews;
  final String reviewedBy;
  final String status;

  Review({
    this.id,
    required this.userId,
    required this.docId,
    required this.ratings,
    required this.reviews,
    required this.reviewedBy,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'doc_id': docId,
      'ratings': ratings,
      'reviews': reviews,
      'reviewed_by': reviewedBy,
      'status': status,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'],
      userId: map['user_id'],
      docId: map['doc_id'],
      ratings: map['ratings'],
      reviews: map['reviews'],
      reviewedBy: map['reviewed_by'],
      status: map['status'],
    );
  }
}
