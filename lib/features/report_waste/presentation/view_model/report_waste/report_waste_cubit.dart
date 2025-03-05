import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:wastemanagement/features/dashboard/data/model/user_report.dart';
import 'package:wastemanagement/features/home/presentation/view_model/home_cubit.dart';
import 'package:wastemanagement/features/report_waste/domain/usecase/create_report.dart';

import '../../../../home/presentation/view/bottom_view_model/dashboard_bloc.dart' show DashboardBloc;
import '../../../../home/presentation/view/bottom_view_model/dashboard_event.dart';
import '../../../data/model/report_waste_request.dart';
import '../../../domain/usecase/delete_report.dart';
import '../../../domain/usecase/update_report.dart';
import '../../widgets/delete_confirmation_dialog.dart';

part 'report_waste_state.dart';

class ReportWasteCubit extends Cubit<ReportWasteState> {
  final CreateReport createReport;
  final UpdateReport updateReportUsecase;
  final DeleteReport deleteReportUsecase;
  ReportWasteCubit(this.createReport, this.updateReportUsecase, this.deleteReportUsecase) : super(ReportWasteState());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<String> wasteTypes = ["E-waste", "Paper waste", "Metal waste", "Plastic waste", "Stationary waste", "Organic waste", "Others"];

  Future<void> browseImage(ImageSource source) async {
    try {
      final photo = await ImagePicker().pickImage(source: source);
      if (photo != null) {
        emit(state.copyWith(image: File(photo.path)));
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void init(UserReport? report) {
    if (report != null) {
      emit(
        state.copyWith(
          description: report.description,
          selectedWasteType: report.wasteType,
          selectedLocation: LatLng(report.location.lat, report.location.lng),
        ),
      );
    }
  }

  void updateWasteType(String? type) {
    emit(state.copyWith(selectedWasteType: type));
  }

  void updateDescription(String description) {
    emit(state.copyWith(description: description));
  }

  void updateLocation(LatLng location) {
    emit(state.copyWith(selectedLocation: location));
  }

  Future<void> submitReport(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    if (state.image == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select an image"), duration: Duration(seconds: 2)));
      return;
    }

    final request = ReportWasteRequest(
      description: state.description,
      wasteType: state.selectedWasteType ?? '',
      lat: state.selectedLocation.latitude,
      lng: state.selectedLocation.longitude,
      imageFile: state.image!,
    );
    final res = await createReport(request);
    res.fold((l) => print("Error creating report: ${l.message}"), (r) {
      clearForm();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(r), duration: Duration(seconds: 2)));

      if (context.mounted) {
        context.read<DashboardBloc>().add(LoadDashboardData());
        context.read<HomeCubit>().onTabTapped(0);
      }
    });
  }

  Future<void> updateReport(BuildContext context, String id) async {
    if (!formKey.currentState!.validate()) return;
    if (state.image == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select an image"), duration: Duration(seconds: 2)));
      return;
    }

    final request = ReportWasteRequest(
      id: id,
      description: state.description,
      wasteType: state.selectedWasteType ?? '',
      lat: state.selectedLocation.latitude,
      lng: state.selectedLocation.longitude,
      imageFile: state.image!,
    );
    final res = await updateReportUsecase(request);
    res.fold((l) => print("Error creating report: ${l.message}"), (r) {
      clearForm();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(r), duration: Duration(seconds: 2)));

      if (context.mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        context.read<HomeCubit>().onTabTapped(0);
      }
    });
  }

  Future<void> deleteReport(BuildContext context, String id) async {
    final toDelete = await showDialog<bool>(context: context, builder: (context) => DeleteConfirmationDialog());
    if (toDelete == null || !toDelete) return;

    final res = await deleteReportUsecase(id);
    res.fold((l) => print("Error deleting report: ${l.message}"), (r) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Report Deleted Successfully!'), duration: Duration(seconds: 2)));

      if (context.mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        context.read<DashboardBloc>().add(LoadDashboardData());
      }
    });
  }

  void clearForm() {
    formKey.currentState!.reset();
    emit(ReportWasteState());
  }
}
