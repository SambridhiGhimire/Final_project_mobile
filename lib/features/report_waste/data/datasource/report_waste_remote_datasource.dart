import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:wastemanagement/app/constants/api_endpoints.dart';
import 'package:wastemanagement/features/report_waste/data/model/report_waste_request.dart';
import 'package:wastemanagement/features/report_waste/data/model/report_waste_response.dart';

import '../model/report_details.dart';

abstract class ReportWasteRemoteDatasource {
  Future<ReportWasteResponse> reportWaste(ReportWasteRequest request);

  Future<ReportDetails> getReportDetails(String reportId);

  Future<ReportWasteResponse> updateReport(ReportWasteRequest request);

  Future<bool> deleteReport(String id);
}

class ReportWasteRemoteDatasourceImpl implements ReportWasteRemoteDatasource {
  final Dio dio;

  const ReportWasteRemoteDatasourceImpl(this.dio);

  @override
  Future<ReportWasteResponse> reportWaste(ReportWasteRequest request) async {
    try {
      FormData formData = FormData.fromMap({
        "description": request.description,
        "wasteType": request.wasteType,
        "location": json.encode({"lat": request.lat, "lng": request.lng}),
        "image": await MultipartFile.fromFile(
          request.imageFile.path,
          filename: request.imageFile.path.split("/").last + DateTime.now().toString(),
          contentType: DioMediaType.parse('image/jpeg'),
        ),
      });

      Response response = await dio.post(
        ApiEndpoints.createReport,
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      final responseData = response.data;

      return ReportWasteResponse.fromJson(responseData);
    } on DioException catch (e) {
      throw Exception('Dio Error: ${e.message ?? 'Unknown error'}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<ReportDetails> getReportDetails(String reportId) async {
    try {
      Response response = await dio.get('${ApiEndpoints.getReportDetails}/$reportId');

      final responseData = response.data;

      return ReportDetails.fromJson(responseData);
    } on DioException catch (e) {
      throw Exception('Dio Error: ${e.message ?? 'Unknown error'}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<ReportWasteResponse> updateReport(ReportWasteRequest request) async {
    try {
      FormData formData = FormData.fromMap({
        "description": request.description,
        "wasteType": request.wasteType,
        "location": json.encode({"lat": request.lat, "lng": request.lng}),
        "image": await MultipartFile.fromFile(
          request.imageFile.path,
          filename: request.imageFile.path.split("/").last + DateTime.now().toString(),
          contentType: DioMediaType.parse('image/jpeg'),
        ),
      });

      Response response = await dio.put(
        ApiEndpoints.editReport(request.id!),
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      final responseData = response.data;

      return ReportWasteResponse.fromJson(responseData);
    } on DioException catch (e) {
      throw Exception('Dio Error: ${e.message ?? 'Unknown error'}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<bool> deleteReport(String id) async {
    try {
      await dio.delete(ApiEndpoints.deleteReport(id));

      return true;
    } on DioException catch (e) {
      throw Exception('Dio Error: ${e.message ?? 'Unknown error'}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
