import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wastemanagement/app/constants/theme_constant.dart';
import 'package:wastemanagement/app/di/di.dart';
import 'package:wastemanagement/features/home/presentation/view/bottom_view_model/dashboard_bloc.dart';
import 'package:wastemanagement/features/report_waste/presentation/view_model/report_waste/report_waste_cubit.dart';

import '../../../report_waste/presentation/view/report_details_screen.dart';
import '../../../report_waste/presentation/view/report_waste_screen.dart';
import '../../data/model/user_report.dart';

class WasteReportCard extends StatelessWidget {
  final UserReport report;

  const WasteReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final dashboardBloc = context.read<DashboardBloc>();
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: ThemeConstant.primaryColor)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.orange[100], borderRadius: BorderRadius.circular(4)),
                  child: Text(report.status.toUpperCase(), style: const TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
                ),

                Text(report.wasteType, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),

            const SizedBox(height: 16),
            Text(report.description, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text("+${report.pointsAwarded} points awarded ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green)),
            const SizedBox(height: 8),
            BlocProvider(
              create: (context) => getIt<ReportWasteCubit>(),
              child: Row(
                children: [
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        return ElevatedButton(
                          onPressed: () {
                            final ReportWasteCubit reportWasteCubit = context.read<ReportWasteCubit>();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) => BlocProvider.value(
                                      value: dashboardBloc,
                                      child: WasteReportDetails(reportId: report.id, reportWasteCubit: reportWasteCubit),
                                    ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[400], elevation: 0),
                          child: const Text("View Details", style: TextStyle(color: Colors.black87, fontSize: 16)),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => BlocProvider(create: (context) => getIt<ReportWasteCubit>(), child: ReportWasteScreen(report: report)),
                            ),
                          ),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      child: const Text("Edit", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
