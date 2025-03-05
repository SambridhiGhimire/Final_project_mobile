import 'location.dart';

class UserReport {
  final String id;
  final String user;
  final String description;
  final String wasteType;
  final String imagePath;
  final String status;
  final int pointsAwarded;
  final String createdAt;
  final String updatedAt;
  final Location location;

  UserReport({
    required this.id,
    required this.user,
    required this.description,
    required this.wasteType,
    required this.imagePath,
    required this.status,
    required this.pointsAwarded,
    required this.createdAt,
    required this.updatedAt,
    required this.location,
  });

  factory UserReport.fromJson(Map<String, dynamic> json) {
    return UserReport(
      id: json['_id'],
      user: json['user'],
      description: json['description'],
      wasteType: json['wasteType'],
      imagePath: json['imagePath'],
      status: json['status'],
      pointsAwarded: json['pointsAwarded'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      location: Location.fromJson(json['location']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "user": user,
      "description": description,
      "wasteType": wasteType,
      "imagePath": imagePath,
      "status": status,
      "pointsAwarded": pointsAwarded,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "location": location.toJson(),
    };
  }
}
