import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wastemanagement/core/common/permission_checker/permission_checker.dart';
import 'package:wastemanagement/features/dashboard/data/model/user_report.dart';

import '../../../../app/constants/api_endpoints.dart';
import '../view_model/report_waste/report_waste_cubit.dart';

class ReportWasteScreen extends StatefulWidget {
  final UserReport? report;
  const ReportWasteScreen({super.key, this.report});

  @override
  State<ReportWasteScreen> createState() => _ReportWasteScreenState();
}

class _ReportWasteScreenState extends State<ReportWasteScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ReportWasteCubit>().init(widget.report);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.report != null ? AppBar(title: const Text('Update Waste Report'), foregroundColor: Colors.black, elevation: 0) : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: context.read<ReportWasteCubit>().formKey,
          child: Column(
            children: [
              const Align(alignment: Alignment.centerLeft, child: Text("Report Waste", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
              const SizedBox(height: 4),
              const Text("Help keep the environment clean by reporting waste in your area.", style: TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 12),

              // Description Field
              BlocBuilder<ReportWasteCubit, ReportWasteState>(
                builder: (context, state) {
                  return TextFormField(
                    onTapAlwaysCalled: false,
                    initialValue: state.description,
                    onChanged: (text) => context.read<ReportWasteCubit>().updateDescription(text),
                    validator: (text) => text == null || text.trim().isEmpty ? "Description cannot be empty" : null,
                    decoration: InputDecoration(
                      hintText: "Describe the waste issue...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    maxLines: 2,
                  );
                },
              ),
              const SizedBox(height: 12),

              // Waste Type Dropdown
              BlocBuilder<ReportWasteCubit, ReportWasteState>(
                builder: (context, state) {
                  return DropdownButtonFormField<String>(
                    value: state.selectedWasteType,
                    validator: (value) => value == null ? "Please select a waste type" : null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    hint: const Text("Select Waste Type"),
                    items:
                        context.read<ReportWasteCubit>().wasteTypes.map((type) {
                          return DropdownMenuItem(value: type, child: Text(type));
                        }).toList(),
                    onChanged: (value) => context.read<ReportWasteCubit>().updateWasteType(value),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Image Upload Button
              ElevatedButton(
                onPressed: () {
                  final cubit = context.read<ReportWasteCubit>();

                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          backgroundColor: Colors.grey[300],
                          title: const Text("Select Image Source"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () async {
                                  await PermissionChecker.checkCameraPermission();
                                  cubit.browseImage(ImageSource.camera);
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.camera, color: Colors.white),
                                label: const Text('Camera'),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  await PermissionChecker.checkCameraPermission();
                                  cubit.browseImage(ImageSource.gallery);
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.image, color: Colors.white),
                                label: const Text('Gallery'),
                              ),
                            ],
                          ),
                        ),
                  );
                },
                child: const Text("Upload an Image"),
              ),
              const SizedBox(height: 12),

              // Image Preview
              BlocBuilder<ReportWasteCubit, ReportWasteState>(
                builder: (context, state) {
                  return state.image != null
                      ? SizedBox(height: 200, child: Image.file(state.image!, fit: BoxFit.cover))
                      : widget.report != null
                      ? SizedBox(height: 200, child: Image.network('${ApiEndpoints.url}/${widget.report!.imagePath}'))
                      : const SizedBox();
                },
              ),
              const SizedBox(height: 12),

              // Map
              const Text("Click on the map to pinpoint the waste location."),
              const SizedBox(height: 8),
              BlocBuilder<ReportWasteCubit, ReportWasteState>(
                builder: (context, state) {
                  return SizedBox(
                    height: 200,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: state.selectedLocation,
                        initialZoom: 13.0,
                        onTap: (_, latLng) => context.read<ReportWasteCubit>().updateLocation(latLng),
                      ),
                      children: [
                        TileLayer(urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", subdomains: ['a', 'b', 'c']),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: state.selectedLocation,
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.location_on, size: 40, color: Colors.blue),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Submit Button
              ElevatedButton(
                onPressed: () async {
                  if (widget.report != null) {
                    await context.read<ReportWasteCubit>().updateReport(context, widget.report!.id);
                    return;
                  }
                  await context.read<ReportWasteCubit>().submitReport(context);
                },
                child: const Text("Submit Report"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
