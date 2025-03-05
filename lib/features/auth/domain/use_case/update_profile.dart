import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wastemanagement/app/shared_prefs/user_shared_prefs.dart';

import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../../data/dto/login_dto.dart';
import '../repository/user_repository.dart';

class UpdateProfileParams extends Equatable {
  final String name;
  final File? image;

  const UpdateProfileParams({required this.name, this.image});

  @override
  List<Object?> get props => [name, image];
}

class UpdateProfile implements UsecaseWithParams<User, UpdateProfileParams> {
  final UserSharedPrefs userSharedPrefs;
  final IUserRepository userRepository;
  const UpdateProfile({required this.userSharedPrefs, required this.userRepository});

  @override
  Future<Either<Failure, User>> call(UpdateProfileParams params) async {
    final res = await userRepository.updateProfile(params.name, params.image);

    return res.fold((l) => Left(l), (r) {
      userSharedPrefs.updateUserData(r.user.name, r.user.profileImage);
      return Right(r.user);
    });
  }
}
