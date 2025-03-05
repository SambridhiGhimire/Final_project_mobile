import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:wastemanagement/features/auth/data/dto/login_dto.dart';
import 'package:wastemanagement/features/auth/data/model/edit_profile_respons.dart' show EditProfileResponse;

import '../../../../core/error/failure.dart';
import '../../domain/repository/user_repository.dart';
import '../data_source/remote_datasource/user_remote_data_source.dart';

class UserRemoteRepository implements IUserRepository {
  final UserRemoteDataSource _userRemoteDataSource;

  UserRemoteRepository(this._userRemoteDataSource);

  @override
  Future<Either<Failure, LoginDTO>> login(String email, String password) async {
    try {
      // Call the login function from the remote data source
      final response = await _userRemoteDataSource.login(email, password);
      return Right(response);
    } on Exception catch (e) {
      // Handle any errors and return the failure message
      return Left(ApiFailure(message: e.toString().replaceAll('Exception: ', '').trim()));
    }
  }

  @override
  Future<Either<Failure, String>> signUp(String email, String password, String name) async {
    try {
      final response = await _userRemoteDataSource.signUp(email, password, name);
      return Right(response);
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString().replaceAll('Exception: ', '').trim()));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword(String email) async {
    try {
      final response = await _userRemoteDataSource.resetPassword(email);
      return Right(response);
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString().replaceAll('Exception: ', '').trim()));
    }
  }

  @override
  Future<Either<Failure, EditProfileResponse>> updateProfile(String name, File? image) async {
    try {
      final response = await _userRemoteDataSource.updateProfile(name, image);
      return Right(response);
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString().replaceAll('Exception: ', '').trim()));
    }
  }
}
