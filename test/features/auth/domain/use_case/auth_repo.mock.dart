import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wastemanagement/app/shared_prefs/token_shared_prefs.dart';
import 'package:wastemanagement/app/shared_prefs/user_shared_prefs.dart';
import 'package:wastemanagement/features/auth/domain/repository/user_repository.dart';

class AuthRepoMock extends Mock implements IUserRepository {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

class MockUserSharedPrefs extends Mock implements UserSharedPrefs {}

class MockDio extends Mock implements Dio {}
