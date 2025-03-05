part of 'report_details_cubit.dart';

@immutable
sealed class ReportDetailsState {}

final class ReportDetailsLoading extends ReportDetailsState {}

final class ReportDetailsLoaded extends ReportDetailsState {
  final ReportDetails reportDetails;

  ReportDetailsLoaded(this.reportDetails);
}

final class ReportDetailsError extends ReportDetailsState {
  final String message;

  ReportDetailsError(this.message);
}
