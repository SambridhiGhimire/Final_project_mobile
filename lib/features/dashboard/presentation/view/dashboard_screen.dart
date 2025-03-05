import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wastemanagement/features/dashboard/presentation/widgets/waste_report_card.dart';
import 'package:wastemanagement/features/home/presentation/view_model/home_cubit.dart';

import '../../../home/presentation/view/bottom_view_model/dashboard_bloc.dart';
import '../../../home/presentation/view/bottom_view_model/dashboard_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  Widget _buildStatCard(String title, String count, Color color) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: color, width: 1)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(count, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) return const Center(child: CircularProgressIndicator());

          if (state is DashboardError) return Center(child: Text(state.message));

          if (state is DashboardLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildStatCard('Total Reports', state.reports.totalReports, Colors.blue),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(child: _buildStatCard('Approved', state.reports.totalApproved, Colors.green)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildStatCard('Pending', state.reports.totalPending, Colors.orange)),
                    ],
                  ),
                  const SizedBox(height: 32),

                  Center(child: const Text('Recent Reports', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                  const Divider(thickness: 1, height: 20),
                  const SizedBox(height: 16),
                  if ((state.reports.allReports).isNotEmpty)
                    Expanded(child: ListView(children: state.reports.allReports.map((report) => WasteReportCard(report: report)).toList()))
                  else ...[
                    const Text('No reports submitted yet.', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 16),
                    ElevatedButton(onPressed: () => context.read<HomeCubit>().onTabTapped(1), child: const Text('Submit Your First Report')),
                  ],
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
