import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wastemanagement/app/di/di.dart';
import 'package:wastemanagement/app/shared_prefs/onboarding_shared_prefs.dart';

import '../../../../app/shared_prefs/token_shared_prefs.dart';
import '../../../auth/presentation/view/login_view.dart';
import '../../../auth/presentation/view_model/login/login_bloc.dart';
import '../../../home/presentation/view/home_view.dart';
import '../../../home/presentation/view_model/home_cubit.dart';
import '../../../onboarding/presentation/view/onboarding_view.dart';
import '../../../onboarding/presentation/view_model/onboarding_cubit.dart';

class SplashCubit extends Cubit<void> {
  SplashCubit(this._tokenSharedPrefs, this._homeCubit, this._loginBloc, this._onboardingSharedPrefs, this._onboardingCubit) : super(null);

  final TokenSharedPrefs _tokenSharedPrefs;
  final OnboardingSharedPrefs _onboardingSharedPrefs;
  final LoginBloc _loginBloc;
  final HomeCubit _homeCubit;
  final OnboardingCubit _onboardingCubit;

  Future<void> checkTokenAndNavigate(BuildContext context) async {
    final onboardingResult = await _onboardingSharedPrefs.getFirstTime();
    onboardingResult.fold(
      (failure) {
        // ❌ Log error & go to Login if onboarding retrieval fails
        debugPrint("❌ Error fetching onboarding: ${failure.message}");
        goToLogin(context);
      },
      (isFirstTime) async {
        if (isFirstTime) {
          // ✅ First time, go to Onboarding
          debugPrint("✅ First time: Navigating to Onboarding");
          goToOnboarding(context);
        } else {
          // ❌ Not first time, check token
          debugPrint("❌ Not first time: Checking token");
          final tokenResult = await _tokenSharedPrefs.getToken();
          tokenResult.fold(
            (failure) {
              // ❌ Log error & go to Login if token retrieval fails
              debugPrint("❌ Error fetching token: ${failure.message}");
              goToLogin(context);
            },
            (String? token) {
              if (token != null && token.trim().isNotEmpty) {
                // ✅ Token exists, go to HomePage
                getIt<Dio>().options.headers['Authorization'] = token;
                debugPrint("✅ Token found: Navigating to Home");
                goToHome(context);
              } else {
                // ❌ No token, go to Login
                debugPrint("❌ No token found: Navigating to Login");
                goToLogin(context);
              }
            },
          );
        }
      },
    );
  }

  Future<void> init(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1), () async {
      if (context.mounted) checkTokenAndNavigate(context);
    });
  }

  void goToLogin(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BlocProvider.value(value: _loginBloc, child: LoginView())));
  }

  void goToHome(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BlocProvider.value(value: _homeCubit, child: HomeView())));
  }

  void goToOnboarding(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BlocProvider.value(value: _onboardingCubit, child: const OnboardingView())),
    );
  }
}
