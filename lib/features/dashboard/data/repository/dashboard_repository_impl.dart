import 'package:wastemanagement/features/dashboard/data/model/user_report.dart';

import '../../../../core/common/internet_checker/internet_checker.dart';
import '../../domain/repository/dashboard_repository.dart';
import '../datasource/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final InternetChecker internetChecker;
  final DashboardRemoteDatasource dashboardRemoteDatasource;

  const DashboardRepositoryImpl(this.dashboardRemoteDatasource, this.internetChecker);

  @override
  Future<List<UserReport>> getDashboardData() async {
    if (await internetChecker.hasInternetConnection()) {
      final res = await dashboardRemoteDatasource.getDashboardData();

      return res.userReports;
    } else {
      throw Exception('No internet connection');
    }
  }
}
