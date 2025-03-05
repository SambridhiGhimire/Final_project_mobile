import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id') // Maps the server field "_id" to the "userId" field
  final String? id;
  final String name;
  final String username;
  final String phone;
  final String email;
  final String password;

  // @JsonKey(name: 'photo') // Maps the server field "photo" to the "image" field
  final String? photo;
  final String gender;
  final List<String>? medical_conditions;

  const UserApiModel({
    this.id,
    required this.name,
    required this.username,
    required this.phone,
    required this.email,
    required this.password,
    this.photo,
    required this.gender,
    this.medical_conditions,
  });

  const UserApiModel.empty()
    : id = '',
      name = '',
      username = '',
      phone = '',
      email = '',
      password = '',
      photo = '',
      gender = '',
      medical_conditions = null;

  /// Factory constructor for creating a `UserApiModel` from JSON
  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return UserApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      username: json['username'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      photo: json['photo'] as String?,
      gender: json['gender'] as String,
      medical_conditions: List<String>.from(json["medical_conditions"]),
    );
  }

  /// Converts the current instance to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'username': username,
      'phone': phone,
      'email': email,
      'password': password,
      'photo': photo,
      'gender': gender,
      'medical_conditions': medical_conditions,
    };
  }

  @override
  List<Object?> get props => [id, name, username, phone, email, password, photo, gender, medical_conditions];
}
