import 'user_report.dart';

class UserReportResponse {
  final List<UserReport> userReports;

  UserReportResponse({required this.userReports});

  factory UserReportResponse.fromJson(List<dynamic> json) {
    List<UserReport> userReports = [];
    userReports = json.map((userReport) => UserReport.fromJson(userReport)).toList();
    return UserReportResponse(userReports: userReports);
  }
}
