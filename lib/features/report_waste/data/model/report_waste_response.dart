import 'package:wastemanagement/features/dashboard/data/model/user_report.dart';

class ReportWasteResponse {
  final String message;
  final UserReport report;

  ReportWasteResponse({required this.message, required this.report});

  factory ReportWasteResponse.fromJson(Map<String, dynamic> json) {
    return ReportWasteResponse(message: json['message'], report: UserReport.fromJson(json['report']));
  }

  Map<String, dynamic> toJson() {
    return {"message": message, "report": report.toJson()};
  }

  @override
  String toString() {
    return 'ReportWasteResponse(message: $message, report: $report)';
  }
}
