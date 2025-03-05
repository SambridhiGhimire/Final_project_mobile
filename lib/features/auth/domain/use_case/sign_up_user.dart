import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repository/user_repository.dart';

class SignUpUserParams extends Equatable {
  final String email;
  final String password;
  final String name;

  const SignUpUserParams({required this.email, required this.password, required this.name});

  const SignUpUserParams.empty() : email = '', password = '', name = '';

  @override
  List<Object?> get props => [email, password];
}

class SignUpUser implements UsecaseWithParams<String, SignUpUserParams> {
  final IUserRepository userRepository;

  const SignUpUser({required this.userRepository});

  @override
  Future<Either<Failure, String>> call(SignUpUserParams params) async {
    return userRepository.signUp(params.email, params.password, params.name).then((value) {
      return value.fold((failure) => Left(failure), (userData) => Right(userData));
    });
  }
}
