import 'package:wastemanagement/features/report_waste/data/model/report_details.dart';
import 'package:wastemanagement/features/report_waste/data/model/report_waste_request.dart';

import '../../data/model/report_waste_response.dart';

abstract class ReportWasteRepository {
  Future<ReportWasteResponse> reportWaste(ReportWasteRequest request);

  Future<ReportDetails> getReportDetails(String reportId);

  Future<ReportWasteResponse> updateReport(ReportWasteRequest request);

  Future<bool> deleteReport(String id);
}
