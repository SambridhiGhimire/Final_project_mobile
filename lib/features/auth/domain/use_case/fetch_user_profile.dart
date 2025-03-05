import 'package:dartz/dartz.dart';
import 'package:wastemanagement/app/shared_prefs/user_shared_prefs.dart';
import 'package:wastemanagement/features/auth/data/dto/login_dto.dart';

import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';

class FetchUserProfile implements UsecaseWithoutParams<User> {
  final UserSharedPrefs userSharedPrefs;
  const FetchUserProfile({required this.userSharedPrefs});

  @override
  Future<Either<Failure, User>> call() async {
    return userSharedPrefs.getUserData();
  }
}
