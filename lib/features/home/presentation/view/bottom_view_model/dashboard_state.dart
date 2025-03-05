import 'package:equatable/equatable.dart';
import 'package:wastemanagement/features/dashboard/domain/entity/user_reports_entity.dart';

abstract class DashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final UserReportsEntity reports;

  DashboardLoaded({required this.reports});

  @override
  List<Object?> get props => [reports];
}

// Error state
class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
