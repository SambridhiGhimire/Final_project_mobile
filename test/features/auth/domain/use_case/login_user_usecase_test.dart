import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wastemanagement/core/error/failure.dart';
import 'package:wastemanagement/features/auth/data/dto/login_dto.dart';
import 'package:wastemanagement/features/auth/domain/use_case/login_user_usecase.dart';

import 'auth_repo.mock.dart';

class UserTypeFake extends Fake implements User {}

void main() {
  late AuthRepoMock repository;
  late MockTokenSharedPrefs sharedPrefs;
  late MockUserSharedPrefs userSharedPrefs;
  late LoginUserUsecase usecase;
  late Dio dio;

  setUp(() {
    repository = AuthRepoMock();
    sharedPrefs = MockTokenSharedPrefs();
    userSharedPrefs = MockUserSharedPrefs();
    dio = Dio();
    usecase = LoginUserUsecase(userRepository: repository, tokenSharedPrefs: sharedPrefs, userSharedPrefs: userSharedPrefs, dio: dio);
    registerFallbackValue(UserTypeFake());
  });

  group('[AuthRepo.login] test', () {
    final loginDTO = LoginDTO(
      message: 'token',
      user: UserData(
        user: User(id: '1', name: 'Test User', email: 'test@gmail.com', role: 'user', points: 0, createdAt: '', updatedAt: ''),
        token: 'token',
      ),
    );

    setUp(() {
      when(() => repository.login(any(), any())).thenAnswer((invocation) async {
        final email = invocation.positionalArguments[0] as String;
        final password = invocation.positionalArguments[1] as String;
        if (email == 'test@gmail.com' && password == 'test12345') {
          return Future.value(Right(loginDTO));
        } else {
          return Future.value(Left(ApiFailure(message: 'Invalid email or password')));
        }
      });

      when(() => sharedPrefs.saveToken(any())).thenAnswer((_) async => Right(null));
      when(() => userSharedPrefs.setUserData(any())).thenAnswer((_) async => Right(true));
    });

    test('should call the [AuthRepo.login] and succeed with correct email and password', () async {
      final result = await usecase(LoginUserParams(email: 'test@gmail.com', password: 'test12345'));

      expect(result, Right(loginDTO.user.user));

      verify(() => repository.login('test@gmail.com', 'test12345')).called(1);
      verify(() => sharedPrefs.saveToken(loginDTO.user.token)).called(1);
      verify(() => userSharedPrefs.setUserData(loginDTO.user.user)).called(1);

      verifyNoMoreInteractions(repository);
      verifyNoMoreInteractions(sharedPrefs);
      verifyNoMoreInteractions(userSharedPrefs);
    });

    test('should call the [AuthRepo.login] and fail with incorrect email and password', () async {
      final result = await usecase(LoginUserParams(email: 'test-failure@gmail.com', password: 'test123'));

      expect(
        result,
        isA<Left<Failure, User>>().having(
          (left) => left.value,
          'message',
          isA<ApiFailure>().having((e) => e.message, 'message', 'Invalid email or password'),
        ),
      );

      verify(() => repository.login('test-failure@gmail.com', 'test123')).called(1);
      verifyNever(() => sharedPrefs.saveToken(any()));
      verifyNever(() => userSharedPrefs.setUserData(any()));

      verifyNoMoreInteractions(repository);
      verifyNoMoreInteractions(sharedPrefs);
      verifyNoMoreInteractions(userSharedPrefs);
    });

    tearDown(() {
      reset(repository);
      reset(sharedPrefs);
      reset(userSharedPrefs);
    });
  });
}
