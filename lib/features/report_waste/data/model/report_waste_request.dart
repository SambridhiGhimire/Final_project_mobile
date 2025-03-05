import 'dart:io';

class ReportWasteRequest {
  final String? id;
  final String description;
  final String wasteType;
  final double lat;
  final double lng;
  final File imageFile;

  ReportWasteRequest({this.id, required this.description, required this.wasteType, required this.lat, required this.lng, required this.imageFile});

  Map<String, dynamic> toJson() {
    return {"description": description, "wasteType": wasteType, "lat": lat, "lng": lng, "image": imageFile};
  }

  @override
  String toString() {
    return 'ReportWasteRequest(description: $description, wasteType: $wasteType, lat: $lat, lng: $lng, imageFile: $imageFile)';
  }
}
