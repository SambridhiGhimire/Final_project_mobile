import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wastemanagement/app/constants/theme_constant.dart';
import 'package:wastemanagement/app/di/di.dart' show getIt;
import 'package:wastemanagement/features/auth/presentation/view_model/profile/profile_cubit.dart';
import 'package:wastemanagement/features/report_waste/presentation/view_model/report_waste/report_waste_cubit.dart';

import '../../../../core/common/app_bar/main_app_bar.dart';
import '../view_model/home_cubit.dart';
import '../view_model/home_state.dart';
import 'bottom_view_model/dashboard_bloc.dart';
import 'bottom_view_model/dashboard_event.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<DashboardBloc>()..add(LoadDashboardData())),
        BlocProvider(create: (context) => getIt<ReportWasteCubit>()),
        BlocProvider(create: (context) => getIt<ProfileCubit>()..getUserProfile()),
      ],
      child: Scaffold(
        appBar: MainAppBar(isDarkTheme: false),
        body: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) => state.views[state.selectedIndex]),
        bottomNavigationBar: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.space_dashboard_rounded), label: 'Dashboard'),
                BottomNavigationBarItem(icon: Icon(Icons.report_sharp), label: 'Report Waste'),
                BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
              ],
              currentIndex: state.selectedIndex,
              selectedItemColor: ThemeConstant.primaryColor,
              unselectedItemColor: Colors.white,
              selectedFontSize: 12,
              backgroundColor: Colors.black,
              onTap: (index) => context.read<HomeCubit>().onTabTapped(index),
            );
          },
        ),
      ),
    );
  }
}
