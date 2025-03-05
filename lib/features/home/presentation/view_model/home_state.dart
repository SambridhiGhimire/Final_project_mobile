import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../auth/presentation/view/profile_view.dart';
import '../../../dashboard/presentation/view/dashboard_screen.dart';
import '../../../report_waste/presentation/view/report_waste_screen.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final List<Widget> views;

  const HomeState({required this.selectedIndex, required this.views});

  static HomeState initial() {
    return HomeState(selectedIndex: 0, views: [const DashboardScreen(), const ReportWasteScreen(), ProfileView()]);
  }

  HomeState copyWith({int? selectedIndex, List<Widget>? views}) {
    return HomeState(selectedIndex: selectedIndex ?? this.selectedIndex, views: views ?? this.views);
  }

  @override
  List<Object?> get props => [selectedIndex, views];
}
