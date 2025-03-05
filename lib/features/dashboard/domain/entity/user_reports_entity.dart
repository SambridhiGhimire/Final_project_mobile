import 'package:equatable/equatable.dart';
import 'package:wastemanagement/features/dashboard/data/model/user_report.dart';

class UserReportsEntity extends Equatable {
  final List<UserReport> approved;
  final List<UserReport> pending;

  const UserReportsEntity({required this.approved, required this.pending});

  UserReportsEntity copyWith({List<UserReport>? approved, List<UserReport>? pending}) {
    return UserReportsEntity(approved: approved ?? this.approved, pending: pending ?? this.pending);
  }

  String get totalReports => (approved.length + pending.length).toString();
  String get totalApproved => approved.length.toString();
  String get totalPending => pending.length.toString();

  List<UserReport> get allReports {
    final List<UserReport> allReports = [];
    allReports.addAll(approved);
    allReports.addAll(pending);
    allReports.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return allReports;
  }

  @override
  List<Object?> get props => [approved, pending];
}
