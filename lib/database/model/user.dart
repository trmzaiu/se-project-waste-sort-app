class Users {
  final String userId;
  final String name;
  final String email;
  final DateTime? dob;
  final String photoUrl;
  final String country;
  final DateTime? completedDate;
  final int streak;

  Users({
    required this.userId,
    required this.name,
    required this.email,
    this.dob,
    this.photoUrl = "",
    this.country = "",
    this.completedDate,
    this.streak = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'dob': dob?.toIso8601String(),
      'photoUrl': photoUrl,
      'country': country,
      'completedDate': completedDate?.toIso8601String(),
      'streak': streak,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    final String userId = map['userId'] ?? '';

    return Users(
      userId: userId,
      name: map['name'] ?? userId.substring(0, 10),
      email: map['email'] ?? '',
      dob: (map['dob'] != null && map['dob'].toString().isNotEmpty)
          ? DateTime.tryParse(map['dob'])
          : null,
      photoUrl: map['photoUrl'] ?? "",
      country: map['country'] ?? "",
      completedDate: (map['completedDate'] != null &&
          map['completedDate'].toString().isNotEmpty)
          ? DateTime.tryParse(map['completedDate'])
          : null,
      streak: map['streak'] ?? 0,
    );
  }
}