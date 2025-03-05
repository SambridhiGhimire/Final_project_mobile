import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Event to load initial data
class LoadDashboardData extends DashboardEvent {}
