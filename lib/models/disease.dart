class Disease {
  int id;
  String name;
  String description;

  Disease({
    required this.id,
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  static Disease fromMap(Map<String, dynamic> map) {
    return Disease(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }
}
