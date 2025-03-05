import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wastemanagement/features/auth/data/dto/login_dto.dart';

import '../../core/error/failure.dart';

class UserSharedPrefs {
  late SharedPreferences _sharedPreferences;

  // Set User Details
  Future<Either<Failure, bool>> setUserData(User data) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();

      await _sharedPreferences.setString('id', data.id);
      await _sharedPreferences.setString('name', data.name);
      await _sharedPreferences.setString('email', data.email);
      await _sharedPreferences.setString('role', data.role);
      await _sharedPreferences.setInt('points', data.points);
      await _sharedPreferences.setString('createdAt', data.createdAt);
      await _sharedPreferences.setString('updatedAt', data.updatedAt);
      if (data.profileImage != null) await _sharedPreferences.setString('profileImage', data.profileImage!);

      return Right(true);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, bool>> updateUserData(String name, String? profileImage) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();

      await _sharedPreferences.setString('name', name);
      if (profileImage != null) await _sharedPreferences.setString('profileImage', profileImage);

      return Right(true);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  // Get User Data
  Future<Either<Failure, User>> getUserData() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();

      final id = _sharedPreferences.getString('id');
      final name = _sharedPreferences.getString('name');
      final email = _sharedPreferences.getString('email');
      final role = _sharedPreferences.getString('role');
      final points = _sharedPreferences.getInt('points');
      final createdAt = _sharedPreferences.getString('createdAt');
      final updatedAt = _sharedPreferences.getString('updatedAt');
      final profileImage = _sharedPreferences.getString('profileImage');

      if (id != null && name != null && email != null && role != null && points != null && createdAt != null && updatedAt != null) {
        final res = User(
          id: id,
          name: name,
          email: email,
          role: role,
          points: points,
          createdAt: createdAt,
          updatedAt: updatedAt,
          profileImage: profileImage,
        );
        return Right(res);
      } else {
        return Left(SharedPrefsFailure(message: 'No user data found'));
      }
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  // Clear User Data
  Future<Either<Failure, bool>> clear() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      await _sharedPreferences.clear(); // Clears all data in SharedPreferences
      return Right(true);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }
}
