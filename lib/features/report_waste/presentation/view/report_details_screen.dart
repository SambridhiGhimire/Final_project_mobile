import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wastemanagement/app/constants/api_endpoints.dart';
import 'package:wastemanagement/app/di/di.dart';

import '../../../../core/common/shake_detector/shake_detector.dart';
import '../view_model/report_details/report_details_cubit.dart';
import '../view_model/report_waste/report_waste_cubit.dart';
import 'report_waste_screen.dart';

class WasteReportDetails extends StatefulWidget {
  final String reportId;
  final ReportWasteCubit reportWasteCubit;
  const WasteReportDetails({super.key, required this.reportId, required this.reportWasteCubit});

  @override
  State<WasteReportDetails> createState() => _WasteReportDetailsState();
}

class _WasteReportDetailsState extends State<WasteReportDetails> {
  late ShakeDetector _shakeDetector;

  @override
  void initState() {
    super.initState();

    _shakeDetector = ShakeDetector(onShake: () => widget.reportWasteCubit.deleteReport(context, widget.reportId));

    _shakeDetector.startListening();
  }

  @override
  void dispose() {
    _shakeDetector.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ReportDetailsCubit>()..loadReportDetails(widget.reportId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Waste Report Details'), foregroundColor: Colors.black, elevation: 0),
        body: BlocBuilder<ReportDetailsCubit, ReportDetailsState>(
          builder: (context, state) {
            if (state is ReportDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ReportDetailsError) {
              return Center(child: Text(state.message));
            }

            if (state is ReportDetailsLoaded) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: double.infinity, child: Image.network('${ApiEndpoints.url}/${state.reportDetails.imagePath}')),

                    // Waste Information Section
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Description:', state.reportDetails.description),
                          const SizedBox(height: 12),
                          _buildInfoRow('Waste Type:', state.reportDetails.wasteType),
                          const SizedBox(height: 12),
                          _buildStatusRow('Status:', state.reportDetails.status.toUpperCase()),
                          const SizedBox(height: 12),
                          _buildInfoRow('Reported by:', '${state.reportDetails.userObject.name} (${state.reportDetails.userObject.email})'),
                          const SizedBox(height: 20),
                          if (state.reportDetails.status == 'approved') _buildInfoRow('Points Awarded:', '${state.reportDetails.pointsAwarded}'),
                          const SizedBox(height: 20),

                          // Action Buttons
                          Builder(
                            builder: (context) {
                              return Row(
                                children: [
                                  ElevatedButton(
                                    onPressed:
                                        () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (context) => BlocProvider.value(
                                                  value: widget.reportWasteCubit,
                                                  child: ReportWasteScreen(report: state.reportDetails),
                                                ),
                                          ),
                                        ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    ),
                                    child: const Text('Edit Report'),
                                  ),
                                  const SizedBox(width: 12),
                                  ElevatedButton(
                                    onPressed: () => widget.reportWasteCubit.deleteReport(context, state.reportDetails.id),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    ),
                                    child: const Text('Delete Report'),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // Map Section
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Waste Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 300,
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(state.reportDetails.location.lat, state.reportDetails.location.lng),
                          initialZoom: 15,
                        ),
                        children: [
                          TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.example.app'),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(state.reportDetails.location.lat, state.reportDetails.location.lng),
                                width: 80,
                                height: 80,
                                child: const Icon(Icons.location_on, color: Colors.blue, size: 40),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
        Expanded(child: Text(value)),
      ],
    );
  }

  Widget _buildStatusRow(String label, String status) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: Colors.orange.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
          child: Text(status, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
