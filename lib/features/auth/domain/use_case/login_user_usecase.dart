import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:wastemanagement/features/auth/data/dto/login_dto.dart';

import '../../../../app/shared_prefs/token_shared_prefs.dart';
import '../../../../app/shared_prefs/user_shared_prefs.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repository/user_repository.dart';

class LoginUserParams extends Equatable {
  final String email;
  final String password;

  const LoginUserParams({required this.email, required this.password});

  const LoginUserParams.empty() : email = '_empty.email', password = '_empty.password';

  @override
  List<Object?> get props => [email, password];
}

class LoginUserUsecase implements UsecaseWithParams<User, LoginUserParams> {
  final IUserRepository userRepository;
  final TokenSharedPrefs tokenSharedPrefs;
  final UserSharedPrefs userSharedPrefs;
  final Dio dio;

  const LoginUserUsecase({required this.userRepository, required this.tokenSharedPrefs, required this.userSharedPrefs, required this.dio});

  @override
  Future<Either<Failure, User>> call(LoginUserParams params) async {
    // Call the repository to login
    return userRepository.login(params.email, params.password).then((value) {
      return value.fold((failure) => Left(failure), (userData) {
        // Save user data in Shared Preferences
        userSharedPrefs.setUserData(userData.user.user);
        tokenSharedPrefs.saveToken(userData.user.token);

        dio.options.headers['Authorization'] = userData.user.token;
        return Right(userData.user.user);
      });
    });
  }
}
