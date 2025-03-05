import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wastemanagement/app/constants/theme_constant.dart';
import 'package:wastemanagement/app/extensions/context_extension.dart';

import '../../../../core/common/logo.dart';
import '../view_model/splash_cubit.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    context.read<SplashCubit>().init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstant.primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Logo(height: context.screenHeight * 0.25),
                  const SizedBox(height: 30),
                  const CircularProgressIndicator(color: Colors.white),
                  const SizedBox(height: 10),
                  const Text('Version: 1.0.0', style: TextStyle(fontSize: 15, color: Colors.white)),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              left: context.screenWidth / 4,
              child: const Text('Developed by: Sambridhi Ghimire', style: TextStyle(fontSize: 15, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
