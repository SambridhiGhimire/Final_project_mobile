import 'package:dartz/dartz.dart';

import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repository/user_repository.dart';

class SendResetLink implements UsecaseWithParams<String, String> {
  final IUserRepository userRepository;

  const SendResetLink({required this.userRepository});

  @override
  Future<Either<Failure, String>> call(String email) async {
    return userRepository.resetPassword(email).then((value) {
      return value.fold((failure) => Left(failure), (message) => Right(message));
    });
  }
}
