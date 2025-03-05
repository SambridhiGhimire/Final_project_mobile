class UserEntity {
  final String id;
  final String name;
  final String email;
  final String role;
  final int points;
  final String createdAt;
  final String updatedAt;
  final String? profileImage;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.points,
    required this.createdAt,
    required this.updatedAt,
    this.profileImage,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      points: json['points'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'points': points,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'profileImage': profileImage,
    };
  }
}
