import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wastemanagement/features/auth/domain/use_case/login_user_usecase.dart';
import 'package:wastemanagement/features/auth/presentation/view/login_view.dart';
import 'package:wastemanagement/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:wastemanagement/features/home/presentation/view_model/home_cubit.dart';

class MockHomeCubit extends Mock implements HomeCubit {}

class MockLoginUserUsecase extends Mock implements LoginUserUsecase {}

void main() {
  late LoginBloc loginBloc;
  late HomeCubit homeCubit;
  late LoginUserUsecase loginUserUsecase;

  setUp(() {
    homeCubit = MockHomeCubit();
    loginUserUsecase = MockLoginUserUsecase();

    loginBloc = LoginBloc(homeCubit: homeCubit, loginUserUsecase: loginUserUsecase);
  });

  testWidgets('Email and Password Validation', (WidgetTester tester) async {
    // Wrap the test with the required providers
    await tester.pumpWidget(MaterialApp(home: BlocProvider<LoginBloc>.value(value: loginBloc, child: LoginView())));

    // Find text fields
    final emailField = find.byKey(Key('email'));
    final passwordField = find.byKey(Key('password'));

    // Enter text
    await tester.enterText(emailField, 'test@gmail.com');
    await tester.enterText(passwordField, 'test12345');

    // Ensure UI updates
    await tester.pump();

    // Verify that the text has been entered correctly
    expect(find.text('test@gmail.com'), findsOneWidget);
    expect(find.text('test12345'), findsOneWidget);
  });

  testWidgets('Invalid Email and Password Validation', (WidgetTester tester) async {
    // Wrap the test with the required providers
    await tester.pumpWidget(MaterialApp(home: BlocProvider<LoginBloc>.value(value: loginBloc, child: LoginView())));

    // Find text fields
    final emailField = find.byKey(Key('email'));
    final passwordField = find.byKey(Key('password'));
    final loginButton = find.byKey(Key('loginButton'));

    // Enter an invalid email and a short password
    await tester.enterText(emailField, 'invalid-email');
    await tester.enterText(passwordField, 'short');

    // Ensure UI updates
    await tester.pump();

    // Tap the login button
    await tester.tap(loginButton);
    await tester.pump();

    // Check for validation messages
    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(find.text('Password must be at least 8 characters'), findsOneWidget);
  });
}
