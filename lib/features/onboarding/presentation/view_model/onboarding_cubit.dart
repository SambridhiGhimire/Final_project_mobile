import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wastemanagement/app/di/di.dart';
import 'package:wastemanagement/app/shared_prefs/onboarding_shared_prefs.dart';
import 'package:wastemanagement/features/auth/presentation/view_model/login/login_bloc.dart';

import '../../../auth/presentation/view/login_view.dart';

class OnboardingCubit extends Cubit<void> {
  final LoginBloc _loginBloc;
  OnboardingCubit(this._loginBloc) : super(null);

  void navigateToLogin(BuildContext context) {
    getIt<OnboardingSharedPrefs>().saveFirstTime();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BlocProvider.value(value: _loginBloc, child: LoginView())));
  }
}
