import 'package:dio/dio.dart';
import 'package:wastemanagement/app/constants/api_endpoints.dart';
import 'package:wastemanagement/features/dashboard/data/model/user_report_response.dart';

abstract class DashboardRemoteDatasource {
  Future<UserReportResponse> getDashboardData();
}

class DashboardRemoteDatasourceImpl implements DashboardRemoteDatasource {
  final Dio dio;
  const DashboardRemoteDatasourceImpl(this.dio);

  @override
  Future<UserReportResponse> getDashboardData() async {
    final res = await dio.get(ApiEndpoints.reportUrl);
    return UserReportResponse.fromJson(res.data);
  }
}
