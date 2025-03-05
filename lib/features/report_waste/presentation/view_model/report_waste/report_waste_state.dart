part of 'report_waste_cubit.dart';

class ReportWasteState extends Equatable {
  final String description;
  final String? selectedWasteType;
  final LatLng selectedLocation;
  final File? image;

  const ReportWasteState({this.description = "", this.selectedWasteType, this.selectedLocation = const LatLng(27.7172, 85.3240), this.image});

  ReportWasteState copyWith({String? description, String? selectedWasteType, LatLng? selectedLocation, File? image}) {
    return ReportWasteState(
      description: description ?? this.description,
      selectedWasteType: selectedWasteType ?? this.selectedWasteType,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      image: image ?? this.image,
    );
  }

  @override
  List<Object?> get props => [description, selectedWasteType, selectedLocation, image];
}
