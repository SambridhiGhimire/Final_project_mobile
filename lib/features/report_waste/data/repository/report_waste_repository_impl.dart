import 'package:wastemanagement/core/common/internet_checker/internet_checker.dart';
import 'package:wastemanagement/features/report_waste/data/model/report_details.dart';
import 'package:wastemanagement/features/report_waste/domain/repository/report_waste_repository.dart';

import '../datasource/report_waste_remote_datasource.dart';
import '../model/report_waste_request.dart';
import '../model/report_waste_response.dart';

class ReportWasteRepositoryImpl implements ReportWasteRepository {
  final ReportWasteRemoteDatasource remoteDatasource;
  final InternetChecker internetChecker;
  const ReportWasteRepositoryImpl(this.remoteDatasource, this.internetChecker);

  @override
  Future<ReportWasteResponse> reportWaste(ReportWasteRequest request) async {
    if (await internetChecker.hasInternetConnection()) {
      final res = await remoteDatasource.reportWaste(request);
      return res;
    } else {
      throw Exception('No internet connection');
    }
  }

  @override
  Future<ReportDetails> getReportDetails(String reportId) async {
    if (await internetChecker.hasInternetConnection()) {
      final res = await remoteDatasource.getReportDetails(reportId);
      return res;
    } else {
      throw Exception('No internet connection');
    }
  }

  @override
  Future<ReportWasteResponse> updateReport(ReportWasteRequest request) async {
    if (await internetChecker.hasInternetConnection()) {
      final res = await remoteDatasource.updateReport(request);
      return res;
    } else {
      throw Exception('No internet connection');
    }
  }

  @override
  Future<bool> deleteReport(String id) async {
    if (await internetChecker.hasInternetConnection()) {
      final res = await remoteDatasource.deleteReport(id);
      return res;
    } else {
      throw Exception('No internet connection');
    }
  }
}
