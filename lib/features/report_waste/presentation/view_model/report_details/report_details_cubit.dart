import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wastemanagement/features/report_waste/data/model/report_details.dart';
import 'package:wastemanagement/features/report_waste/domain/usecase/fetch_report.dart';

part 'report_details_state.dart';

class ReportDetailsCubit extends Cubit<ReportDetailsState> {
  final FetchReport fetchReport;
  ReportDetailsCubit(this.fetchReport) : super(ReportDetailsLoading());

  Future<void> loadReportDetails(String id) async {
    final res = await fetchReport(id);
    res.fold((l) => emit(ReportDetailsError(l.message)), (report) => emit(ReportDetailsLoaded(report)));
  }
}
