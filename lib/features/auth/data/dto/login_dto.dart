import 'package:json_annotation/json_annotation.dart';

part 'login_dto.g.dart';

@JsonSerializable()
class LoginDTO {
  final String message;
  final UserData user;

  LoginDTO({required this.message, required this.user});

  /// Factory constructor for creating a `LoginDTO` from JSON
  factory LoginDTO.fromJson(Map<String, dynamic> json) => _$LoginDTOFromJson(json);

  /// Converts the current instance to JSON
  Map<String, dynamic> toJson() => _$LoginDTOToJson(this);
}

@JsonSerializable()
class User {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String email;
  final String role;
  final int points;
  final String createdAt;
  final String updatedAt;
  final String? profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.points,
    required this.createdAt,
    required this.updatedAt,
    this.profileImage,
  });

  /// Factory constructor for creating a `User` from JSON
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Converts the current instance to JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class UserData {
  final User user;
  final String token;

  UserData({required this.user, required this.token});

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);

  /// Converts the current instance to JSON
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
