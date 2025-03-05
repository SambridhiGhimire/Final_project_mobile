import 'package:dartz/dartz.dart';
import 'package:wastemanagement/app/usecase/usecase.dart';
import 'package:wastemanagement/core/error/failure.dart';
import 'package:wastemanagement/features/dashboard/data/model/user_report.dart';
import 'package:wastemanagement/features/dashboard/domain/entity/user_reports_entity.dart';

import '../repository/dashboard_repository.dart';

class FetchUserReports implements UsecaseWithoutParams<UserReportsEntity> {
  final DashboardRepository repository;

  FetchUserReports(this.repository);

  @override
  Future<Either<Failure, UserReportsEntity>> call() async {
    try {
      final reports = await repository.getDashboardData();

      List<UserReport> approvedReports = [];
      List<UserReport> pendingReports = [];

      for (var report in reports) {
        if (report.status == "approved") {
          approvedReports.add(report);
        } else if (report.status == "pending") {
          pendingReports.add(report);
        }
      }

      return Right(UserReportsEntity(approved: approvedReports, pending: pendingReports));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
