import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wastemanagement/features/auth/domain/use_case/sign_up_user.dart';

import 'auth_repo.mock.dart';

void main() {
  // Initialization will happen later so no constructor required
  late AuthRepoMock repository;
  late SignUpUser usecase;

  // Creating Setup for Mocking Repository
  setUp(() {
    repository = AuthRepoMock();
    usecase = SignUpUser(userRepository: repository);
  });

  test('should call the [UserRepo.signUp]', () async {
    when(() => repository.signUp(any(), any(), any())).thenAnswer((_) async => Right('User Registered Successfully!'));

    final params = SignUpUserParams.empty();
    // Act
    final result = await usecase(params);
    // final result = Failure;

    // Assert
    expect(result, Right('User Registered Successfully!'));

    // Verify
    verify(() => repository.signUp(any(), any(), any())).called(1);

    verifyNoMoreInteractions(repository);
  });
}
