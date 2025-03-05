import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wastemanagement/features/dashboard/domain/usecase/fetch_user_reports.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final FetchUserReports fetchUserReports;
  DashboardBloc(this.fetchUserReports) : super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
  }

  void _onLoadDashboardData(LoadDashboardData event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      final res = await fetchUserReports();
      res.fold((l) => emit(DashboardError(l.message)), (r) => emit(DashboardLoaded(reports: r)));
    } catch (e) {
      emit(DashboardError("Error: ${e.toString()}"));
    }
  }

  num get points =>
      state is DashboardLoaded
          ? (state as DashboardLoaded).reports.approved.fold(0, (previousValue, element) => previousValue + element.pointsAwarded)
          : 0;
}
