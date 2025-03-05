import 'package:wastemanagement/features/dashboard/data/model/user_report.dart';

abstract class DashboardRepository {
  Future<List<UserReport>> getDashboardData();
}
