import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/dto/login_dto.dart';
import '../../data/model/edit_profile_respons.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, LoginDTO>> login(String email, String password);
  Future<Either<Failure, String>> signUp(String email, String password, String name);
  Future<Either<Failure, String>> resetPassword(String email);

  Future<Either<Failure, EditProfileResponse>> updateProfile(String name, File? image);
}
