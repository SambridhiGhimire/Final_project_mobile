import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/constants/hive_table_constant.dart';

part 'user_hive_model.g.dart';
// dart run build_runner build -d

@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String username;

  @HiveField(3)
  final String phone;

  @HiveField(4)
  final String email;

  @HiveField(5)
  final String password;

  @HiveField(6)
  final String? photo;

  @HiveField(7)
  final String gender;

  @HiveField(8)
  final List<String>? medicalConditions;

  UserHiveModel({
    String? id,
    required this.name,
    required this.username,
    required this.phone,
    required this.email,
    required this.password,
    this.photo,
    required this.gender,
    List<String>? medicalConditions,
  }) : id = id ?? const Uuid().v4(),
       medicalConditions = medicalConditions ?? null;

  /// Initial constructor with default values
  const UserHiveModel.initial()
    : id = '',
      name = '',
      username = '',
      phone = '',
      email = '',
      password = '',
      photo = null,
      gender = '',
      medicalConditions = null;

  @override
  List<Object?> get props => [id, name, username, phone, email, password, photo, gender, medicalConditions];
}
