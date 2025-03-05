import 'package:wastemanagement/features/dashboard/data/model/user_report.dart';

import '../../../dashboard/data/model/location.dart';

class ReportDetails extends UserReport {
  final User userObject;
  ReportDetails({
    required super.id,
    required super.description,
    required super.wasteType,
    required super.imagePath,
    required super.status,
    required super.pointsAwarded,
    required super.createdAt,
    required super.updatedAt,
    required super.location,
    required this.userObject,
  }) : super(user: userObject.id);

  factory ReportDetails.fromJson(Map<String, dynamic> json) {
    return ReportDetails(
      id: json['_id'],
      userObject: User.fromJson(json['user']),
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
}

class User {
  final String id;
  final String name;
  final String email;

  const User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['_id'], name: json['name'], email: json['email']);
  }

  Map<String, dynamic> toJson() {
    return {"_id": id, "name": name, "email": email};
  }
}
